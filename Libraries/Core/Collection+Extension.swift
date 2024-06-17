public extension Collection where Element: Equatable {

    var removedDuplicates: [Element] {
       var uniqueElements: [Element] = []
       for element in self where !uniqueElements.contains(element) {
           uniqueElements.append(element)
       }
       return uniqueElements
    }
}
