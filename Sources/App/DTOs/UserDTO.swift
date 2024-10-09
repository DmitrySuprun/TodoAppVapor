//
//  UserDTO.swift
//
//
//  Created by Dmitriy Suprun on 8.10.24.
//

import Fluent
import Vapor

struct UserDTO: Content {
    var id: UUID?
    var username: String
    var passwordHash: String
    
    func toModel() -> User {
        let model = User()
        
        model.id = self.id
        model.username = self.username
        model.passwordHash = self.passwordHash
        return model
    }
}

