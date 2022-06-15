//
//  StargazerRowView.swift
//  Stargazers Viewer
//
//  Created by jacopo berta on 14-06-22.
//
import SwiftUI

struct StargazerRowView: View {
    @ObservedObject var viewModel: StargazerRowViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    
    @State private var showingModalSheet = false
    
    var body: some View {
        HStack{
            Image(uiImage: viewModel.avatar)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35,
                       height: 35,
                       alignment: .leading)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                .padding()
                
                Text(viewModel.user.name!)

        }.onAppear(perform: {
            self.viewModel.onAppear()
        })
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StargazerRowView(
            viewModel: StargazerRowViewModel(
                user: User.fake()
            )
        )
    }
}

