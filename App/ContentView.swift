import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house")
                }

            ExploreView()
                .tabItem {
                    Label("Keşfet", systemImage: "magnifyingglass")
                }

            PlaceholderTab(title: "Paylaş", symbol: "plus.app")
                .tabItem {
                    Label("Paylaş", systemImage: "plus.app")
                }

            PlaceholderTab(title: "Mesajlar", symbol: "paperplane")
                .tabItem {
                    Label("Mesajlar", systemImage: "paperplane")
                }

            PlaceholderTab(title: "Profil", symbol: "person.crop.circle")
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
    }
}

private struct PlaceholderTab: View {
    let title: String
    let symbol: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                title,
                systemImage: symbol,
                description: Text("Bu alan BEYOND için hazırlanıyor.")
            )
            .navigationTitle(title)
        }
    }
}
