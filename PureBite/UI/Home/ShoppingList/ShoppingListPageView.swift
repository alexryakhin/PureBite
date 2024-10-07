import SwiftUI
import Combine

public struct ShoppingListPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: ShoppingListPageViewModel

    // MARK: - Initialization

    public init(viewModel: ShoppingListPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        ScrollViewWithCustomNavBar {
            VStack {
                ForEach(0..<6) { _ in
                    recipeCollectionView()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

        } navigationBar: {
            VStack(spacing: 12) {
                Text("Shopping List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SearchInputView(text: .constant(.empty))
            }
            .padding(16)
        }
    }

    func recipeCollectionView() -> some View {
        VStack {
            HStack {
                Text("Recipe Collection View")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    // action
                } label: {
                    Text("See more")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
            }

            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.blue)
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.blue)
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.blue)
                }
            }
            .frame(height: 180)
        }
    }
}

#Preview {
    ShoppingListPageView(viewModel: .init(arg: 0))
}
