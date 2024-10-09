//
//  User.swift
//
//
//  Created by Dmitriy Suprun on 8.10.24.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "passwordHash")
    var passwordHash: String

    init() { }

    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }

    func toDTO() -> UserDTO {
        .init(id: self.id, username: self.username, passwordHash: self.passwordHash)
    }
}
