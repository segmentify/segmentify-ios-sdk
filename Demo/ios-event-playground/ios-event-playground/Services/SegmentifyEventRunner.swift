import Foundation
import Segmentify

enum SegmentifyEventRunner {
    private static let manager = SegmentifyManager.sharedManager()

    /// Returned when the SDK never invokes its completion handler (empty/invalid API response).
    private static let callbackTimeoutFallback: [String: Any] = [
        "status": "SDK callback did not fire (timeout or empty API response)",
    ]

    static func makeDemoEvents(pushService: PushService) -> [DemoEvent] {
        var events: [DemoEvent] = []

        func add(
            _ label: String,
            type: DemoEventType,
            payload: Any,
            action: @escaping () async throws -> Any
        ) {
            events.append(
                DemoEvent(
                    label: label,
                    eventType: type,
                    action: {
                        let response = try await action()
                        return EventRunResult(payload: payload, responseSummary: response)
                    }
                )
            )
        }

        // Page view
        add("PageView", type: .pageView, payload: pageViewPayload()) {
            await sendPageView()
        }

        // Interaction
        add("Interaction Click", type: .interaction, payload: interactionPayload(type: "click")) {
            sendClick(instanceId: SegmentifyMockData.Interaction.widgetClick.instanceId,
                      interactionId: SegmentifyMockData.Interaction.widgetClick.interactionId)
            return dispatched
        }
        add("Interaction View", type: .interaction, payload: interactionPayload(type: "widget-view")) {
            sendWidgetView(instanceId: SegmentifyMockData.Interaction.widgetView.instanceId,
                           interactionId: SegmentifyMockData.Interaction.widgetView.interactionId)
            return dispatched
        }

        // Product
        add("ProductView", type: .product, payload: productPayload()) {
            await sendProductView()
        }

        // Search
        add("Before Search", type: .search, payload: ["type": "keyword", "query": ""]) {
            await sendBeforeSearch()
        }
        add("Before Search Interaction Click", type: .search, payload: searchClickPayload(before: true)) {
            sendSearchClickView(instanceId: SegmentifyMockData.Search.beforeClickInstanceId,
                                interactionId: SegmentifyMockData.Search.beforeClickInteractionId)
            return dispatched
        }
        add("Before Search Interaction View", type: .search, payload: searchViewPayload(before: true)) {
            sendWidgetView(instanceId: SegmentifyMockData.Search.beforeKeywordInstanceId, interactionId: "static")
            return dispatched
        }
        add("Before Search Interaction Impression", type: .search, payload: searchImpressionPayload(before: true)) {
            sendImpression(instanceId: SegmentifyMockData.Search.beforeKeywordInstanceId, interactionId: "static")
            return dispatched
        }
        add("After Search", type: .search, payload: ["query": SegmentifyMockData.Search.afterQuery, "type": "instant"]) {
            await sendAfterSearch()
        }
        add("After Search Interaction Click", type: .search, payload: searchClickPayload(before: false)) {
            sendSearchClickView(instanceId: SegmentifyMockData.Search.afterClickInstanceId,
                                interactionId: SegmentifyMockData.Search.afterClickInteractionId)
            return dispatched
        }
        add("After Search Interaction View", type: .search, payload: searchViewPayload(before: false)) {
            sendWidgetView(instanceId: SegmentifyMockData.Search.afterInstanceId, interactionId: "static")
            return dispatched
        }
        add("AfterSearch Interaction Impression", type: .search, payload: searchImpressionPayload(before: false)) {
            sendImpression(instanceId: SegmentifyMockData.Search.afterInstanceId, interactionId: "static")
            return dispatched
        }
        add("Searchandising", type: .search, payload: ["query": SegmentifyMockData.Search.afterQuery, "type": "faceted"]) {
            await sendSearchandising()
        }
        add("Searchandising Click", type: .search, payload: searchClickPayload(before: false)) {
            sendSearchClickView(instanceId: SegmentifyMockData.Search.afterClickInstanceId,
                                interactionId: SegmentifyMockData.Search.afterClickInteractionId)
            return dispatched
        }

        // Basket
        add("Basket View", type: .basket, payload: basketViewPayload()) {
            await sendBasketView()
        }
        add("Basket Add", type: .basket, payload: basketAddPayload()) {
            sendBasketAdd()
            return dispatched
        }
        add("Basket Remove", type: .basket, payload: basketRemovePayload()) {
            sendBasketRemove()
            return dispatched
        }

        // Checkout
        add("Order Success", type: .checkout, payload: checkoutPayload()) {
            await sendPurchase()
        }

        // Legacy user
        add("Register", type: .user, payload: legacyUserPayload(step: "signup")) {
            sendLegacyRegister()
            return dispatched
        }
        add("LogIn", type: .user, payload: legacyUserPayload(step: "signin")) {
            sendLegacyLogin()
            return dispatched
        }
        add("Logout", type: .user, payload: legacyUserPayload(step: "signout")) {
            sendLegacyLogout()
            return dispatched
        }

        // CDP
        add("User Traits", type: .customerDataPlatform, payload: SegmentifyMockData.userTraits) {
            manager.userTraits(SegmentifyMockData.userTraits)
            return dispatched
        }
        add("[CDP] Identify User", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.identify) {
            await sendIdentifyUser(SegmentifyMockData.CDP.identify)
        }
        add("[CDP] Register User", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.register) {
            manager.registerUser(SegmentifyMockData.CDP.register)
            return dispatched
        }
        add("[CDP] Login User", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.login) {
            manager.loginUser(SegmentifyMockData.CDP.login)
            return dispatched
        }
        add("[CDP] Logout User", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.logout) {
            manager.logoutUser(SegmentifyMockData.CDP.logout)
            return dispatched
        }

        add("[CDP] Subscribe Email", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.subscribeEmail) {
            manager.subscribeUser(.email(
                email: SegmentifyMockData.CDP.subscribeEmailAddress,
                purpose: SegmentifyMockData.CDP.subscribeEmailPurpose
            ))
            return dispatched
        }
        add("[CDP] Subscribe WhatsApp", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.subscribeWhatsApp) {
            manager.subscribeUser(.whatsapp(phoneNumber: SegmentifyMockData.CDP.phoneNumber))
            return dispatched
        }
        add("[CDP] Subscribe SMS", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.subscribeSMS) {
            manager.subscribeUser(.sms(phoneNumber: SegmentifyMockData.CDP.phoneNumber))
            return dispatched
        }
        add("[CDP] Subscribe Call", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.subscribeCall) {
            manager.subscribeUser(.call(phoneNumber: SegmentifyMockData.CDP.phoneNumber))
            return dispatched
        }
        events.append(
            DemoEvent(
                label: "[CDP] Subscribe iOS Push",
                eventType: .customerDataPlatform,
                action: {
                    let token = try await pushService.ensureToken()
                    let subscribeProperties = CdpSubscribePayload.iosPush(pushSubscriptionId: token).toDictionary()
                    manager.subscribeUser(.iosPush(pushSubscriptionId: token))
                    return EventRunResult(payload: subscribeProperties, responseSummary: dispatched)
                }
            )
        )

        add("[CDP] Unsubscribe Email", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.unsubscribeEmail) {
            manager.unsubscribeUser(CdpUnsubscribePayload(
                channel: .email,
                email: SegmentifyMockData.CDP.subscribeEmailAddress
            ))
            return dispatched
        }
        add("[CDP] Unsubscribe WhatsApp", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.unsubscribeWhatsApp) {
            manager.unsubscribeUser(CdpUnsubscribePayload(
                channel: .whatsapp,
                phoneNumber: SegmentifyMockData.CDP.phoneNumber
            ))
            return dispatched
        }
        add("[CDP] Unsubscribe SMS", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.unsubscribeSMS) {
            manager.unsubscribeUser(CdpUnsubscribePayload(
                channel: .sms,
                phoneNumber: SegmentifyMockData.CDP.phoneNumber
            ))
            return dispatched
        }
        add("[CDP] Unsubscribe Call", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.unsubscribeCall) {
            manager.unsubscribeUser(CdpUnsubscribePayload(
                channel: .call,
                phoneNumber: SegmentifyMockData.CDP.phoneNumber
            ))
            return dispatched
        }
        add("[CDP] Unsubscribe iOS Push", type: .customerDataPlatform, payload: SegmentifyMockData.CDP.unsubscribeIosPush) {
            manager.unsubscribeUser(CdpUnsubscribePayload(channel: .iosPush))
            return dispatched
        }

        // Push — native permission info and interaction events (not CDP USER_SUBSCRIBE).
        events.append(
            DemoEvent(
                label: "Push Permission Info",
                eventType: .push,
                action: {
                    let token = try await pushService.ensureToken()
                    let userId = try requireSegmentifyUserId()
                    sendPushPermissionInfo(deviceToken: token, userId: userId)
                    return EventRunResult(
                        payload: permissionInfoPayload(deviceToken: token, userId: userId),
                        responseSummary: dispatched
                    )
                }
            )
        )
        add("Push Interaction VIEW", type: .push, payload: pushPayload(type: "VIEW")) {
            sendPushView()
            return dispatched
        }
        add("Push Interaction CLICK", type: .push, payload: pushPayload(type: "CLICK")) {
            sendPushClick()
            return dispatched
        }

        // Email / SMS
        add("Email User OP", type: .email, payload: SegmentifyMockData.Interaction.emailHashParams) {
            await sendCustomEvent(type: "sgm-hash", params: SegmentifyMockData.Interaction.emailHashParams)
        }
        add("Email Interaction Click", type: .email, payload: interactionPayload(type: "email")) {
            sendClick(instanceId: SegmentifyMockData.Interaction.emailClick.instanceId,
                      interactionId: SegmentifyMockData.Interaction.emailClick.interactionId)
            return dispatched
        }
        add("SMS Interaction Click", type: .sms, payload: interactionPayload(type: "sms")) {
            sendClick(instanceId: SegmentifyMockData.Interaction.smsClick.instanceId,
                      interactionId: SegmentifyMockData.Interaction.smsClick.interactionId)
            return dispatched
        }

        return events
    }

