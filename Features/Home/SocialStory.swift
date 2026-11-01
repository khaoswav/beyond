import Foundation

struct SocialStory: Identifiable, Codable, Hashable {
    let id: String
    let authorName: String
    let handle: String
    let caption: String
    let symbol: String
    let imageData: Data?
    let timeAgo: String

    static let samples: [SocialStory] = [
        .init(id: "story-deniz", authorName: "Deniz", handle: "denizyilmaz", caption: "Şehir bugün başka güzel.", symbol: "sun.max.fill", imageData: nil, timeAgo: "12 dk."),
        .init(id: "story-mert", authorName: "Mert", handle: "mertkaya", caption: "Yeni bir ritim, yeni bir gün.", symbol: "music.note", imageData: nil, timeAgo: "28 dk."),
        .init(id: "story-ece", authorName: "Ece", handle: "ecedemir", caption: "Yoldan küçük bir kare.", symbol: "camera.fill", imageData: nil, timeAgo: "45 dk."),
        .init(id: "story-ada", authorName: "Ada", handle: "adase", caption: "Biraz yeşil, biraz huzur.", symbol: "leaf.fill", imageData: nil, timeAgo: "1 sa.")
    ]
}
