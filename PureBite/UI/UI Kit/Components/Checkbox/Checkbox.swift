import SwiftUI

struct Checkbox: View {

    public enum CheckboxState {
        case checked, unchecked
        // for forms where checkbox must be checked to continue
        case uncheckedError
    }

    @Binding private var state: CheckboxState

    private let handler: VoidHandler?

    init(
        state: Binding<CheckboxState>,
        handler: VoidHandler? = nil
    ) {
        self._state = state
        self.handler = handler
    }

    var body: some View {
        checkboxImage(state: state)
            .frame(width: 24, height: 24)
            .onTapGesture {
                handler?()
                guard state != .checked else {
                    state = .unchecked
                    return
                }
                state = .checked
            }
    }

    func checkboxImage(state: CheckboxState) -> some View {
        switch state {
        case .checked:
            return Image(systemName: "checkmark.square")
                .resizable()
                .scaledToFill()
                .foregroundColor(.accentColor)
        case .unchecked:
            return Image(systemName: "square")
                .resizable()
                .scaledToFill()
                .foregroundColor(.secondary)
        case .uncheckedError:
            return Image(systemName: "square")
                .resizable()
                .scaledToFill()
                .foregroundColor(.red)
        }
    }
}
