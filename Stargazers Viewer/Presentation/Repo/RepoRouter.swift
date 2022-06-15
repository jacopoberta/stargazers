//
//  RepoRouter.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import SwiftUI

final class RepoRouter {
    
    public static func destinationForTappedRepo(repo: Repo) -> some View {
        return StargazersConfigurator.configureStargazersView(with: repo)
    }
}
