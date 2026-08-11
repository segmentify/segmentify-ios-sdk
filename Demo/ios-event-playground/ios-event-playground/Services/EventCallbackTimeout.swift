import Foundation

enum EventCallbackTimeout {
    static func run<T>(
        seconds: TimeInterval = 12,
        fallback: T,
        operation: (@escaping (T) -> Void) -> Void
    ) async -> T {
        await withCheckedContinuation { continuation in
            let lock = NSLock()
            var finished = false

            func finish(_ value: T) {
                lock.lock()
                defer { lock.unlock() }
                guard !finished else { return }
                finished = true
                continuation.resume(returning: value)
            }

            operation { finish($0) }

            DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + seconds) {
                finish(fallback)
            }
        }
    }

    static func runVoid(
        seconds: TimeInterval = 12,
        operation: (@escaping () -> Void) -> Void
    ) async {
        _ = await run(seconds: seconds, fallback: ()) { complete in
            operation { complete(()) }
        }
    }
}
