import SwiftUI
import Combine

@MainActor
struct MainContentView: View {

    typealias Props = MainContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var body: some View {
        ScrollView {
            VStack {
                Text("Recipies")
                    .textStyle(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                recipes
            }
            .padding()
        }
        .searchable(text: $props.searchTerm)
    }

    var recipes: some View {
        VStack(spacing: 0) {
            ForEach(props.recipes) {
                recipeCell(for: $0, isLastCell: props.recipes.last?.id == $0.id)
            }
        }
        .background(.quaternary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func recipeCell(for recipe: Recipe, isLastCell: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .font(.headline)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)

            if !isLastCell {
                Divider()
            }
        }
        .onTapGesture {
            props.send(event: .openRecipeDetails(id: recipe.id))
        }
    }
}

#Preview {
    MainContentView(props: MainContentProps(recipes: MainContentProps.previewRecipes))
}
