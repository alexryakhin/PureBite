protocol SnacksDisplay: AnyObject {
    /// Errors with snack presentation type are enabled. If disabled, such errors will be ignored
    var snacksPresentingAvailable: Bool { get set }

    /// Present snack
    func showSnack(withConfig snackConfig: SnackView.Config)
}
