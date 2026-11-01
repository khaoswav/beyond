import SwiftUI

struct ContentView: View {
    @StateObject private var store = BeyondStore()
    @State private var isShowingComposer = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Ana Sayfa", systemImage: "house") }

            ExploreView()
                .tabItem { Label("Keşfet", systemImage: "magnifyingglass") }

            Color.clear
                .tabItem { Label("Paylaş", systemImage: "plus.app") }
                .onAppear { isShowingComposer = true }

            MessagesView()
                .tabItem { Label("Mesajlar", systemImage: "paperplane") }

            ProfileView()
                .tabItem { Label("Profil", systemImage: "person.crop.circle") }
        }
        .environmentObject(store)
        .sheet(isPresented: $isShowingComposer) {
            CreatePostView()
                .environmentObject(store)
        }
    }
}
