//
//  AuthController.swift
//
//
//  Created by Dmitriy Suprun on 8.10.24.
//

import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("register", use: register)
        authRoutes.post("login", use: login)
    }

    @Sendable
    func register(req: Request) async throws -> HTTPStatus {
        let user = try req.content.decode(User.self)
        user.passwordHash = try Bcrypt.hash(user.passwordHash)
        try await user.save(on: req.db)
        return .created
    }
    
    @Sendable
    func login(req: Request) async throws -> TokenResponse {
        let userDTO = try req.content.decode(UserDTO.self)
        guard let user = try await User.query(on: req.db)
            .filter(\.$username == userDTO.username)
            .first(),
            try Bcrypt.verify(userDTO.passwordHash, created: user.passwordHash) else {
            throw Abort(.unauthorized)
        }
        
        let token = try createToken(for: user, on: req)
        return TokenResponse(token: token)
    }

    private func createToken(for user: User, on req: Request) throws -> String {
        let payload = UserToken(exp: .init(value: .distantFuture), userID: try user.requireID())
        return try req.jwt.sign(payload)
    }
}

struct TokenResponse: Content {
    let token: String
}
