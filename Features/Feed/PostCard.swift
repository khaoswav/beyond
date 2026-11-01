import SwiftUI
import UIKit

struct PostCard: View {
    let post: SocialPost

    @EnvironmentObject private var store: BeyondStore
    
    @State private var isShowingComments = false
    @State private var commentDraft = ""

    private var isLiked: Bool { store.likedPostIDs.contains(post.id) }
    private var isSaved: Bool { store.savedPostIDs.contains(post.id) }

    private var formattedLikes: String {
        (post.likeCount + (isLiked ? 1 : 0)).formatted(.number.locale(Locale(identifier: "tr_TR")))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            postImage

            actionBar

            VStack(alignment: .leading, spacing: 7) {
                Text("\(formattedLikes) beğenme")
                    .font(.subheadline.weight(.semibold))
                    .contentTransition(.numericText())

                (
                    Text(post.handle)
                        .fontWeight(.semibold)
                    + Text(" " + post.caption)
                )
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)

                Button {
                    isShowingComments = true
                } label: {
                    Text("Yorumların tümünü gör (\(post.commentCount))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)

                Text(post.timeAgo.uppercased() + " ÖNCE")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 18)
        }
        .sheet(isPresented: $isShowingComments) {
            NavigationStack {
                ContentUnavailableView(
                    "Henüz yorum yok",
                    systemImage: "bubble.left",
                    description: Text("Bu gönderiye ilk yorumu sen yapabilirsin.")
                )
                .navigationTitle("Yorumlar")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Bitti") { isShowingComments = false }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    private var postImage: some View {
        if let data = post.imageData, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 420)
                .clipped()
                .accessibilityLabel("Gönderi fotoğrafı")
        } else if let url = post.imageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    imageFallback
                case .empty:
                    ZStack {
                        Color(uiColor: .secondarySystemBackground)
                        ProgressView()
                    }
                @unknown default:
                    imageFallback
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 340)
            .clipped()
        }
    }

    private var header: some View {
        HStack(spacing: 11) {
            Circle()
                .fill(Color(uiColor: .tertiarySystemFill))
                .frame(width: 38, height: 38)
                .overlay {
                    Image(systemName: post.avatarSymbol)
                        .font(.system(size: 22))
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(post.authorName)
                    .font(.subheadline.weight(.semibold))
                if let location = post.location {
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)

            Menu {
                Button("Bağlantıyı paylaş", systemImage: "square.and.arrow.up") {}
                Button("İlgilenmiyorum", systemImage: "eye.slash") {}
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .tint(.primary)
            .accessibilityLabel("Gönderi seçenekleri")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
    }

    private var actionBar: some View {
        HStack(spacing: 18) {
            Button {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.62)) {
                    store.toggleLike(for: post)
                }
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 23, weight: .regular))
                    .foregroundStyle(isLiked ? .red : .primary)
                    .symbolEffect(.bounce, value: isLiked)
            }
            .accessibilityLabel(isLiked ? "Beğenmekten vazgeç" : "Beğen")

            Button {
                isShowingComments = true
            } label: {
                Image(systemName: "bubble.right")
                    .font(.system(size: 22))
            }
            .accessibilityLabel("Yorum yap")

            ShareLink(item: post.caption) {
                Image(systemName: "paperplane")
                    .font(.system(size: 22))
            }
            .accessibilityLabel("Paylaş")

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    store.toggleSaved(for: post)
                }
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 22))
                    .symbolEffect(.bounce, value: isSaved)
            }
            .accessibilityLabel(isSaved ? "Kaydedilenlerden çıkar" : "Gönderiyi kaydet")
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 9)
    }

    private var imageFallback: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.tertiary)
        }
    }
}
