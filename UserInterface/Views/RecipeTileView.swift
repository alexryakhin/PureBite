import SwiftUI
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared

struct RecipeTileView: View {

    struct Props {
        let recipeShortInfo: RecipeShortInfo
        let width: CGFloat?
        let height: CGFloat?
        let aspectRatio: CGFloat?
        let onTap: VoidHandler

        init(
            recipeShortInfo: RecipeShortInfo,
            width: CGFloat? = nil,
            height: CGFloat? = RecipeTileView.standardHeight,
            aspectRatio: CGFloat? = 16/9,
            onTap: @escaping VoidHandler
        ) {
            self.recipeShortInfo = recipeShortInfo
            self.width = width
            self.height = height
            self.aspectRatio = aspectRatio
            self.onTap = onTap
        }
    }

    static let standardHeight: CGFloat = 160
    @State private var imageExists: Bool = true

    private var props: Props

    init(props: Props) {
        self.props = props
    }

    var body: some View {
        Button {
            props.onTap()
        } label: {
            GeometryReader { geometry in
                CachedAsyncImage(url: props.recipeShortInfo.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ShimmerView(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                    case .failure:
                        Image(.foodMosaic300)
                            .resizable(resizingMode: .tile)
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                    }
                }
                .clippedWithBackground(.surface)
                .overlay(alignment: .bottomLeading) {
                    Text(props.recipeShortInfo.title)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.label)
                        .padding(5)
                        .background(.thinMaterial)
                        .cornerRadius(6)
                        .padding(5)

                }
            }
        }
        .frame(width: props.width, height: props.height)
        .ifLet(props.aspectRatio, transform: { view, aspectRatio in
            view.aspectRatio(aspectRatio, contentMode: .fit)
        })
    }
}

#Preview {
    RecipeTileView(
        props: .init(
            recipeShortInfo: .mock,
            onTap: {
                print("On tap recipe")
            }
        )
    )
}
