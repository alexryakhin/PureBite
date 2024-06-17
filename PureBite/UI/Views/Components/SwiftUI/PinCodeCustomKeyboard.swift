import SwiftUI

struct PinCodeCustomKeyboard: View {

    private let onButtonTapped: StringHandler
    private let rightButton: ImagePinCodeButton?
    private let leftButton: ImagePinCodeButton?

    init(
        onButtonTapped: @escaping StringHandler,
        rightButton: ImagePinCodeButton?,
        leftButton: ImagePinCodeButton?
    ) {
        self.onButtonTapped = onButtonTapped
        self.rightButton = rightButton
        self.leftButton = leftButton
    }

    private let columns = [
        GridItem(.flexible(minimum: 64, maximum: .infinity)),
        GridItem(.flexible(minimum: 64, maximum: .infinity)),
        GridItem(.flexible(minimum: 64, maximum: .infinity))
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
            ForEach(1...9, id: \.self) { number in
                Button(String(number)) {
                    onButtonTapped(String(number))
                }
                .buttonStyle(DigitPinCodeButtonStyle())
            }
            if let leftButton = leftButton {
                leftButton
            } else {
                Spacer()
            }
            Button("0") {
                onButtonTapped("0")
            }
            .buttonStyle(DigitPinCodeButtonStyle())
            if let rightButton = rightButton {
                rightButton
            } else {
                Spacer()
            }
        }
    }
}

#Preview {
    PinCodeCustomKeyboard(
        onButtonTapped: { _ in }, 
        rightButton: ImagePinCodeButton(
            image: Image(systemName: "delete.left"),
            action: {}
        ), 
        leftButton: nil
    )
}
