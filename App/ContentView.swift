import SwiftUI

struct ContentView: View {
    @StateObject private var store = BeyondStore()
    @State private var selectedTab = 0
    @State private var isShowingComposer = false
    @AppStorage("beyond.onboarding.completed") private var hasCompletedOnboarding = false
    @State private var isShowingOnboarding = false
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
                .tabItem { Label("Ana Sayfa", image: "FAHouse") }
                .tag(0)

            ExploreView()
                .tabItem { Label("Keşfet", image: "FAMagnifyingGlass") }
                .tag(1)

            Color.clear
                .tabItem { Label("Paylaş", image: "FAPlus") }
                .tag(2)

            MessagesView()
                .tabItem { Label("Mesajlar", image: "FAPaperPlane") }
                .tag(3)

            ProfileView()
                .tabItem { Label("Profil", image: "FAUser") }
                .tag(4)
        }
        .onChange(of: selectedTab) { _, newValue in
            guard newValue == 2 else { return }
            selectedTab = 0
            isShowingComposer = true
        }
        .onAppear {
            if !hasCompletedOnboarding { isShowingOnboarding = true }
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            OnboardingView()
        }
        .preferredColorScheme(preferredScheme)
        .environmentObject(store)
        .sheet(isPresented: $isShowingComposer) {
            CreatePostView()
                .environmentObject(store)
        }
    }
}
