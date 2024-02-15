//
//  ContentView.swift
//  PhotonSchoolname
//
//  Created by Weng Seong Cheang on 2/15/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    //@StateObject var schools = ApiHandler.shared
    @StateObject var fetcher = MyModelFetcher() // Class fetches data
    @State private var models: [[String:String]] = [] // storing the data
    @State private var errorMessage: String = "" // if any
    @StateObject var cancellables = Cancellables()
    @State private var showAlert = false // to show alert of what was clicked
    @State private var selectedSchoolIndex = 0 // save index clicked to show any other data if needed
        
    var body: some View {
        VStack {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(models.indices, id: \.self) { index in
                    Button(action: {
                        selectedSchoolIndex = index
                        showAlert = true
                    }) {
                        Text(models[index]["school_name"] ?? "No name")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .onAppear { // on appear fetches data when this page is viewed, alternatively start fetching the data before this page is viewed.
            fetcher.fetchData()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        errorMessage = "Error: \(error.localizedDescription)"
                    }
                }, receiveValue: { receivedModels in
                    models = receivedModels
                })
                .store(in: &cancellables.set)
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text(models[selectedSchoolIndex]["school_name"] ?? "No name"), message: Text(models[selectedSchoolIndex]["overview_paragraph"] ?? "No Paragraph"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}

class Cancellables: ObservableObject {
    var set = Set<AnyCancellable>()
}
