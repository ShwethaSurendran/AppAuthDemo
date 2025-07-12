//
//  SimplyAuth.swift
//  AppAuthDemo
//
//

import Foundation

final class SimplyAuth {
    static var sharedInstance = SimplyAuth()
    private var tokenHandler:TokenHandler?

    // get access token from api
    func getAuthToken(req:AuthRequest, token:Token? = nil) async throws -> Token? {
        if tokenHandler == nil {
            tokenHandler = TokenHandler(req: req, 
                                        token: token,
                                        repo: TokenRequestRepo())
            if token != nil {
                return try await tokenHandler?.getToken()
            } else {
                return try await tokenHandler?.requestForToken()
            }
        } else {
            return try await tokenHandler?.getToken(req: req)
        }
    }
    
    // Return token data
    func getToken() async throws -> Token?  {
        return try await tokenHandler?.getToken()
    }
    
}

