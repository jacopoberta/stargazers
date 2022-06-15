//
//  Stargazers_ViewerApp.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import SwiftUI

@main
struct Stargazers_ViewerApp: App {
    // Create an instance of our storage provider
    @StateObject private var storageProvider = RepoStorageProvider()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                RepoConfigurator.configureRepoView()
            }// Insert storage provider into the environment
            .environmentObject(storageProvider)
        }
    }
}
