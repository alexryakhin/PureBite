import SwiftUI

struct ListSelectionView<T: Searchable>: View {

    @Binding private var isPresented: Bool
    @Binding private var selectedItem: T?
    @Binding private var selectedItems: [T]

    private let title: String
    private let items: [T]
    private let isSearchable: Bool
    private let isShowingCloseButton: Bool
    private let isMultipleSelection: Bool
    private let customHandlersById: [String: VoidHandler]?
    private let bottomButtonText: String?
    private let bottomButtonOnTap: VoidHandler?

    @State private var scrollOffset: CGFloat = .zero
    @State private var searchInputValue: String = ""

    private var filteredItems: [T] {
        items.filter {
            searchInputValue.isEmpty
            ? true
            : $0.name.localizedStandardContains(searchInputValue)
        }
    }

    init(
        isPresented: Binding<Bool>,
        selectedItem: Binding<T?>,
        title: String,
        items: [T],
        isSearchable: Bool = true,
        isShowingCloseButton: Bool = true,
        customHandlersById: [String: VoidHandler]? = nil,
        bottomButtonText: String? = nil,
        bottomButtonOnTap: VoidHandler? = nil
    ) {
        self._isPresented = isPresented
        self._selectedItem = selectedItem
        self._selectedItems = .constant([])
        self.title = title
        self.items = items
        self.isSearchable = isSearchable
        self.isShowingCloseButton = isShowingCloseButton
        self.customHandlersById = customHandlersById
        self.bottomButtonText = bottomButtonText
        self.bottomButtonOnTap = bottomButtonOnTap
        isMultipleSelection = false
    }

    init(
        isPresented: Binding<Bool>,
        selectedItems: Binding<[T]>,
        title: String,
        items: [T],
        isSearchable: Bool = true,
        isShowingCloseButton: Bool = true,
        customHandlersById: [String: VoidHandler]? = nil,
        bottomButtonText: String? = nil,
        bottomButtonOnTap: VoidHandler? = nil
    ) {
        self._isPresented = isPresented
        self._selectedItem = .constant(nil)
        self._selectedItems = selectedItems
        self.title = title
        self.items = items
        self.isSearchable = isSearchable
        self.isShowingCloseButton = isShowingCloseButton
        self.customHandlersById = customHandlersById
        self.bottomButtonText = bottomButtonText
        self.bottomButtonOnTap = bottomButtonOnTap
        isMultipleSelection = true
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Text(title)
                        .textStyle(.title2)
                        .foregroundColor(.primary)
                    Spacer()
                    if isShowingCloseButton {
                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.primary)
                        }
                    }
                }
                if isSearchable {
                    SearchInputView(text: $searchInputValue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)

            Divider()
                .opacity(-(scrollOffset / 3.0))

            if filteredItems.isNotEmpty {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredItems) { item in
                            if isMultipleSelection {
                                checkboxCell(for: item, isLastCell: filteredItems.last == item)
                            } else {
                                itemCell(for: item, isLastCell: filteredItems.last == item)
                            }
                        }
                    }
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named(ScrollOffsetPreferenceKey.coordinateSpaceName)).origin
                        )
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = value.y
                    }
                    .background(.secondary)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
                .coordinateSpace(name: ScrollOffsetPreferenceKey.coordinateSpaceName)
                .animation(.default, value: filteredItems)
            } else {
                VStack {
                    Spacer()
                    Text("Not Found")
                        .textStyle(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    Text("Nothing was found")
                        .textStyle(.caption1)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            if let bottomButtonText, let bottomButtonOnTap {
                Divider()
                StyledButton(
                    stretchedText: bottomButtonText,
                    style: .secondary,
                    onTap: bottomButtonOnTap
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
    }

    @ViewBuilder private func itemCell(for model: T, isLastCell: Bool) -> some View {
        VStack(spacing: 0) {
            Button {
                if let customHandlersById,
                   let id = model.id as? String,
                   let customHandler = customHandlersById[id] {
                    customHandler()
                } else {
                    selectedItem = model
                }
                isPresented = false
            } label: {
                HStack {
                    Text(model.name)
                        .textStyle(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            if !isLastCell {
                Divider()
                    .padding(.leading, 16)
            }
        }
    }

    @ViewBuilder private func checkboxCell(for item: T, isLastCell: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                checkboxImage(for: item)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.accent)
                    .frame(width: 24, height: 24)

                Text(item.name)
                    .textStyle(.body)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .topLeading)

            if !isLastCell {
                Divider().padding(.leading, 52)
            }
        }
        .onTapGesture {
            if let index = selectedItems.firstIndex(of: item) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(item)
            }
        }
    }

    private func checkboxImage(for item: T) -> Image {
        selectedItems.contains(item)
        ? Image(systemName: "checkmark.square")
        : Image(systemName: "square")
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let coordinateSpaceName = "scroll"
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

#Preview {
    struct Model: Searchable {
        let id = UUID()
        let name: String
    }
    let models: [Model] = [.init(name: "One"), .init(name: "Two"), .init(name: "Three"), .init(name: "Four")]
    return ListSelectionView(isPresented: .constant(false), selectedItem: .constant(models[0]), title: "Title", items: models)
}