    private static let dispatched = ["status": "Event dispatched"]

    // MARK: - Payload builders

    private static func pageViewPayload() -> [String: Any] {
        [
            "category": SegmentifyMockData.PageView.category,
            "subCategory": SegmentifyMockData.PageView.subCategory,
            "params": SegmentifyMockData.PageView.params,
        ]
    }

    private static func productPayload() -> [String: Any] {
        [
            "productId": SegmentifyMockData.Product.productId,
            "title": SegmentifyMockData.Product.title,
            "price": SegmentifyMockData.Product.price,
        ]
    }

    private static func interactionPayload(type: String) -> [String: Any] {
        [
            "type": type,
            "instanceId": SegmentifyMockData.Interaction.widgetClick.instanceId,
            "interactionId": SegmentifyMockData.Interaction.widgetClick.interactionId,
        ]
    }

    private static func searchClickPayload(before: Bool) -> [String: Any] {
        if before {
            return [
                "type": "search",
                "instanceId": SegmentifyMockData.Search.beforeClickInstanceId,
                "interactionId": SegmentifyMockData.Search.beforeClickInteractionId,
            ]
        }
        return [
            "type": "search",
            "instanceId": SegmentifyMockData.Search.afterClickInstanceId,
            "interactionId": SegmentifyMockData.Search.afterClickInteractionId,
        ]
    }

