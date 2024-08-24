import SwiftUI

struct PageLoadingView: View {

    private let props: DefaultLoaderProps

    public init(
        props: DefaultLoaderProps
    ) {
        self.props = props
    }

    var body: some View {
        MediumSpinnerView(style: .accent)
            .frame(width: 24, height: 24)
    }
}
