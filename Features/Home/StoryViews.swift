import SwiftUI
import PhotosUI
import UIKit

struct StoryComposerView: View {
    @EnvironmentObject private var store: BeyondStore
    @Environment(\.dismiss) private var dismiss
    @State private var caption = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?

    private var canPublish: Bool {
        !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || imageData != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                if let imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 380)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.accentColor.opacity(0.10))
                        .frame(height: 220)
                        .overlay {
                            Image(systemName: "sparkles")
                                .font(.system(size: 46))
                                .foregroundStyle(Color.accentColor)
                        }
                }

                TextField("Hikâyene bir not ekle...", text: $caption, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Fotoğraf seç", systemImage: "photo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Text("Hikâyen bu cihazda saklanır ve demo akışında görünür.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
            }
            .padding(20)
            .navigationTitle("Yeni hikâye")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Paylaş") {
                        store.addStory(caption: caption, imageData: imageData)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canPublish)
                }
            }
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    guard let data = try? await item?.loadTransferable(type: Data.self),
                          let image = UIImage(data: data) else { return }
                    let maxDimension: CGFloat = 1000
                    let scale = min(1, maxDimension / max(image.size.width, image.size.height))
                    let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
                    let renderer = UIGraphicsImageRenderer(size: size)
                    let optimized = renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: size)) }
                    imageData = optimized.jpegData(compressionQuality: 0.75)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

struct StoryViewerView: View {
    let story: SocialStory

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if let data = story.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LinearGradient(
                    colors: [Color.accentColor.opacity(0.85), Color.purple.opacity(0.8), Color.black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack(spacing: 18) {
                    Image(systemName: story.symbol)
                        .font(.system(size: 54, weight: .light))
                    Text(story.caption)
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .foregroundStyle(.white)
            }

            VStack {
                HStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(story.authorName).font(.subheadline.weight(.semibold))
                        Text(story.timeAgo).font(.caption).opacity(0.8)
                    }
                    Spacer()
                    ShareLink(item: story.caption) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.headline)
                    }
                }
                .foregroundStyle(.white)
                .padding(18)
                Spacer()
                Text(story.caption)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.bottom, 36)
            }
        }
        .statusBarHidden()
    }
}
