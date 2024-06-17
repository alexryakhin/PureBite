import UIKit

public extension KTextStyle {

    static let largeTitle = KTextStyle(
        name: "largeTitle",
        font: UIFont.preferredFont(forTextStyle: .largeTitle)
    )

    @available(iOS 17.0, *)
    static let extraLargeTitle = KTextStyle(
        name: "extraLargeTitle",
        font: UIFont.preferredFont(forTextStyle: .extraLargeTitle)
    )

    @available(iOS 17.0, *)
    static let extraLargeTitle2 = KTextStyle(
        name: "extraLargeTitle2",
        font: UIFont.preferredFont(forTextStyle: .extraLargeTitle2)
    )

    static let title1 = KTextStyle(
        name: "title1",
        font: UIFont.preferredFont(forTextStyle: .title1)
    )

    static let title2 = KTextStyle(
        name: "title2",
        font: UIFont.preferredFont(forTextStyle: .title2)
    )

    static let title3 = KTextStyle(
        name: "title3",
        font: UIFont.preferredFont(forTextStyle: .title3)
    )

    static let headline = KTextStyle(
        name: "headline",
        font: UIFont.preferredFont(forTextStyle: .headline)
    )

    static let subheadline = KTextStyle(
        name: "subheadline",
        font: UIFont.preferredFont(forTextStyle: .subheadline)
    )

    static let body = KTextStyle(
        name: "body",
        font: UIFont.preferredFont(forTextStyle: .body)
    )

    static let callout = KTextStyle(
        name: "callout",
        font: UIFont.preferredFont(forTextStyle: .callout)
    )

    static let footnote = KTextStyle(
        name: "footnote",
        font: UIFont.preferredFont(forTextStyle: .footnote)
    )

    static let caption1 = KTextStyle(
        name: "caption1",
        font: UIFont.preferredFont(forTextStyle: .caption1)
    )

    static let caption2 = KTextStyle(
        name: "caption2",
        font: UIFont.preferredFont(forTextStyle: .caption2)
    )

#if DEBUG
    static let allItems = [
        largeTitle,
        title1,
        title2,
        title3,
        headline,
        subheadline,
        body,
        callout,
        footnote,
        caption1,
        caption2
    ]
#endif
}
