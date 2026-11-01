import Foundation
import Combine

@MainActor
final class BeyondStore: ObservableObject {
    @Published private(set) var posts: [SocialPost] {
        didSet { persistPosts() }
    }
    @Published private(set) var likedPostIDs: Set<String> {
        didSet { UserDefaults.standard.set(Array(likedPostIDs), forKey: Keys.likes) }
    }
    @Published private(set) var savedPostIDs: Set<String> {
        didSet { UserDefaults.standard.set(Array(savedPostIDs), forKey: Keys.saved) }
    }
    @Published private(set) var followingHandles: Set<String> {
        didSet { UserDefaults.standard.set(Array(followingHandles), forKey: Keys.following) }
    }
    @Published private(set) var activities: [String] {
        didSet {
            if let data = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(data, forKey: Keys.activities)
            }
        }
    }
    @Published private(set) var comments: [String: [String]] {
        didSet {
            if let data = try? JSONEncoder().encode(comments) {
                UserDefaults.standard.set(data, forKey: Keys.comments)
            }
        }
    }

    private enum Keys {
        static let posts = "beyond.feed.posts.v1"
        static let likes = "beyond.feed.likes.v1"
        static let saved = "beyond.feed.saved.v1"
        static let comments = "beyond.feed.comments.v1"
        static let following = "beyond.social.following.v1"
        static let activities = "beyond.social.activities.v1"
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: Keys.posts),
           let stored = try? JSONDecoder().decode([SocialPost].self, from: data) {
            posts = stored
        } else {
            posts = SocialPost.samples
        }
        likedPostIDs = Set(UserDefaults.standard.stringArray(forKey: Keys.likes) ?? [])
        savedPostIDs = Set(UserDefaults.standard.stringArray(forKey: Keys.saved) ?? [])
        followingHandles = Set(UserDefaults.standard.stringArray(forKey: Keys.following) ?? [])
        if let data = UserDefaults.standard.data(forKey: Keys.activities),
           let stored = try? JSONDecoder().decode([String].self, from: data) {
            activities = stored
        } else {
            activities = []
        }
        if let data = UserDefaults.standard.data(forKey: Keys.comments),
           let stored = try? JSONDecoder().decode([String: [String]].self, from: data) {
            comments = stored
        } else {
            comments = [:]
        }
    }

    func isFollowing(_ handle: String) -> Bool {
        followingHandles.contains(handle.trimmingCharacters(in: CharacterSet(charactersIn: "@")))
    }

    func toggleFollow(handle: String, displayName: String) {
        let normalized = handle.trimmingCharacters(in: CharacterSet(charactersIn: "@"))
        if followingHandles.contains(normalized) {
            followingHandles.remove(normalized)
            activities.insert("\(displayName) takibini bıraktın.", at: 0)
        } else {
            followingHandles.insert(normalized)
            activities.insert("\(displayName) kişisini takip etmeye başladın.", at: 0)
        }
    }

    func clearActivities() {
        activities.removeAll()
    }

    func addPost(caption: String, imageData: Data?) {
        let cleaned = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty || imageData != nil else { return }
        let post = SocialPost(
            id: UUID().uuidString,
            authorName: UserDefaults.standard.string(forKey: "beyond.profile.displayName") ?? "Khaos",
            handle: UserDefaults.standard.string(forKey: "beyond.profile.username") ?? "khaos",
            location: nil,
            avatarSymbol: "person.crop.circle.fill",
            imageURL: nil,
            caption: cleaned,
            likeCount: 0,
            commentCount: 0,
            timeAgo: "Şimdi",
            imageData: imageData
        )
        posts.insert(post, at: 0)
    }

    func toggleLike(for post: SocialPost) {
        if likedPostIDs.contains(post.id) {
            likedPostIDs.remove(post.id)
        } else {
            likedPostIDs.insert(post.id)
        }
    }

    func toggleSaved(for post: SocialPost) {
        if savedPostIDs.contains(post.id) {
            savedPostIDs.remove(post.id)
        } else {
            savedPostIDs.insert(post.id)
        }
    }

    func addComment(_ text: String, to post: SocialPost) {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        comments[post.id, default: []].append(cleaned)
    }

    func comments(for post: SocialPost) -> [String] {
        comments[post.id] ?? []
    }

    func posts(for handle: String) -> [SocialPost] {
        posts.filter { $0.handle.caseInsensitiveCompare(handle) == .orderedSame }
    }

    private func persistPosts() {
        guard let data = try? JSONEncoder().encode(posts) else { return }
        UserDefaults.standard.set(data, forKey: Keys.posts)
    }
}
