//
//  StargazersRowConfigurator.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 15-06-22.
//

import Foundation

final class StargazersRowConfigurator {
    public static func configureStargazersDetailView(
        with user: User)
    -> StargazerRowView {
        
        let userDetailView = StargazerRowView(
            viewModel: StargazerRowViewModel(user: user)
        )
        return userDetailView
    }
}
