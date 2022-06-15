//
//  User.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation

struct User: Codable, Identifiable {
    var id = UUID()
    let  name, iconUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case iconUrl = "avatar_url"
    }
}

extension User {
    static func fake() -> Self {
        return User(name: "Test",
                    iconUrl: "First Name")
    }
}
