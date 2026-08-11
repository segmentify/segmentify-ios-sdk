import Foundation

enum DemoEventType: String, CaseIterable {
    case pageView = "PAGE_VIEW"
    case interaction = "INTERACTION"
    case product = "PRODUCT"
    case search = "SEARCH"
    case basket = "BASKET"
    case checkout = "CHECKOUT"
    case user = "USER"
    case customerDataPlatform = "CUSTOMER_DATA_PLATFORM"
    case push = "PUSH"
    case email = "EMAIL"
    case sms = "SMS"

    var title: String {
        switch self {
        case .pageView: return "Page view"
        case .interaction: return "Interaction"
        case .product: return "Product"
        case .search: return "Search"
        case .basket: return "Basket"
        case .checkout: return "Checkout"
        case .user: return "User"
        case .customerDataPlatform: return "Customer Data Platform"
        case .push: return "Push"
        case .email: return "Email"
        case .sms: return "SMS"
        }
    }

    static let sectionOrder: [DemoEventType] = [
        .pageView,
        .interaction,
        .product,
        .search,
        .basket,
        .checkout,
        .user,
        .customerDataPlatform,
        .push,
        .email,
        .sms,
    ]
}

struct DemoEvent: Identifiable {
    let id = UUID()
    let label: String
    let eventType: DemoEventType
    let action: () async throws -> EventRunResult
}

struct EventRunResult {
    let payload: Any
    let responseSummary: Any
}

struct EventDebugState {
    let label: String
    let userId: String
    let sessionId: String
    let payload: Any
    let responseSummary: Any
    let occurredAt: Date
}
