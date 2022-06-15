//
//  Endpoint+Users.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation

extension Endpoint {
    //used to normalize api path for stargazers
    static func users(ownerName: String, repoName: String) -> Self {
        return Endpoint(path: "/repos/\(ownerName)/\(repoName)/stargazers")
    }
}
