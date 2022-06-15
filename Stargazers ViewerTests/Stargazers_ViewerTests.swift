//
//  Stargazers_ViewerTests.swift
//  Stargazers ViewerTests
//
//  Created by jacopo berta on 14-06-22.
//

import XCTest
import Foundation
import Combine
@testable import Stargazers_Viewer

class Stargazers_ViewerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserFromJSON() throws {
        let jsonString: String = "{\"login\":\"test_login\",\"avatar_url\":\"icon_test\"}"
        let jsonData = jsonString.data(using: .utf8)!
        let user: User = try! JSONDecoder().decode(User.self, from: jsonData)
        
        XCTAssert(user.iconUrl == "icon_test")
        XCTAssert(user.name == "test_login")
    }
    
    func testRetrieveStargazers() throws {
        // create the expectation
        let exp = expectation(description: "Loading stargazers")
        // wait three seconds for all outstanding expectations to be fulfilled
        let stargazersService: StargazersServiceProtocol = StargazersService()
        var cancellables = Set<AnyCancellable>()
        
        stargazersService.getStargazers(ownerName: "scotchfield", repoName: "party-party-party")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    XCTFail()
                    exp.fulfill()
                case .finished: break
                }
            } receiveValue: {users in
                XCTAssert(users.count > 0)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
    }
    
    func testRetrieveAvatar() throws {
        // create the expectation
        let exp = expectation(description: "Loading avatar")
        // wait three seconds for all outstanding expectations to be fulfilled
        let userPictureService: UserPictureServiceProtocol = UserPictureService()
        var cancellables = Set<AnyCancellable>()
        userPictureService.getUserAvatarData(urlString: "https://avatars.githubusercontent.com/u/5611966?v=4")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    XCTFail()
                    exp.fulfill()
                case .finished: break
                }
            } receiveValue: { data in
                XCTAssertNotNil(data)
                exp.fulfill()
            }
            .store(in: &cancellables)
       
        
        waitForExpectations(timeout: 3)
    }

}
