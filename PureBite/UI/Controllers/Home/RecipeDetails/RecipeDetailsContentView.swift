import SwiftUI
import Combine

struct RecipeDetailsContentView: ViewWithBackground {

    typealias Props = RecipeDetailsContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var content: some View {
        ScrollView {
            VStack {
                if let image = props.recipe.image {
                    expandingImage(urlString: image)
                }


                Text("\(props.recipe.title)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(alignment: .top) {
            overlayButtons()
        }
    }

    private func expandingImage(urlString: String) -> some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let height = max(280, 280 + offset)

            AsyncImage(url: URL(string: urlString)) { imageView in
                imageView
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: height
                    )
                    .clipped()
            } placeholder: {
                Color.background
                    .shimmering()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: height
                    )
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.background, Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 130)
                .offset(y: height - 130),
                alignment: .top
            )
            .offset(y: offset > 0 ? -offset : 0)
            .frame(height: height)
        }
        .frame(height: 280)
    }

    private func overlayButtons() -> some View {
        HStack {
            Button {
                props.send(event: .finish)
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
            .padding(16)
            .background()
            .clipShape(Circle())
            .shadow(radius: 5)

            Spacer()

            Button {
                props.send(event: .favorite)
            } label: {
                Image(systemName: "bookmark")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
            .padding(16)
            .background()
            .clipShape(Circle())
            .shadow(radius: 5)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let recipe: Recipe? = Bundle.main.decode("recipeInformation")
    return RecipeDetailsContentView(props: .init(recipe: recipe ?? Recipe(id: 0, title: "Title")))
}
