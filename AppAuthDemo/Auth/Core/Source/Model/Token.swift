//
//  Token.swift
//  AppAuthDemo
//
//

import Foundation

struct Token: Decodable {
    let accessToken: String
    let idToken: String
    let scope: String
    let refreshToken: String
    let tokenType: String
    let expiresAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case idToken = "id_token"
        case scope
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        idToken = try container.decode(String.self, forKey: .idToken)
        scope = try container.decode(String.self, forKey: .scope)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        let expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        expiresAt = Date().addingTimeInterval(TimeInterval(expiresIn))
    }
}
