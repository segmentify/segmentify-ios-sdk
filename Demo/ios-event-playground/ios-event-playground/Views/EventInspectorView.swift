import SwiftUI

struct EventInspectorView: View {
    let debugState: EventDebugState?
    let isOpen: Bool
    let onToggle: () -> Void
    let onCopyUserId: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    Text("Event Inspector \(isOpen ? "▲" : "▼")")
                        .font(.headline)
                        .foregroundColor(Color.playgroundText)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.playgroundInspectorHeader)
            }

            if isOpen {
                VStack(alignment: .leading, spacing: 8) {
                    if let debugState {
                        Text("Event: \(debugState.label) (\(debugState.occurredAt.formatted()))")
                            .font(.caption)
                            .foregroundColor(Color.playgroundMuted)
                        Text("User ID: \(debugState.userId)")
                            .font(.caption)
                            .foregroundColor(Color.playgroundMuted)
                        Button("Copy User ID", action: onCopyUserId)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.playgroundButtonSecondary)
                            .foregroundColor(Color.playgroundText)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Session ID: \(debugState.sessionId)")
                            .font(.caption)
                            .foregroundColor(Color.playgroundMuted)
                        Text("Payload")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Color.playgroundAccent)
                        ScrollView {
                            Text(JSONFormatting.string(from: debugState.payload))
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(Color.playgroundText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: 140)
                        .padding(10)
                        .background(Color.playgroundCodeBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Response")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Color.playgroundAccent)
                        ScrollView {
                            Text(JSONFormatting.string(from: debugState.responseSummary))
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(Color.playgroundText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: 120)
                        .padding(10)
                        .background(Color.playgroundCodeBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Text("No event captured yet. Tap any event button to inspect details.")
                            .font(.caption)
                            .foregroundColor(Color.playgroundMuted)
                    }
                }
                .padding(12)
            }
        }
        .background(Color.playgroundInspectorBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.playgroundBorder, lineWidth: 1)
        )
    }
}

struct EventSectionView: View {
    let title: String
    let events: [DemoEvent]
    let runningEventId: UUID?
    let onRun: (DemoEvent) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundColor(Color.playgroundSectionTitle)
                .tracking(0.5)

            ForEach(events) { event in
                let isRunning = runningEventId == event.id
                Button {
                    onRun(event)
                } label: {
                    Text(isRunning ? "Sending..." : event.label)
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)
                .background(Color.playgroundPrimary.opacity(isRunning ? 0.7 : 1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(isRunning)
            }
        }
    }
}

extension Color {
    static let playgroundBackground = Color(red: 0.06, green: 0.09, blue: 0.16)
    static let playgroundText = Color(red: 0.97, green: 0.98, blue: 0.99)
    static let playgroundMuted = Color(red: 0.80, green: 0.84, blue: 0.88)
    static let playgroundPrimary = Color(red: 0.11, green: 0.31, blue: 0.85)
    static let playgroundAccent = Color(red: 0.58, green: 0.77, blue: 0.99)
    static let playgroundBorder = Color(red: 0.20, green: 0.25, blue: 0.33)
    static let playgroundInspectorBackground = Color(red: 0.04, green: 0.07, blue: 0.14)
    static let playgroundInspectorHeader = Color(red: 0.07, green: 0.11, blue: 0.20)
    static let playgroundCodeBackground = Color(red: 0.01, green: 0.02, blue: 0.09)
    static let playgroundButtonSecondary = Color(red: 0.12, green: 0.16, blue: 0.24)
    static let playgroundSectionTitle = Color(red: 0.58, green: 0.64, blue: 0.72)
}
