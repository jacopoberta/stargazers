//
//  RepoView.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 15-06-22.
//

import SwiftUI

struct RepoView: View {
    // Access StorageProvider instance
    @EnvironmentObject private var storageProvider: RepoStorageProvider
    
    @State private var showAddRepoSheet = false
    @State private var ownerName = ""
    @State private var repoName = ""
    
    var body: some View {
        List {
            ForEach(storageProvider.repos) { item in
                
                NavigationLink(destination: StargazersConfigurator.configureStargazersView(with: item)) {
                    HStack (alignment: .center) {
                        VStack (alignment: HorizontalAlignment.trailing){
                            Text("Owner: ").bold()
                            Text("Repo: ").bold()
                            
                        }
                        VStack (alignment: HorizontalAlignment.leading){
                            Text(item.ownerName!)
                            Text(item.repoName!)
                        }
                        
                    }
                }
                
            } .onDelete(perform: deleteItems)
            
        }
        .navigationTitle("Stragazers Viewer")
        .sheet(isPresented: $showAddRepoSheet) {
            VStack (spacing:20){
                Text("Insert Owner And Repo name")
                TextField("Owner Name", text: $ownerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                TextField("Repo Name", text: $repoName )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                Spacer()
                Button("ADD REPO") {
                    showAddRepoSheet.toggle()
                    storageProvider.saveRepo(named: repoName, owner: ownerName)
                }
                
                Button("CANCEL") {
                    showAddRepoSheet.toggle()
                }
                .foregroundColor(Color.red)
            }
            
            .padding()
            .navigationTitle("Add new Repo")
        }
        .toolbar {
            Button(action: {
                //reset textfields before showing sheet
                ownerName = ""
                repoName = ""
                showAddRepoSheet.toggle()
            }) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
    
    private func addItem(ownerName: String,repoName: String) {
        
      
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            storageProvider.deleteRepo(at: offsets)
        }
    }
}

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView().environmentObject(RepoStorageProvider.preview)
    }
}
