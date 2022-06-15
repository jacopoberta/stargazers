//
//  StargazersViewModel.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation
import Combine

class StargazersViewModel: ObservableObject {
    @Published public var users: [User] = []
    
    private var stargazersService: StargazersServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let repo: Repo
    
    init(users: [User] = [],
         stargazersService: StargazersServiceProtocol = StargazersService(), repo: Repo) {
        self.repo = repo
        self.users = users
        self.stargazersService = stargazersService
    }
    
    public func onAppear() {
        self.getUsers()
    }
    
    private func getUsers() {
        stargazersService.getStargazers(ownerName: repo.ownerName!, repoName: repo.repoName!)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
    
    public static var stargazersViewModelPreview : StargazersViewModel{
        let viewmodel: StargazersViewModel = StargazersViewModel(users: StargazersService.stargazersMock,repo: Repo.example)
        return viewmodel
    }
    
    
}
