import SwiftUI

struct MediumSpinnerView: UIViewRepresentable {
    let style: MediumSpinner.Style

    init(style: MediumSpinner.Style = .dark) {
        self.style = style
    }

    func makeUIView(context: Context) -> MediumSpinner {
        let spinner = MediumSpinner(style: style)
        spinner.start()
        return spinner
    }

    func updateUIView(_ uiView: MediumSpinner, context: Context) {}
}
