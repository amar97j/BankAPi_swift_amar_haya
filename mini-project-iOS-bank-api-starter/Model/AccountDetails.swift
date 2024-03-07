//
//  AccountDetails.swift
//  mini-project-iOS-bank-api-starter
//
//  Created by Amora J. F. on 06/03/2024.
//

import Foundation
struct AccountDetails:Codable {
    let username: String
    let email: String
    let balance: Double
    let id: Int
}
