public struct TelegramUrlComposition {
    public let userName: String

    public init(userName: String) {
        self.userName = userName
    }

    public var tgUrlString: String {
        "tg://resolve?domain=\(userName)"
    }
}
