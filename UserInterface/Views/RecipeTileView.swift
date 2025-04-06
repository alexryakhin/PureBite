import SwiftUI
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared

struct RecipeTileView: View {

    struct Model: Identifiable, Hashable {
        let id: Int
        let title: String

        var imageURL: URL? {
            ImageHelper.recipeImageUrl(for: id)
        }
    }

    struct Props {
        let model: Model
        let width: CGFloat?
        let height: CGFloat?
        let aspectRatio: CGFloat?
        let onTap: IntHandler

        init(
            model: Model,
            width: CGFloat? = nil,
            height: CGFloat? = RecipeTileView.standardHeight,
            aspectRatio: CGFloat? = 16/9,
            onTap: @escaping IntHandler
        ) {
            self.model = model
            self.width = width
            self.height = height
            self.aspectRatio = aspectRatio
            self.aspectRatio = aspectRatio
            self.onTap = onTap
        }
    }

    static let standardHeight: CGFloat = 160

    private var props: Props

    init(props: Props) {
        self.props = props
    }

    var body: some View {
        Button {
            props.onTap(props.model.id)
        } label: {
            GeometryReader { geometry in
                CachedAsyncImage(url: props.model.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                } placeholder: {
                    if props.model.imageURL == nil {
                        Image("foodMosaic300")
                            .resizable(resizingMode: .tile)
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                    } else {
                        ShimmerView(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                    }
                }
                .clippedWithBackground(.surface)
                .overlay(alignment: .bottomLeading) {
                    Text(props.model.title)
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
            model: .init(
                id: 1,
                title: "Cabbage Rolls"
            ),
            onTap: { recipeID in
                print("On tap: \(recipeID)")
            }
        )
    )
}
