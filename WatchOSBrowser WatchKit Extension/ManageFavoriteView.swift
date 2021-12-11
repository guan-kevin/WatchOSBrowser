//
//  ManageFavoriteView.swift
//  WatchOSBrowser WatchKit Extension
//
//  Created by Kevin on 12/10/21.
//

import SwiftUI

struct ManageFavoriteView: View {
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var url: String = ""

    @Binding var favorited: [String: String]

    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: deleteView) {
                    Text("Manage...")
                        .foregroundColor(.accentColor)
                }

                TextField("Title", text: $title)
                TextField("URL", text: $url)
                Button(action: {
                    guard !title.isEmpty, !url.isEmpty else { return }

                    if let validURL = URL(string: url) {
                        if validURL.scheme?.lowercased() == "http" || validURL.scheme?.lowercased() == "https" {
                            favorited[title] = url.lowercased()
                            UserDefaults.standard.set(favorited, forKey: "favorited")

                            dismiss()
                        }
                    }
                }) {
                    Text("Save")
                }
            }
        }
    }

    var deleteView: some View {
        Group {
            if favorited.count > 0 {
                List {
                    ForEach(Array(favorited.keys), id: \.self) { title in
                        VStack(alignment: .leading) {
                            Text(title)
                            Text(favorited[title] ?? "Unknown URL")
                                .font(.footnote)
                        }
                    }
                    .onDelete(perform: deleteFavorited)
                }
            } else {
                Text("No favorited")
            }
        }
    }

    func deleteFavorited(offsets: IndexSet) {
        offsets.forEach { i in
            if i >= 0, i < favorited.keys.count {
                let key = Array(favorited.keys)[i]
                favorited.removeValue(forKey: key)
                UserDefaults.standard.set(favorited, forKey: "favorited")
            }
        }
    }
}
