//
//  StargazerRowViewModel.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import UIKit
import Combine

class StargazerRowViewModel: ObservableObject {
    @Published public var avatar: UIImage = UIImage()
    
    public let user: User
    
    private var userPictureService: UserPictureServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User,
         userPictureService: UserPictureServiceProtocol = UserPictureService()) {
        
        self.user = user
        self.userPictureService = userPictureService
    }
    
    public func onAppear() {
        getAvatarData()
    }
    
    private func getAvatarData() {
        guard let pictureUrlString = user.iconUrl else {
            print("URL doesn't exist")
            return
        }
        
        userPictureService.getUserAvatarData(urlString: pictureUrlString)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error): print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] data in
                guard let image = UIImage(data: data) else { return }
                self?.avatar = image
            }
            .store(in: &cancellables)
    }
}
