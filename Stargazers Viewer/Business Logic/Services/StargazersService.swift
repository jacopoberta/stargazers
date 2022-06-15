//
//  StargazersService.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation
import Combine

protocol StargazersServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func getStargazers(ownerName: String, repoName: String) -> AnyPublisher<[User], Error>
}

final class StargazersService: StargazersServiceProtocol {
    
    let networker: NetworkerProtocol
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    
    func getStargazers(ownerName: String, repoName: String) -> AnyPublisher<[User], Error> {
        let endpoint = Endpoint.users(ownerName: ownerName, repoName: repoName)
        
        return networker.get(type: [User].self,
                             url: endpoint.url,
                             headers: endpoint.headers)
    }
    
    //used for previews
    static public var stargazersMock: [User]{
        var users: [User] = []
        for i in 0..<10 {
            users.append(User(name: "test \(i)", iconUrl: "test \(i)"))
        }
        return users
    }
}
