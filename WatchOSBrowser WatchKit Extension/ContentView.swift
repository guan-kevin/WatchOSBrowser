//
//  ContentView.swift
//  WatchOSBrowser WatchKit Extension
//
//  Created by Kevin on 12/10/21.
//

import AuthenticationServices
import SwiftUI

struct ContentView: View {
    @State var loaded = false
    @State var search: String = ""
    @State var favorited: [String: String] = [:]
    @State var showAddFavorite = false

    var body: some View {
        ScrollView {
            TextField("Search or URL", text: $search)

            Button(action: {
                guard !search.isEmpty else { return }
                if let url = URL(string: search), url.scheme?.lowercased() == "http" || url.scheme?.lowercased() == "https" {
                    // url
                    openBrowser(url: url)
                } else {
                    // search
                    if let query = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        if let url = URL(string: "https://www.startpage.com/search?q=\(query)") {
                            openBrowser(url: url)
                        }
                    }
                }
            }) {
                Label("Go", systemImage: "magnifyingglass")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            if favorited.keys.count > 0 {
                ForEach(Array(favorited.keys), id: \.self) { title in
                    Button(action: {
                        if let url = URL(string: favorited[title] ?? "") {
                            openBrowser(url: url)
                        }
                    }) {
                        Text(title)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showAddFavorite = true
                }) {
                    Label("Set Favorite", systemImage: "heart.fill")
                }
                .tint(Color.accentColor)
                .padding(.bottom, 5)
            }
        }
        .onAppear {
            guard !loaded else { return }

            if let fav = UserDefaults.standard.object(forKey: "favorited") as? [String: String] {
                self.favorited = fav
            }

            loaded = true
        }
        .sheet(isPresented: $showAddFavorite) {
            ManageFavoriteView(favorited: $favorited)
        }
    }

    func openBrowser(url: URL) {
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "") { _, _ in
        }
        session.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
