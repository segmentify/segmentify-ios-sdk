import Foundation
import Segmentify

enum SegmentifyConfiguration {
    static let language = "EN"
    static let currency = "EUR"

    static func apply() {
        SegmentifyPushConfiguration.apply()
        _ = SegmentifyManager.logStatus(isVisible: true)
        _ = SegmentifyManager.setSessionKeepSecond(sessionKeepSecond: 604800)
        _ = SegmentifyManager.sharedManager()
    }

    static func triggerInitialPageView() {
        let page = PageModel()
        page.category = "Home Page"
        page.subCategory = "Home"
        page.lang = language
        page.currency = currency

        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: page) { _ in }
    }
}
