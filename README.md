# BEYOND

**More than social.**

BEYOND is a native iPhone social app prototype built with Swift and SwiftUI.

## Product direction

- Default language: Turkish
- Platform: iPhone
- Minimum deployment target: iOS 17
- UI: Native Apple SwiftUI components and system controls, with selected Font Awesome Free SVG icons in the app asset catalog
- Appearance: System, Light, and Dark

## Included experience

- First-launch profile setup and editable profile
- Home feed with personalized and Following filters
- Photo and text post composer
- Likes, comments, and saved posts
- Explore search, sample public profiles, and follow/unfollow
- Interactive local stories with photo selection and full-screen viewing
- Messages inbox and locally persisted demo conversations
- Activity history and app preferences

## Data and connectivity

This repository currently delivers a **local, demo-ready MVP**, not a connected production social network.

- Profile, posts, stories, likes, comments, follows, saved posts, settings, and demo messages are stored on the device.
- Explore people and initial feed content use sample data.
- There is no remote authentication, backend API, cloud media storage, cross-device synchronization, push notification service, or real-time chat yet.
- Follower totals for other users are not available without a backend.

These boundaries are intentional and documented so local demo behavior is not mistaken for live multi-user functionality.

## Engineering principles

- Prefer native Apple frameworks and system components.
- Use a small, attributed set of Font Awesome Free icons for key navigation and social actions; keep Pro/Pro+ assets out of the public repository.
- Avoid third-party UI frameworks and copied interface kits.
- Respect Safe Areas, Dynamic Type, accessibility, and system appearance.
- Keep features modular and reviewable through focused pull requests.
- Validate Debug and Release simulator builds and an unsigned physical-device SDK build with GitHub Actions.

## Build in Xcode

1. Open `BEYOND.xcodeproj` in Xcode.
2. Select the `BEYOND` scheme.
3. Choose an iPhone simulator, or connect a physical iPhone and select it as the run destination.
4. For a physical iPhone, open **Signing & Capabilities**, enable **Automatically manage signing**, and select your **Personal Team** (your Apple ID).
5. If Xcode reports that the bundle identifier is unavailable for your Personal Team, change it to a unique identifier such as `com.yourname.beyond` in the local project signing settings.
6. Keep the iPhone unlocked, trust the Mac if prompted, enable Developer Mode on the iPhone if requested, then press **Run** in Xcode.

A free Apple ID can be used for personal on-device development through Xcode. The development provisioning profile is temporary (typically 7 days), so the app may need to be rebuilt/reinstalled after it expires. A free Personal Team does not provide App Store distribution or a generally installable ad-hoc IPA.

## CI and release boundaries

The GitHub Actions workflow builds Debug and Release for the iOS Simulator and compiles a Debug build against the physical-device iOS SDK with code signing disabled. This verifies device-SDK compilation, **not** signing, provisioning, installation, or runtime behavior on an iPhone.

The simulator ZIP is not a physical-device package. Physical iPhone testing and App Store signing have not been completed. No signed IPA is produced by CI because signing requires the developer's Apple account/team and provisioning credentials.