    private static func searchViewPayload(before: Bool) -> [String: Any] {
        [
            "type": "widget-view",
            "instanceId": before ? SegmentifyMockData.Search.beforeKeywordInstanceId : SegmentifyMockData.Search.afterInstanceId,
            "interactionId": "static",
        ]
    }

    private static func searchImpressionPayload(before: Bool) -> [String: Any] {
        [
            "type": "impression",
            "instanceId": before ? SegmentifyMockData.Search.beforeKeywordInstanceId : SegmentifyMockData.Search.afterInstanceId,
            "interactionId": "static",
        ]
    }

    private static func basketViewPayload() -> [String: Any] {
        [
            "totalPrice": SegmentifyMockData.Basket.viewTotalPrice,
            "productList": SegmentifyMockData.Basket.productList,
        ]
    }

    private static func basketAddPayload() -> [String: Any] {
        [
            "step": "add",
            "productId": SegmentifyMockData.Product.productId,
            "quantity": SegmentifyMockData.Basket.quantity,
            "price": SegmentifyMockData.Basket.addPrice,
        ]
    }

    private static func basketRemovePayload() -> [String: Any] {
        [
            "step": "remove",
            "productId": SegmentifyMockData.Product.productId,
            "quantity": SegmentifyMockData.Basket.quantity,
            "price": SegmentifyMockData.Basket.removePrice,
        ]
    }

    private static func checkoutPayload() -> [String: Any] {
        [
            "totalPrice": SegmentifyMockData.Checkout.totalPrice,
            "orderNo": SegmentifyMockData.Checkout.orderNo,
            "productList": SegmentifyMockData.Checkout.productList,
        ]
    }

    private static func legacyUserPayload(step: String) -> [String: Any] {
        [
            "email": SegmentifyMockData.User.email,
            "externalId": SegmentifyMockData.User.externalId,
            "step": step,
        ]
    }

