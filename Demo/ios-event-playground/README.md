# iOS Event Playground

SwiftUI demo app for manually exercising the Segmentify iOS SDK, mirroring the React Native Expo Event Playground.

## Setup

1. Open `Demo/ios-event-playground/ios-event-playground.xcodeproj` in Xcode.
2. Select an iPhone simulator or device.
3. For push tests, use the bundled `GoogleService-Info.plist` from `Demo/native-push-app` (bundle ID: `com.segmentify.push.native-push-app`).
4. Run the app.

The project links the **local** Segmentify package at the repository root (`../..`), so CDP APIs on your current branch are used immediately.

Minimum deployment target: **iOS 15**

## Configuration

Segmentify + push settings match `Demo/native-push-app` (required for Firebase push with bundle `com.segmentify.push.native-push-app`):

- API URL: `https://gandalf-qa.segmentify.com`
- Push URL: `https://gimli-qa.segmentify.com`
- Domain: `demo.segmentify.com`
- API key: `5c571072-068e-40c5-8dbc-d8448158de19`

Use the `GoogleService-Info.plist` from `Demo/native-push-app/native-push-app` (already included).

## Features

- Grouped event buttons (Page view, Interaction, Product, Search, Basket, Checkout, User, CDP, Push, Email, SMS)
- Event inspector with payload, response summary, user ID, and session ID
- Copy user ID to clipboard
- Firebase push subscribe + push interaction events
- Initial Home Page view on launch

## SDK gaps

These RN playground events are intentionally omitted because the iOS SDK has no equivalent API yet:

- Favorite add/remove/view
- Basket clear
- Legacy USER Identify (use CDP Identify User instead)

## Build from CLI

```bash
xcodebuild build \
  -project Demo/ios-event-playground/ios-event-playground.xcodeproj \
  -scheme ios-event-playground \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6'
```
