import SwiftUI

struct ImagePinCodeButton: View {
    private let image: Image
    private let action: VoidHandler

    init(
        image: Image,
        action: @escaping VoidHandler
    ) {
        self.image = image
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            image
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.black)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(DigitPinCodeButtonStyle())
    }
}
