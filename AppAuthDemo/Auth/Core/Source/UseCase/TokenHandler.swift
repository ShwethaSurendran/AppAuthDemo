//
//  TokenHandler.swift
//  AppAuthDemo
//
//

import Foundation

actor TokenHandler {
    
    // MARK: variables
    private var repo:TokenRequestRepoInterface
    private var token:Token?
    private var req: AuthRequest
    private var kTokenExpiryTimeOutLimit: Int = 60
    private var loginTask: Task<Token, Error>?
    private var tokenTask: Task<Token, Error>?
    
    // MARK:  when user login for the first time
    init(req: AuthRequest, 
         token: Token? = nil,
         repo: TokenRequestRepoInterface) {
        self.req = req
        self.token = token
        self.repo = repo
    }
    
    // MARK: update token incase logged in again
    func getToken(req:AuthRequest) async throws -> Token? {
        self.req = req
        return try await self.requestForToken()
    }
    
    // MARK: get token for first login
    func requestForToken() async throws -> Token? {
        do {
            self.token = try await login()
            return self.token
        } catch {
            throw error
        }
    }
    
    // MARK: call token request
    private func login() async throws -> Token? {
        if let loginTask {
            return try await loginTask.value
        }
        
        let task = Task {
            defer {
                loginTask = nil
            }
            return try await repo.getToken(req:req)
        }
        loginTask = task
        return try await task.value
    }
    
    // MARK: get token object, update if required
    func getToken() async throws -> Token? {
        //1. Check if already another task running, if yes-> all other thread must wait. no-> can go to next line
        //2.Check expiration time,
        //if yes-> If expiration time is less than one minute call refresh token.
        //no-> return token
        if let tokenTask {
            return try await tokenTask.value
        }
        
        return try await handleRequestIfRequired()
    }
    
    // MARK: Handle Request if required
    func handleRequestIfRequired() async throws -> Token? {
        if checkIfTokenExpired() {
            //call refresh token
            do {
                self.token = try await self.refreshAccessToken()
                return self.token
            } catch {
                throw error
            }
        } else {
           // return token
            return self.token
        }
    }
        
    // MARK: check if refresh token expired
    func checkIfTokenExpired() -> Bool {
        //No token object
        guard let accessToken = token else {
            return false
        }
        
        //If no expiry set, access token never expires
        guard let expiry = accessToken.expiresAt else {
            return true
        }
        
        return kTokenExpiryTimeOutLimit >= Int(expiry.timeIntervalSinceNow - Date().timeIntervalSinceNow)
    }
    
    // MARK: call refresh access token
    
    func refreshAccessToken() async throws -> Token? {
        self.req = AuthRequest(url: req.url,
                               grantType: req.grantType,
                               clientId: req.clientId,
                               refreshToken: req.refreshToken)
        let task = Task {
            defer {
                tokenTask = nil
            }
            return try await repo.getToken(req:req)
        }
        self.tokenTask = task
        return try await task.value
    }
}