    private static func pushPayload(type: String) -> [String: Any] {
        [
            "type": type,
            "providerType": "FIREBASE",
            "instanceId": SegmentifyMockData.Interaction.pushViewInstanceId,
        ]
    }

    private static func requireSegmentifyUserId() throws -> String {
        guard let userId = SegmentifyIdentityReader.currentUserId() else {
            throw NSError(
                domain: "SegmentifyEventRunner",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Segmentify user ID is not available yet. Send any SDK event first so the playground can read the assigned identity.",
                ]
            )
        }
        return userId
    }

    private static func permissionInfoPayload(deviceToken: String, userId: String) -> [String: Any] {
        [
            "deviceToken": deviceToken,
            "type": "PERMISSION_INFO",
            "providerType": "FIREBASE",
            "userId": userId,
        ]
    }

    // MARK: - SDK calls

    private static func sendPageView() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let page = PageModel()
            page.category = SegmentifyMockData.PageView.category
            page.subCategory = SegmentifyMockData.PageView.subCategory
            page.lang = SegmentifyConfiguration.language
            page.currency = SegmentifyConfiguration.currency
            page.params = SegmentifyMockData.PageView.params
            manager.sendPageView(segmentifyObject: page) { recommendations in
                complete(recommendationSummary(recommendations))
            }
        }
    }

    private static func sendProductView() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let product = ProductModel()
            product.productId = SegmentifyMockData.Product.productId
            product.name = SegmentifyMockData.Product.title
            product.price = SegmentifyMockData.Product.price
            product.oldPrice = SegmentifyMockData.Product.oldPrice
            product.image = SegmentifyMockData.Product.image
            product.categories = SegmentifyMockData.Product.category.components(separatedBy: " > ")
            product.brand = SegmentifyMockData.Product.brand
            product.inStock = SegmentifyMockData.Product.inStock
            product.url = SegmentifyMockData.Product.url
            product.params = SegmentifyMockData.Product.params
            product.lang = SegmentifyConfiguration.language
            product.currency = SegmentifyConfiguration.currency
            manager.sendProductView(segmentifyObject: product) { recommendations in
                complete(recommendationSummary(recommendations))
            }
        }
    }

    private static func sendBeforeSearch() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let search = SearchFacetPageModel()
            search.query = ""
            search.type = "keyword"
            search.trigger = "keyword"
            search.lang = SegmentifyConfiguration.language
            search.currency = SegmentifyConfiguration.currency
            manager.sendFacetedSearchPageView(segmentifyObject: search) { response in
                complete(facetedSearchSummary(response))
            }
        }
    }

    private static func sendAfterSearch() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let search = SearchPageModel()
            search.query = SegmentifyMockData.Search.afterQuery
            search.lang = SegmentifyConfiguration.language
            search.currency = SegmentifyConfiguration.currency
            manager.sendSearchPageView(segmentifyObject: search) { response in
                complete(instantSearchSummary(response))
            }
        }
    }

    private static func sendSearchandising() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let search = SearchFacetPageModel()
            search.query = SegmentifyMockData.Search.afterQuery
            search.type = "faceted"
            search.trigger = "keyword"
            search.ordering = FacetedOrdering()
            search.ordering?.page = 1
            search.lang = SegmentifyConfiguration.language
            search.currency = SegmentifyConfiguration.currency
            manager.sendFacetedSearchPageView(segmentifyObject: search) { response in
                complete(facetedSearchSummary(response))
            }
        }
    }

    private static func sendBasketView() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let checkout = CheckoutModel()
            checkout.totalPrice = SegmentifyMockData.Basket.viewTotalPrice
            checkout.productList = SegmentifyMockData.Basket.productList
            checkout.lang = SegmentifyConfiguration.language
            checkout.currency = SegmentifyConfiguration.currency
            manager.sendViewBasket(segmentifyObject: checkout) { recommendations in
                complete(recommendationSummary(recommendations))
            }
        }
    }

    private static func sendBasketAdd() {
        let basket = BasketModel()
        basket.step = "add"
        basket.productId = SegmentifyMockData.Product.productId
        basket.quantity = SegmentifyMockData.Basket.quantity
        basket.price = SegmentifyMockData.Basket.addPrice
        basket.lang = SegmentifyConfiguration.language
        basket.currency = SegmentifyConfiguration.currency
        manager.sendAddOrRemoveBasket(segmentifyObject: basket)
    }

    private static func sendBasketRemove() {
        let basket = BasketModel()
        basket.step = "remove"
        basket.productId = SegmentifyMockData.Product.productId
        basket.quantity = SegmentifyMockData.Basket.quantity
        basket.price = SegmentifyMockData.Basket.removePrice
        basket.lang = SegmentifyConfiguration.language
        basket.currency = SegmentifyConfiguration.currency
        manager.sendAddOrRemoveBasket(segmentifyObject: basket)
    }

    private static func sendPurchase() async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            let checkout = CheckoutModel()
            checkout.totalPrice = SegmentifyMockData.Checkout.totalPrice
            checkout.orderNo = SegmentifyMockData.Checkout.orderNo
            checkout.productList = SegmentifyMockData.Checkout.productList
            checkout.lang = SegmentifyConfiguration.language
            checkout.currency = SegmentifyConfiguration.currency
            manager.sendPurchase(segmentifyObject: checkout) { recommendations in
                complete(recommendationSummary(recommendations))
            }
        }
    }

    private static func sendLegacyRegister() {
        let user = UserModel()
        user.email = SegmentifyMockData.User.email
        user.externalId = SegmentifyMockData.User.externalId
        manager.sendUserRegister(segmentifyObject: user)
    }

    private static func sendLegacyLogin() {
        let user = UserModel()
        user.email = SegmentifyMockData.User.email
        user.externalId = SegmentifyMockData.User.externalId
        manager.sendUserLogin(segmentifyObject: user)
    }

    private static func sendLegacyLogout() {
        let user = UserModel()
        user.email = SegmentifyMockData.User.email
        user.externalId = SegmentifyMockData.User.externalId
        manager.sendUserLogout(segmentifyObject: user)
    }

    private static func sendIdentifyUser(_ params: [String: Any]) async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            manager.identifyUser(params) {
                complete(dispatched)
            }
        }
    }

    private static func sendCustomEvent(type: String, params: [String: AnyObject]) async -> Any {
        await EventCallbackTimeout.run(fallback: callbackTimeoutFallback) { complete in
            manager.sendCustomEvent(type: type, params: params, lang: SegmentifyConfiguration.language) { recommendations in
                complete(recommendationSummary(recommendations))
            }
        }
    }

    private static func sendClick(instanceId: String, interactionId: String) {
        manager.sendClickView(instanceId: instanceId, interactionId: interactionId)
    }

    private static func sendWidgetView(instanceId: String, interactionId: String) {
        manager.sendWidgetView(instanceId: instanceId, interactionId: interactionId)
    }

    private static func sendImpression(instanceId: String, interactionId: String) {
        manager.sendImpression(instanceId: instanceId, interactionId: interactionId)
    }

    private static func sendSearchClickView(instanceId: String, interactionId: String) {
        manager.sendSearchClickView(instanceId: instanceId, interactionId: interactionId)
    }

    private static func sendPushPermissionInfo(deviceToken: String, userId: String) {
        let notification = NotificationModel()
        notification.deviceToken = deviceToken
        notification.type = NotificationType.PERMISSION_INFO
        notification.providerType = ProviderType.FIREBASE
        notification.userId = userId
        manager.sendNotification(segmentifyObject: notification)
    }

    private static func sendPushView() {
        let notification = NotificationModel()
        notification.type = NotificationType.VIEW
        notification.providerType = ProviderType.FIREBASE
        notification.instanceId = SegmentifyMockData.Interaction.pushViewInstanceId
        manager.sendNotification(segmentifyObject: notification)
    }

    private static func sendPushClick() {
        let notification = NotificationModel()
        notification.deviceToken = ""
        notification.type = NotificationType.CLICK
        notification.providerType = ProviderType.FIREBASE
        notification.instanceId = SegmentifyMockData.Interaction.pushClickInstanceId
        manager.sendNotification(segmentifyObject: notification)
    }

    private static func recommendationSummary(_ recommendations: [RecommendationModel]) -> [String: Any] {
        ["recommendationCount": recommendations.count]
    }

    private static func instantSearchSummary(_ response: SearchModel) -> [String: Any] {
        [
            "keywords": response.keywords.count,
            "products": response.products?.count ?? 0,
            "lastSearches": response.lastSearches.count,
        ]
    }

    private static func facetedSearchSummary(_ response: FacetedResponseModel) -> [String: Any] {
        [
            "products": response.products?.count ?? 0,
            "facets": response.facets?.count ?? 0,
            "instanceId": response.instanceId ?? "",
        ]
    }
}

enum JSONFormatting {
    static func string(from value: Any) -> String {
        if JSONSerialization.isValidJSONObject(value),
           let data = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted, .sortedKeys]),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return String(describing: value)
    }
}
