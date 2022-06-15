//
//  Networker.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation
import Combine

//Class that will be used for networking. it can be extended for other http requests (post, delete, etc...)
protocol NetworkerProtocol: AnyObject {
    typealias Headers = [String: Any]
    
    func get<T>(type: T.Type,
                url: URL,
                headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
    
    func getData(url: URL, headers: Headers) -> AnyPublisher<Data, URLError>
}

final class Networker: NetworkerProtocol {
    
    //get data from URL and try to decode it back with JSONDECODER
    func get<T>(type: T.Type,
                url: URL,
                headers: Headers) -> AnyPublisher<T, Error> where T : Decodable {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    //get data from URL
    func getData(url: URL, headers: Headers) -> AnyPublisher<Data, URLError> {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
