//
//  ContentVieModel.swift
//  AppAuthDemo
//
//

import Foundation
import AppAuthSwift

class ContentViewModel: ObservableObject {
    
    let kClientId = "***"
    let kRedirectURI = "***"
    @Published var loginURL:LoginURL
    @Published var token:Token?
        
    init() {
        loginURL = LoginURL (baseURL: "https://accounts.google.com/o/oauth2/v2/auth?",
                             scope: ["email","profile"],
                             responseType: "code",
                             redirectURI: kRedirectURI,
                             clientId: kClientId)
    }
}

// MARK: Handle redirection
extension ContentViewModel {
    @MainActor
    func handleRedirection(url:URL) {
        //Extract code from url
        if let code = getQueryItemValueForKey("code", url: url) {
            createAuthReq(code: code)
        } else {
            fatalError("no code found")
        }
    }
    
    func getQueryItemValueForKey(_ key: String, url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        guard let queryItems = components.queryItems else { return nil }
        return queryItems.filter {
            $0.name == key
        }.first?.value
    }
    
    @MainActor
    func createAuthReq (code: String) {
        
        let authReq = AuthRequest(url: URL(string: "https://oauth2.googleapis.com/token")!,
                              code: code,
                              clientId: kClientId,
                              redirectUri: kRedirectURI)
        Task {
            do {
                
                let newToken = try await SimplyAuth.sharedInstance.getAuthToken(request: authReq)
                do {
                    token = newToken
                    print("Debug: Login token\(String(describing: token))")

                    $token.sink {_ in
                        Task {
                            let tokenFromAuth = try await SimplyAuth.sharedInstance.getToken()
                            print("Debug: Token from SimplyAuth \(String(describing: tokenFromAuth))")
                        }
                    }
                }
                
            } catch {
                print("Debug: Error while auth req \(error)")
            }
        }
    }
}
