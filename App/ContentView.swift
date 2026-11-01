import SwiftUI

struct ContentView: View {
    @StateObject private var store = BeyondStore()
    @State private var selectedTab = 0
    @State private var isShowingComposer = false
    @AppStorage("beyond.settings.appearance") private var appearance = "system"

    private var preferredScheme: ColorScheme? {
        switch appearance {
        case "light": .light
        case "dark": .dark
        default: nil
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Ana Sayfa", systemImage: "house") }
                .tag(0)

            ExploreView()
                .tabItem { Label("Keşfet", systemImage: "magnifyingglass") }
                .tag(1)

            Color.clear
                .tabItem { Label("Paylaş", systemImage: "plus.app") }
                .tag(2)

            MessagesView()
                .tabItem { Label("Mesajlar", systemImage: "paperplane") }
                .tag(3)

            ProfileView()
                .tabItem { Label("Profil", systemImage: "person.crop.circle") }
                .tag(4)
        }
        .onChange(of: selectedTab) { _, newValue in
            guard newValue == 2 else { return }
            selectedTab = 0
            isShowingComposer = true
        }
        .preferredColorScheme(preferredScheme)
        .environmentObject(store)
        .sheet(isPresented: $isShowingComposer) {
            CreatePostView()
                .environmentObject(store)
        }
    }
}
