//
//  StargazersConfigurator.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation

final class StargazersConfigurator {
    
    public static func configureStargazersView(with repo: Repo
    ) -> StargazersView {
        
        let viewModel:StargazersViewModel = StargazersViewModel(repo: repo) 
        let usersView = StargazersView(viewModel: viewModel)
        return usersView
    }
    
}
