import Foundation

public struct EmailData {

    public let subject: String
    public let recipients: [String]
    public let body: String

    /// Initialize an EmailData instance.
    ///
    /// It's not necessary to provide values to all possible arguments. Do so only for those actually needed.
    ///
    ///   ```swift
    ///     let emailData = EmailData(subject: "Subject", recipients: ["recipient@gmail.com"])
    ///   ```
    ///
    /// - Parameters:
    ///   - subject: Email subject.
    ///   - recipients: The potential recipients of the email.
    ///   - body: The email body.
    ///
    public init(subject: String = "", recipients: [String], body: String = "") {
        self.subject = subject
        self.recipients = recipients
        self.body = body
    }

    public func thirdPartyMailUrls() -> [URL] {
        guard let recipientEmail = self.recipients.first else { return [] }
        let subject = self.subject
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = self.body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let urlStrings: [String] = [
            "googlegmail:///co?to=\(recipientEmail)&subject=\(subjectEncoded)&body=\(bodyEncoded)",
            "sparrow:\(recipientEmail)?subject=\(subjectEncoded)&body=\(bodyEncoded)",
            "ms-outlook://compose?subject=\(subjectEncoded)&body=\(bodyEncoded)&to=\(recipientEmail)",
            "ymail://mail/compose?subject=\(subjectEncoded)&body=\(bodyEncoded)&to=\(recipientEmail)",
            "readdle-spark://compose?subject=\(subjectEncoded)&body=\(bodyEncoded)&recipient=\(recipientEmail)",
            "mailto:\(recipientEmail)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        ]

        return urlStrings.map { urlString in
            URL(string: urlString)
        }.compactMap { $0 }
    }
}
