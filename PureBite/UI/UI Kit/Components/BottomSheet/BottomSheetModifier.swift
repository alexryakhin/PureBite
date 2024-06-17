import SwiftUI

struct BottomSheet<T: Any, ContentView: View>: ViewModifier {
    @Binding private var isPresented: Bool

    private let ignoresKeyboard: Bool
    private let showsIndicator: Bool
    private let preferredSheetCornerRadius: CGFloat
    private let preferredSheetBackdropColor: UIColor
    private let preferredSheetSizing: BottomSheetSize
    private let tapToDismissEnabled: Bool
    private let panToDismissEnabled: Bool
    private var onDismiss: (() -> Void)?
    private var contentView: () -> ContentView

    @State private var bottomSheetHostingController: BottomSheetHostingController<ContentView>?

    init(
        isPresented: Binding<Bool>,
        ignoresKeyboard: Bool = true,
        showsIndicator: Bool = true,
        preferredSheetCornerRadius: CGFloat = 16,
        preferredSheetBackdropColor: UIColor = .label,
        preferredSheetSizing: BottomSheetSize = .fit,
        tapToDismissEnabled: Bool = true,
        panToDismissEnabled: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) {
        _isPresented = isPresented
        self.ignoresKeyboard = ignoresKeyboard
        self.showsIndicator = showsIndicator
        self.preferredSheetCornerRadius = preferredSheetCornerRadius
        self.preferredSheetBackdropColor = preferredSheetBackdropColor
        self.preferredSheetSizing = preferredSheetSizing
        self.tapToDismissEnabled = tapToDismissEnabled
        self.panToDismissEnabled = panToDismissEnabled
        self.contentView = contentView
        self.onDismiss = onDismiss
    }

    init(
        item: Binding<T?>,
        ignoresKeyboard: Bool = true,
        showsIndicator: Bool = true,
        preferredSheetCornerRadius: CGFloat = 16,
        preferredSheetBackdropColor: UIColor = .label,
        preferredSheetSizing: BottomSheetSize = .fit,
        tapToDismissEnabled: Bool = true,
        panToDismissEnabled: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) {
        self._isPresented = Binding<Bool>(get: {
            item.wrappedValue != nil
        }, set: { _ in
            item.wrappedValue = nil
        })
        self.ignoresKeyboard = ignoresKeyboard
        self.showsIndicator = showsIndicator
        self.preferredSheetCornerRadius = preferredSheetCornerRadius
        self.preferredSheetBackdropColor = preferredSheetBackdropColor
        self.preferredSheetSizing = preferredSheetSizing
        self.tapToDismissEnabled = tapToDismissEnabled
        self.panToDismissEnabled = panToDismissEnabled
        self.onDismiss = onDismiss
        self.contentView = contentView
    }

    func body(content: Content) -> some View {
        content.background(
            BottomSheetPresenter(
                isPresented: $isPresented,
                ignoresKeyboard: ignoresKeyboard,
                showsIndicator: showsIndicator,
                preferredSheetCornerRadius: preferredSheetCornerRadius,
                preferredSheetBackdropColor: preferredSheetBackdropColor,
                preferredSheetSizing: preferredSheetSizing,
                tapToDismissEnabled: tapToDismissEnabled,
                panToDismissEnabled: panToDismissEnabled,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }
}

extension View {

    /// Presents a bottom sheet when the binding to a Boolean value you provide is true. The bottom sheet
    /// can also be customised in the same way as a UISheetPresentationController can be.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier’s content closure.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - contentView: A closure that returns the content of the sheet.
    public func bottomSheet<ContentView: View>(
        isPresented: Binding<Bool>,
        ignoresKeyboard: Bool = true,
        showsIndicator: Bool = true,
        preferredSheetCornerRadius: CGFloat = 16,
        preferredSheetBackdropColor: UIColor = .label,
        preferredSheetSizing: BottomSheetSize = .fit,
        tapToDismissEnabled: Bool = true,
        panToDismissEnabled: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) -> some View {
        self.modifier(
            BottomSheet<Any, ContentView>(
                isPresented: isPresented,
                ignoresKeyboard: ignoresKeyboard,
                showsIndicator: showsIndicator,
                preferredSheetCornerRadius: preferredSheetCornerRadius,
                preferredSheetBackdropColor: preferredSheetBackdropColor,
                preferredSheetSizing: preferredSheetSizing,
                tapToDismissEnabled: tapToDismissEnabled,
                panToDismissEnabled: panToDismissEnabled,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }

    /// Presents a bottom sheet when the binding to an Optinal item you pass to it is not nil. The bottom sheet
    /// can also be customised in the same way as a UISheetPresentationController can be.
    /// - Parameters:
    ///   - item: A binding to an Optional item that determines whether to present the sheet that you create in the modifier’s content closure.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - contentView: A closure that returns the content of the sheet.
    public func bottomSheet<T: Any, ContentView: View>(
        item: Binding<T?>,
        ignoresKeyboard: Bool = true,
        showsIndicator: Bool = true,
        preferredSheetCornerRadius: CGFloat = 16,
        preferredSheetBackdropColor: UIColor = .label,
        preferredSheetSizing: BottomSheetSize = .fit,
        tapToDismissEnabled: Bool = true,
        panToDismissEnabled: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) -> some View {
        self.modifier(
            BottomSheet(
                item: item,
                ignoresKeyboard: ignoresKeyboard,
                showsIndicator: showsIndicator,
                preferredSheetCornerRadius: preferredSheetCornerRadius,
                preferredSheetBackdropColor: preferredSheetBackdropColor,
                preferredSheetSizing: preferredSheetSizing,
                tapToDismissEnabled: tapToDismissEnabled,
                panToDismissEnabled: panToDismissEnabled,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }
}
