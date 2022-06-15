//
//  Repo+PreviewProvider.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//

import Foundation

import CoreData
import Foundation

// Exists to provide a Repo to use with Views
extension Repo {
    static var example: Repo {        
        // Get the first repo from the in-memory Core Data store
        let context = RepoStorageProvider.preview.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Repo> = Repo.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }
    
}
