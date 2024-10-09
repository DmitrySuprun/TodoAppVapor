//
//  UserToken.swift
//
//
//  Created by Dmitriy Suprun on 8.10.24.
//

import Foundation
import JWT

struct UserToken: JWTPayload {
    var exp: ExpirationClaim
    var userID: UUID

    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
