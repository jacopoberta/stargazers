//
//  StargazersView.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import SwiftUI

struct StargazersView: View {
    
    @ObservedObject var viewModel: StargazersViewModel
    
    var body: some View {
        List {
            Section (header: Text("\(viewModel.repo.ownerName!): \(viewModel.repo.repoName!)")) {
                ForEach(viewModel.users) { user in
                    StargazersRowConfigurator.configureStargazersDetailView(with: user)
                }
            }
            
        }.navigationTitle("Stargazers")
        .onAppear(perform: {
            viewModel.onAppear()
        })
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        
        StargazersView(viewModel: StargazersViewModel.stargazersViewModelPreview)
    }
}
