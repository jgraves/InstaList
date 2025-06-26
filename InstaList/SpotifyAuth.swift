//
//  SpotifyAuth.swift
//  InstaList
//
//  Created by Jon on 6/11/25.
//

import Foundation
import AuthenticationServices
import CommonCrypto
import OSLog

@MainActor
final class SpotifyAuth: NSObject {
    static let shared = SpotifyAuth()
    
    private let clientID = "3ff12c8d8ea749d98dc5a84e0d8b49bf" //assigned by Spotify App Dashboard
    private let redirectURI = "instalist://callback"
    private let scopes = "playlist-modify-public playlist-modify-private"
    private let logger = Logger(subsystem: "InstaList", category: "SpotifyAuth")
    
    
    func login() async throws -> SpotifyTokenResponse {
        let codeVerifier = Self.generateCodeVerifier()
        let codeChallenge = Self.generateCodeChallenge(from: codeVerifier)
        
        let authURL = URL(string:
            "https://accounts.spotify.com/authorize" +
            "?response_type=code" +
            "&client_id=\(clientID)" +
            "&scope=\(scopes)" +
            "&redirect_uri=\(redirectURI)" +
            "&code_challenge_method=S256" +
            "&code_challenge=\(codeChallenge)"
        )!
        
        let accessCode = try await authenticate(withURL: authURL)
        
        return try await exchangeCodeForTokens(withCodeVerifier: codeVerifier, code: accessCode)
    }

    private func authenticate(withURL authURL : URL) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "instalist") { callbackURL, error in
                guard
                    error == nil,
                    let callbackURL = callbackURL,
                    let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems,
                    let code = queryItems.first(where: { $0.name == "code" })?.value
                else {
                    let authError = NSError(domain: "SpotifyAuth",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""])
                    continuation.resume(throwing: authError)
                    return
                }
                
                self.logger.debug("Authorization code: \(code, privacy: .sensitive)")
                continuation.resume(returning: code)
            }
            
            session.presentationContextProvider = self
            session.start()
        }
    }
    
    private func exchangeCodeForTokens(withCodeVerifier codeVerifier: String, code: String) async throws -> SpotifyTokenResponse {
        let components = URLComponents(string: "https://accounts.spotify.com/api/token")!
        let params = [
            "client_id": clientID,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "code_verifier": codeVerifier
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }
            .joined(separator: "&")
            .data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request) //creates and uses a URLSessionDataTask under the hood
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "SpotifyAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to exchange code for token"])
        }

        let decoded = try JSONDecoder().decode(SpotifyTokenResponse.self, from: data)
        return decoded
    }
    
    private static func generateCodeVerifier() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        return String((0..<128).map { _ in characters.randomElement()! })
    }

    private static func generateCodeChallenge(from verifier: String) -> String {
        let data = verifier.data(using: .utf8)! //this should never be nil given we're generating the verifier string ourselves

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }

        let challengeData = Data(digest)
        return challengeData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

extension SpotifyAuth: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes.compactMap {$0 as? UIWindowScene}
            .flatMap {$0.windows}
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
