import SwiftUI

struct LargeSpinnerView: UIViewRepresentable {
    let style: LargeSpinner.Style

    init(style: LargeSpinner.Style = .dark) {
        self.style = style
    }

    func makeUIView(context: Context) -> LargeSpinner {
        let spinner = LargeSpinner(style: style)
        spinner.start()
        return spinner
    }

    func updateUIView(_ uiView: LargeSpinner, context: Context) {}
}
