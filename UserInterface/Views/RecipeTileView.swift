import SwiftUI
import CachedAsyncImage
import Core
import CoreUserInterface
import Shared

struct RecipeTileView: View {

    struct Model {
        let recipeID: Int
        let title: String
        let imageURL: URL?
        let width: CGFloat?
        let height: CGFloat?
        let aspectRatio: CGFloat?

        init(
            recipeID: Int,
            title: String,
            imageURL: URL?,
            width: CGFloat? = nil,
            height: CGFloat? = RecipeTileView.standardHeight,
            aspectRatio: CGFloat? = 16/9
        ) {
            self.recipeID = recipeID
            self.title = title
            self.imageURL = imageURL
            self.width = width
            self.height = height
            self.aspectRatio = aspectRatio
        }
    }

    static let standardHeight: CGFloat = 160

    private var model: Model
    private var onTap: IntHandler

    init(model: Model, onTap: @escaping (Int) -> Void) {
        self.model = model
        self.onTap = onTap
    }

    var body: some View {
        Button {
            onTap(model.recipeID)
        } label: {
            GeometryReader { geometry in
                CachedAsyncImage(url: model.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                } placeholder: {
                    if model.imageURL == nil {
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
                    Text(model.title)
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
        .frame(width: model.width, height: model.height)
        .ifLet(model.aspectRatio, transform: { view, aspectRatio in
            view.aspectRatio(aspectRatio, contentMode: .fit)
        })
    }
}

#Preview {
    RecipeTileView(
        model: .init(
            recipeID: 1,
            title: "Cabbage Rolls",
            imageURL: URL(string:"https://picsum.photos/200")
        )
    ) { recipeID in
        print("On tap: \(recipeID)")
    }
}
