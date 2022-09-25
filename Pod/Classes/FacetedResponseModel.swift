//
//  SegmentifyRegisterRequest.swift
//  Segmentify

import Foundation

// MARK: - FacetedResponseModel
public class FacetedResponseModel: Codable {
    var facets: [Facet]?
    var meta: Meta?
    var contents: [Content]?
    var banners: [Banner]?
    var meanings: [JSONAny]?
    var products: [Product]?
    var executable: Bool?
    var instanceId: String?

    init(facets: [Facet]?, meta: Meta?, contents: [Content]?, banners: [Banner]?, meanings: [JSONAny]?, products: [Product]?, executable: Bool?, instanceId: String?) {
        self.facets = facets
        self.meta = meta
        self.contents = contents
        self.banners = banners
        self.meanings = meanings
        self.products = products
        self.executable = executable
        self.instanceId = instanceId
    }
}

// MARK: FacetedResponseModel convenience initializers and mutators

extension FacetedResponseModel {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(FacetedResponseModel.self, from: data)
        self.init(facets: me.facets, meta: me.meta, contents: me.contents, banners: me.banners, meanings: me.meanings, products: me.products, executable: me.executable, instanceId: me.instanceId)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        facets: [Facet]?? = nil,
        meta: Meta?? = nil,
        contents: [Content]?? = nil,
        banners: [Banner]?? = nil,
        meanings: [JSONAny]?? = nil,
        products: [Product]?? = nil,
        executable: Bool?? = nil,
        instanceId: String?? = nil
    ) -> FacetedResponseModel {
        return FacetedResponseModel(
            facets: facets ?? self.facets,
            meta: meta ?? self.meta,
            contents: contents ?? self.contents,
            banners: banners ?? self.banners,
            meanings: meanings ?? self.meanings,
            products: products ?? self.products,
            executable: executable ?? self.executable,
            instanceId: instanceId ?? self.instanceId
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Banner
public class Banner: Codable {
    var id, instanceID, status, searchType: String?
    var name: String?
    var bannerURL: String?
    var targetURL: String?
    var position, width, height, method: String?
    var newtab: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case instanceID = "instanceId"
        case status, searchType, name
        case bannerURL = "bannerUrl"
        case targetURL = "targetUrl"
        case position, width, height, method, newtab
    }

    init(id: String?, instanceID: String?, status: String?, searchType: String?, name: String?, bannerURL: String?, targetURL: String?, position: String?, width: String?, height: String?, method: String?, newtab: Bool?) {
        self.id = id
        self.instanceID = instanceID
        self.status = status
        self.searchType = searchType
        self.name = name
        self.bannerURL = bannerURL
        self.targetURL = targetURL
        self.position = position
        self.width = width
        self.height = height
        self.method = method
        self.newtab = newtab
    }
}

// MARK: Banner convenience initializers and mutators

extension Banner {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Banner.self, from: data)
        self.init(id: me.id, instanceID: me.instanceID, status: me.status, searchType: me.searchType, name: me.name, bannerURL: me.bannerURL, targetURL: me.targetURL, position: me.position, width: me.width, height: me.height, method: me.method, newtab: me.newtab)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        instanceID: String?? = nil,
        status: String?? = nil,
        searchType: String?? = nil,
        name: String?? = nil,
        bannerURL: String?? = nil,
        targetURL: String?? = nil,
        position: String?? = nil,
        width: String?? = nil,
        height: String?? = nil,
        method: String?? = nil,
        newtab: Bool?? = nil
    ) -> Banner {
        return Banner(
            id: id ?? self.id,
            instanceID: instanceID ?? self.instanceID,
            status: status ?? self.status,
            searchType: searchType ?? self.searchType,
            name: name ?? self.name,
            bannerURL: bannerURL ?? self.bannerURL,
            targetURL: targetURL ?? self.targetURL,
            position: position ?? self.position,
            width: width ?? self.width,
            height: height ?? self.height,
            method: method ?? self.method,
            newtab: newtab ?? self.newtab
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Content
public class Content: Codable {
    var key, html: String?

    init(key: String?, html: String?) {
        self.key = key
        self.html = html
    }
}

// MARK: Content convenience initializers and mutators

extension Content {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Content.self, from: data)
        self.init(key: me.key, html: me.html)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        key: String?? = nil,
        html: String?? = nil
    ) -> Content {
        return Content(
            key: key ?? self.key,
            html: html ?? self.html
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Facet
public class Facet: Codable {
    var property: String?
    var items: [Item]?
    var filtered: [JSONAny]?
    var viewMode: String?

    init(property: String?, items: [Item]?, filtered: [JSONAny]?, viewMode: String?) {
        self.property = property
        self.items = items
        self.filtered = filtered
        self.viewMode = viewMode
    }
}

// MARK: Facet convenience initializers and mutators

extension Facet {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Facet.self, from: data)
        self.init(property: me.property, items: me.items, filtered: me.filtered, viewMode: me.viewMode)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        property: String?? = nil,
        items: [Item]?? = nil,
        filtered: [JSONAny]?? = nil,
        viewMode: String?? = nil
    ) -> Facet {
        return Facet(
            property: property ?? self.property,
            items: items ?? self.items,
            filtered: filtered ?? self.filtered,
            viewMode: viewMode ?? self.viewMode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Item
public class Item: Codable {
    var value: String?
    var count: Int?

    init(value: String?, count: Int?) {
        self.value = value
        self.count = count
    }
}

// MARK: Item convenience initializers and mutators

extension Item {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Item.self, from: data)
        self.init(value: me.value, count: me.count)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        value: String?? = nil,
        count: Int?? = nil
    ) -> Item {
        return Item(
            value: value ?? self.value,
            count: count ?? self.count
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Meta
public class Meta: Codable {
    var total: Int?
    var page: Page?
    var params: Params?

    init(total: Int?, page: Page?, params: Params?) {
        self.total = total
        self.page = page
        self.params = params
    }
}

// MARK: Meta convenience initializers and mutators

extension Meta {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Meta.self, from: data)
        self.init(total: me.total, page: me.page, params: me.params)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        total: Int?? = nil,
        page: Page?? = nil,
        params: Params?? = nil
    ) -> Meta {
        return Meta(
            total: total ?? self.total,
            page: page ?? self.page,
            params: params ?? self.params
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Page
public class Page: Codable {
    var current, rows: Int?
    var prev, next: Bool?

    init(current: Int?, rows: Int?, prev: Bool?, next: Bool?) {
        self.current = current
        self.rows = rows
        self.prev = prev
        self.next = next
    }
}

// MARK: Page convenience initializers and mutators

extension Page {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Page.self, from: data)
        self.init(current: me.current, rows: me.rows, prev: me.prev, next: me.next)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        current: Int?? = nil,
        rows: Int?? = nil,
        prev: Bool?? = nil,
        next: Bool?? = nil
    ) -> Page {
        return Page(
            current: current ?? self.current,
            rows: rows ?? self.rows,
            prev: prev ?? self.prev,
            next: next ?? self.next
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Params
public class Params: Codable {
    var defaultOrder: String?
    var currentRow: Int?
    var currency: String?
    var isCurrencyPlaceBefore: Bool?

    init(defaultOrder: String?, currentRow: Int?, currency: String?, isCurrencyPlaceBefore: Bool?) {
        self.defaultOrder = defaultOrder
        self.currentRow = currentRow
        self.currency = currency
        self.isCurrencyPlaceBefore = isCurrencyPlaceBefore
    }
}

// MARK: Params convenience initializers and mutators

extension Params {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Params.self, from: data)
        self.init(defaultOrder: me.defaultOrder, currentRow: me.currentRow, currency: me.currency, isCurrencyPlaceBefore: me.isCurrencyPlaceBefore)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        defaultOrder: String?? = nil,
        currentRow: Int?? = nil,
        currency: String?? = nil,
        isCurrencyPlaceBefore: Bool?? = nil
    ) -> Params {
        return Params(
            defaultOrder: defaultOrder ?? self.defaultOrder,
            currentRow: currentRow ?? self.currentRow,
            currency: currency ?? self.currency,
            isCurrencyPlaceBefore: isCurrencyPlaceBefore ?? self.isCurrencyPlaceBefore
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Product
public class Product: Codable {
    var productId: String?
    var name: String?
    var url: String?
    var image: String?
    var price: Double?
    var priceText: String?
    var oldPrice: Double?
    var oldPriceText, specialPriceText: String?
    var category: [String]?
    var lastUpdateTime: Int?
    var inStock: Bool?
    var insertTime, publishTime: Int?
    var brand: String?
    var language: String?
    var currency: String?
    var params: [String:String]?

    enum CodingKeys: String, CodingKey {
        case productId, name, url, image, price, priceText, oldPrice, oldPriceText, specialPriceText, category, lastUpdateTime, inStock, insertTime, publishTime, brand, language, currency, params
    }

    init(productId: String?, name: String?, url: String?, image: String?, price: Double?, priceText: String?, oldPrice: Double?, oldPriceText: String?, specialPriceText: String?, category: [String]?, lastUpdateTime: Int?, inStock: Bool?, insertTime: Int?, publishTime: Int?, brand: String?, language: String?, currency: String?, params: [String:String]?) {
        self.productId = productId
        self.name = name
        self.url = url
        self.image = image
        self.price = price
        self.priceText = priceText
        self.oldPrice = oldPrice
        self.oldPriceText = oldPriceText
        self.specialPriceText = specialPriceText
        self.category = category
        self.lastUpdateTime = lastUpdateTime
        self.inStock = inStock
        self.insertTime = insertTime
        self.publishTime = publishTime
        self.brand = brand
        self.language = language
        self.currency = currency
        self.params = params
    }
}

// MARK: Product convenience initializers and mutators

extension Product {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Product.self, from: data)
        self.init(productId: me.productId, name: me.name, url: me.url, image: me.image, price: me.price, priceText: me.priceText, oldPrice: me.oldPrice, oldPriceText: me.oldPriceText, specialPriceText: me.specialPriceText, category: me.category, lastUpdateTime: me.lastUpdateTime, inStock: me.inStock, insertTime: me.insertTime, publishTime: me.publishTime, brand: me.brand, language: me.language, currency: me.currency, params: me.params)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        productId: String?? = nil,
        name: String?? = nil,
        url: String?? = nil,
        image: String?? = nil,
        price: Double?? = nil,
        priceText: String?? = nil,
        oldPrice: Double?? = nil,
        oldPriceText: String?? = nil,
        specialPriceText: String?? = nil,
        category: [String]?? = nil,
        lastUpdateTime: Int?? = nil,
        inStock: Bool?? = nil,
        insertTime: Int?? = nil,
        publishTime: Int?? = nil,
        brand: String?? = nil,
        language: String?? = nil,
        currency: String?? = nil,
        params: [String:String]?? = nil
    ) -> Product {
        return Product(
            productId: productId ?? self.productId,
            name: name ?? self.name,
            url: url ?? self.url,
            image: image ?? self.image,
            price: price ?? self.price,
            priceText: priceText ?? self.priceText,
            oldPrice: oldPrice ?? self.oldPrice,
            oldPriceText: oldPriceText ?? self.oldPriceText,
            specialPriceText: specialPriceText ?? self.specialPriceText,
            category: category ?? self.category,
            lastUpdateTime: lastUpdateTime ?? self.lastUpdateTime,
            inStock: inStock ?? self.inStock,
            insertTime: insertTime ?? self.insertTime,
            publishTime: publishTime ?? self.publishTime,
            brand: brand ?? self.brand,
            language: language ?? self.language,
            currency: currency ?? self.currency,
            params: params ?? self.params
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
