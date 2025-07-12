//
//  AuthRequest.swift
//  AppAuthDemo
//
//

import Foundation

public struct AuthRequest {
    let url: String
    var grantType: GrantType = .authorization
    var code: String = ""
    let clientId: String
    var clientSecret: String = ""
    var redirectUri: String = ""
    var refreshToken: String = ""
}

public enum GrantType: String {
    case authorization = "authorization_code"
    case refreshToken = "refresh_token"
}
