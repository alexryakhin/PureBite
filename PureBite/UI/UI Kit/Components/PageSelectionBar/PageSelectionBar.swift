import SwiftUI

protocol PageInterface: Hashable {
    var title: String { get }
}

struct PageSelectionBar<Page: PageInterface>: View {

    @Binding private var selectedPage: Page
    private let pages: [Page]

    init(
        selectedPage: Binding<Page>,
        pages: [Page]
    ) {
        self._selectedPage = selectedPage
        self.pages = pages
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(pages, id: \.hashValue) { page in
                    pageSelector(for: page)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 6)
            .padding(.bottom, 12)
        }
    }

    private func pageSelector(for page: Page) -> some View {
        Button {
            guard selectedPage != page else { return }
            selectedPage = page
        } label: {
            Text(page.title)
                .textStyle(.caption1)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(selectedPage == page ? .accent : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(selectedPage == page ? .accent : .clear)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .strokeBorder(selectedPage == page ? .accent : .secondary, lineWidth: 1)
                }
        }
    }
}
