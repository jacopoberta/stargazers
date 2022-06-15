//
//  RepoStorageProvider.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import CoreData
import Foundation

// Must conform to ObservableObject to be passed through the environment
class RepoStorageProvider: ObservableObject {
    
    // For showing the list of repos
    @Published private(set) var repos: [Repo] = []
    
    // For initializing the Core Data stack and loading the Core Data model file
    let persistentContainer: NSPersistentContainer
    
    // For use with Xcode Previews, provides some data to work with for examples
    static var preview: RepoStorageProvider = {
        
        // Create an instance of the provider that runs in memory only
        let storageProvider = RepoStorageProvider(inMemory: true)
        
        // Add a few test repos
        
        for i in 0..<10 {
            storageProvider.saveRepo(named: "repo \(i)", owner: "owner \(i)")
        }
        
        // Now save these repos in the Core Data store
        do {
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            // Something went wrong 😭
            print("Failed to save test repos: \(error)")
        }
        
        return storageProvider
    }()
    
    init(inMemory: Bool = false) {
        
        // Access the model file
        persistentContainer = NSPersistentContainer(name: "Stargazers_Viewer")
        
        // Don't save information for future use if running in memory...
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Attempt to load persistent stores (the underlying storage of data)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                
                // For now, any failure to load the model is a programming error, and not recoverable
                fatalError("Core Data store failed to load with error: \(error)")
            } else {
                
                print("Successfully loaded persistent stores.")
                
                // Get all the repos
                self.repos = self.getAllRepos()
            }
            
        }
    }
    
}

// Save a repo
extension RepoStorageProvider {
    
    func saveRepo(named name: String, owner ownerName:String) {
        
        // New Repo instance is tied to the managed object context
        let repo = Repo(context: persistentContainer.viewContext)
        
        // Set the name for the new repo
        repo.id = UUID()
        repo.timestamp = Date()
        repo.ownerName = ownerName
        repo.repoName = name
        
        do {
            
            // Persist the data in this managed object context to the underlying store
            try persistentContainer.viewContext.save()
            
            print("Repo saved successfully")
            
            // Refresh the list of repos
            repos = getAllRepos()
            
        } catch {
            
            // Something went wrong 😭
            print("Failed to save repo: \(error)")
            
            // Rollback any changes in the managed object context
            persistentContainer.viewContext.rollback()
            
        }
        
    }
    
}

// Delete a repo
extension RepoStorageProvider {
    
    func deleteRepo(at offsets: IndexSet) {
        for offset in offsets {
            let repoToDelete = repos[offset]
            deleteRepo(repoToDelete)
        }
    }
    
    
    func deleteRepo( _ repo: Repo) {
        
        persistentContainer.viewContext.delete(repo)
        
        do {
            
            try persistentContainer.viewContext.save()
            
            print("Repo deleted.")
            
            // Refresh the list of repos
            repos = getAllRepos()
            
        } catch {
            
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
            
        }
        
    }
    
}

// Update a repo
extension RepoStorageProvider {
    
    func updateRepos() {
        
        do {
            // Tell SwiftUI that the list of repo is being modified
            objectWillChange.send()
            
            // Actually persist/save the changes to the managed object context
            try persistentContainer.viewContext.save()
            print("Repo updated.")
            
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
        }
        
    }
    
}

// Get all the repos
extension RepoStorageProvider {
    
    // Made private because view models will access the repos retrieved from Core Data via the Repos array in RepoStorageProvider
    private func getAllRepos() -> [Repo] {
        
        // Must specify the type with annotation, otherwise Xcode won't know what overload of fetchRequest() to use (we want to use the one for the Repo entity)
        // The generic argument <Repo> allows Swift to know what kind of managed object a fetch request returns, which will make it easier to return the list of repos as an array
        let fetchRequest: NSFetchRequest<Repo> = Repo.fetchRequest()
        
        do {
            
            // Return an array of Repo objects, retrieved from the Core Data store
            return try persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch {
            
            print("Failed to fetch repos \(error)")
            
        }
        
        // If an error occured, return nothing
        return []
    }
    
}
