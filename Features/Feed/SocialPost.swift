import Foundation

struct SocialPost: Identifiable, Hashable {
    let id: String
    let authorName: String
    let handle: String
    let location: String?
    let avatarSymbol: String
    let imageURL: URL
    let caption: String
    let likeCount: Int
    let commentCount: Int
    let timeAgo: String

    static let samples: [SocialPost] = [
        SocialPost(
            id: "post-1",
            authorName: "Deniz Yılmaz",
            handle: "denizyilmaz",
            location: "İstanbul, Türkiye",
            avatarSymbol: "person.crop.circle.fill",
            imageURL: URL(string: "https://images.unsplash.com/photo-1519608487953-e999c86e7455?w=1200&auto=format&fit=crop&q=85")!,
            caption: "Şehrin hiç uyumayan tarafında küçük bir mola. 🌃",
            likeCount: 1284,
            commentCount: 48,
            timeAgo: "18 dk."
        ),
        SocialPost(
            id: "post-2",
            authorName: "Ece Demir",
            handle: "ecedemir",
            location: "Kapadokya",
            avatarSymbol: "person.crop.circle.fill",
            imageURL: URL(string: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200&auto=format&fit=crop&q=85")!,
            caption: "Bazen en güzel plan, plansız yola çıkmak.",
            likeCount: 936,
            commentCount: 27,
            timeAgo: "1 sa."
        ),
        SocialPost(
            id: "post-3",
            authorName: "Mert Kaya",
            handle: "mertkaya",
            location: nil,
            avatarSymbol: "person.crop.circle.fill",
            imageURL: URL(string: "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=1200&auto=format&fit=crop&q=85")!,
            caption: "Hafta sonundan geriye kalanlar. ✨",
            likeCount: 642,
            commentCount: 19,
            timeAgo: "3 sa."
        )
    ]
}
