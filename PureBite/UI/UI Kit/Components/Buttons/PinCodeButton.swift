import SwiftUI

struct DigitPinCodeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DigitPinCodeButton(configuration: configuration)
    }

    private struct DigitPinCodeButton: View {
        let configuration: ButtonStyle.Configuration

        var body: some View {
            configuration.label
                .font(KTextStyle.title2.swiftUIFont)
                .padding(.horizontal, 24)
                .padding(.vertical, 18)
                .background(
                    Rectangle()
                        .fill(
                            configuration.isPressed ? .white.opacity(0.5) : .black.opacity(0.0000001) // hack to be invisible but tapable
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 28)
                        )
                        .frame(width: 64, height: 64)
                )
        }
    }
}
