//
//  TokenRequestRepoInterface.swift
//  AppAuthDemo
//
//

import Foundation
import Alamofire

struct TokenRequestRepo: TokenRequestRepoInterface {
    
//    Content-Type: application/x-www-form-urlencoded
    private struct TokenReqParams:Encodable {
        let grant_type: String
        let code: String
        let client_id: String
        let client_secret:String
        let redirect_uri:String
    }
    
    func getToken(req: AuthRequest) async throws -> Token {
        let params = TokenReqParams(grant_type: req.grantType.rawValue,
                                    code: req.code,
                                    client_id: req.clientId,
                                    client_secret: req.clientSecret,
                                    redirect_uri: req.redirectUri)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(req.url,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 
                    do {
                        let token = try decoder.decode(Token.self, from: data)
                        continuation.resume(returning: token)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
          }
    }
}
