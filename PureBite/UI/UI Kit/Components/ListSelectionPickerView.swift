import SwiftUI

struct ListSelectionPickerView<T: Searchable>: View {

    @State private var isSheetShown: Bool = false
    @Binding private var selectedItem: T?

    private let state: BasicInputView.State
    private let placeholder: String
    private let header: String?
    private let caption: String?
    private let sheetTitle: String
    private let items: [T]
    private let overrideTitle: String?
    private let customHandlersById: [String: VoidHandler]?
    private let isSearchable: Bool
    private let isShowingCloseButton: Bool

    init(
        placeholder: String,
        header: String? = nil,
        caption: String? = nil,
        state: BasicInputView.State,
        selectedItem: Binding<T?>,
        sheetTitle: String,
        items: [T],
        overrideTitle: String? = nil,
        customHandlersById: [String: VoidHandler]? = nil,
        isSearchable: Bool = true,
        isShowingCloseButton: Bool = true
    ) {
        self.placeholder = placeholder
        self.header = header
        self.caption = caption
        self.state = state
        self._selectedItem = selectedItem
        self.sheetTitle = sheetTitle
        self.items = items
        self.overrideTitle = overrideTitle
        self.customHandlersById = customHandlersById
        self.isSearchable = isSearchable
        self.isShowingCloseButton = isShowingCloseButton
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let header {
                Text(header)
                    .textStyle(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
            }
            Button {
                isSheetShown = true
            } label: {
                HStack {
                    Text(overrideTitle ?? (selectedItem?.name ?? placeholder))
                        .textStyle(.body)
                        .foregroundColor(selectedItem == nil && overrideTitle == nil ? .secondary : .primary)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .frame(height: 52)
                .background(state.backgroundColor.swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            if let caption {
                Text(caption)
                    .textStyle(.caption1)
                    .foregroundColor(state == .error ? .red : .secondary)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 12)
        .bottomSheet(isPresented: $isSheetShown, preferredSheetSizing: .fill) {
            ListSelectionView(
                isPresented: $isSheetShown,
                selectedItem: $selectedItem,
                title: sheetTitle,
                items: items,
                isSearchable: isSearchable,
                isShowingCloseButton: isShowingCloseButton,
                customHandlersById: customHandlersById
            )
        }
    }
}
