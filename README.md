# BEYOND

**More than social.**

BEYOND is a native iPhone social app prototype built with Swift and SwiftUI.

## Product direction

- Default language: Turkish
- Platform: iPhone
- Minimum deployment target: iOS 17
- UI: Native Apple SwiftUI components, system controls, and SF Symbols
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
- Avoid third-party UI frameworks and copied interface kits.
- Respect Safe Areas, Dynamic Type, accessibility, and system appearance.
- Keep features modular and reviewable through focused pull requests.
- Validate Debug and Release simulator builds with GitHub Actions.

## Build

1. Open `BEYOND.xcodeproj` in Xcode.
2. Select the `BEYOND` scheme.
3. Choose an iPhone simulator.
4. Build and run.

The CI workflow builds both Debug and Release for the iOS Simulator. Physical iPhone testing and App Store signing have not been completed.
