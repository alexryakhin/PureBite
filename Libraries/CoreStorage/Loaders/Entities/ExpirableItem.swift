public final class ExpirableItem<Item> {

    public let item: Item
    public let isExpired: Bool

    public init(item: Item, isExpired: Bool) {
        self.item = item
        self.isExpired = isExpired
    }
}
