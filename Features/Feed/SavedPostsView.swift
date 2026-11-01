import SwiftUI

struct SavedPostsView: View {
    @EnvironmentObject private var store: BeyondStore

    private var savedPosts: [SocialPost] {
        store.posts.filter { store.savedPostIDs.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if savedPosts.isEmpty {
                    ContentUnavailableView(
                        "Kaydedilen gönderi yok",
                        systemImage: "bookmark",
                        description: Text("Beğendiğin gönderileri daha sonra bulmak için kaydet.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(savedPosts) { post in
                                PostCard(post: post)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("Kaydedilenler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
