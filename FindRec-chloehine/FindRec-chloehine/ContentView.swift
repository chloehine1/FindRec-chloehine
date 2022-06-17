//
//  ContentView.swift
//  FindRec-chloehine
//
//  Created by Chloé Hine on 09/06/2022.
//

import SwiftUI

struct Result : Codable {
    var trackId : Int
    var trackName : String
    //var trackImage : Image
    var trackTime : Int
}

struct Response : Codable {
    var results : [Result]
}

struct ContentView: View {
    
    
    @State private var Results = [Result]()
    @State private var Search = ""
    
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/itunes/search?term=\(self.Search)&country=fr&limit=10&media=music") else {
            print("invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data{
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                    DispatchQueue.main.async {
                        self.Results = decodedResponse.results
                    }
                    return
                    }
                }
            print("Fetch failed : \(error?.localizedDescription ?? "Unkown error")")
        }.resume()
        }
    
    var body: some View {
        NavigationView {
            List(Results, id: \.trackId){ item in
                Text(item.trackName)
                }.onAppear(perform: loadData)
            .navigationBarTitle("My song")
            .navigationBarItems(leading: TextField("Search", text: $Search), trailing: Button(action: {
                self.loadData()
                            }, label: {
                Image(systemName:"magnifyingglass")
            }))
        }
    }
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
}

