//
//  LoginURL.swift
//  AppAuthDemo
//
//

import Foundation

struct LoginURL {
    
    let url:String
    let scope:[String]
    let responseType:String
    let redirectURI:String
    let clientId:String
    
    var loginURL:String {
        
        let url =  "\(url)" +
        "scope=\(scope.joined(separator: "+"))&" +
        "response_type=\(responseType)&" +
        "redirect_uri=\(redirectURI)&" +
        "client_id=\(clientId)"
        return url
        
    }
}
