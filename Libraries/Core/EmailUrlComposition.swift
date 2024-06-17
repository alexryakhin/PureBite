public struct EmailUrlComposition {
    public let recipient: String
    public let subject: String
    public let body: String

    public init(recipient: String, subject: String, body: String) {
        self.recipient = recipient
        self.subject = subject
        self.body = body
    }

    public var emailUrlString: String? {
        "mailto:\(recipient)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
