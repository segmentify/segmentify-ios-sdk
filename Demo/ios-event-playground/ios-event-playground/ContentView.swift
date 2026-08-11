import SwiftUI

struct ContentView: View {
    @StateObject private var pushService = PushService()
    @State private var lastAction = "Ready"
    @State private var runningEventId: UUID?
    @State private var isInspectorOpen = true
    @State private var eventDebug: EventDebugState?
    @State private var demoEvents: [DemoEvent] = []

    private var groupedEvents: [(type: DemoEventType, title: String, events: [DemoEvent])] {
        DemoEventType.sectionOrder.compactMap { type in
            let events = demoEvents.filter { $0.eventType == type }
            guard !events.isEmpty else { return nil }
            return (type, type.title, events)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text("Segmentify iOS Event Playground")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)

                    Text("Last Action: \(lastAction)")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.80, green: 0.84, blue: 0.88))

                    Text("Push: \(pushService.statusMessage)")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.80, green: 0.84, blue: 0.88))

                    EventInspectorView(
                        debugState: eventDebug,
                        isOpen: isInspectorOpen,
                        onToggle: { isInspectorOpen.toggle() },
                        onCopyUserId: copyUserId
                    )

                    ForEach(groupedEvents, id: \.type) { section in
                        EventSectionView(
                            title: section.title,
                            events: section.events,
                            runningEventId: runningEventId,
                            onRun: { run(event: $0) }
                        )
                    }
                }
                .padding(16)
            }
            .background(Color.playgroundBackground)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            if demoEvents.isEmpty {
                demoEvents = SegmentifyEventRunner.makeDemoEvents(pushService: pushService)
            }
            pushService.start()
        }
    }

    private func run(event: DemoEvent) {
        Task { @MainActor in
            runningEventId = event.id
            defer { runningEventId = nil }

            do {
                let result = try await event.action()
                let identity = SegmentifyIdentityReader.currentIdentity()
                eventDebug = EventDebugState(
                    label: event.label,
                    userId: identity.userId,
                    sessionId: identity.sessionId,
                    payload: result.payload,
                    responseSummary: result.responseSummary,
                    occurredAt: Date()
                )
                lastAction = "\(event.label) sent"
            } catch {
                lastAction = "\(event.label) failed: \(error.localizedDescription)"
            }
        }
    }

    private func copyUserId() {
        guard let userId = eventDebug?.userId, userId != "—" else { return }
        UIPasteboard.general.string = userId
        lastAction = "User ID copied"
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
