//
//  TokenRequestRepo.swift
//  AppAuthDemo
//
//

import Foundation

protocol TokenRequestRepoInterface {
    func getToken(req:AuthRequest) async throws -> Token
}
