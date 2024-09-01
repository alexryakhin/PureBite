import SwiftUI
import Combine

struct ShoppingListView: PageView {

    typealias Props = ShoppingListContentProps
    typealias ViewModel = ShoppingListViewModel

    // MARK: - Private properties

    @ObservedObject var props: Props
    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.props = viewModel.state.contentProps
    }

    // MARK: - Views

    var contentView: some View {
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
                    .textStyle(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    // action
                } label: {
                    Text("See more")
                        .textStyle(.caption1)
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
    ShoppingListView(viewModel: .init(arg: 0))
}
