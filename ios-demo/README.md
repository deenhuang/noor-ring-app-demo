# NOOR Ring iOS Demo

This folder contains a native SwiftUI concept demo for the NOOR Ring Middle East app.

## Screens

- Today: readiness, sleep, stress, ring sync and AI next actions
- Sleep: sleep duration, stages and resting heart rate trend
- Move: training load, joint-care guidance and weekly activity
- Qibla: app-side compass, prayer times and screen-free ring positioning
- Coach: lightweight AI health-partner conversation mockup

The demo uses local mock data and SF Symbols. It does not copy Oura source code or private APIs; it borrows the general health-app information architecture and uses NOOR Ring's own visual language and Middle East requirements.

## Open in Xcode

The machine used to prepare this repository has Command Line Tools but not the full Xcode app, so the project file is generated from `project.yml`.

1. Install XcodeGen if it is not already installed: `brew install xcodegen`
2. Run `xcodegen generate` from this folder.
3. Open `NOORRingDemo.xcodeproj` in Xcode.
4. Select an iPhone simulator and run.

The minimum deployment target is iOS 16.0. HealthKit, Bluetooth, Arabic localization, and real ring SDK integration should be added after the product data contract is finalized.
