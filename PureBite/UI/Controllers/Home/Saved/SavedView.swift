import SwiftUI
import Combine

struct SavedView: PageView {

    typealias Props = SavedContentProps
    typealias ViewModel = SavedViewModel

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
            VStack(spacing: 16) {
                ForEach(0..<6) { _ in
                    recipeCollectionView()
                }
            }
            .padding(16)
        } navigationBar: {
            VStack(spacing: 12) {
                Text("Saved")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SearchInputView(text: .constant(.empty), placeholder: "Search saved recipes")
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
                    .foregroundStyle(.accent)
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.accent)
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.accent)
                }
            }
            .frame(height: 180)
        }
    }
}

#Preview {
    SavedView(viewModel: .init(arg: 0))
}
