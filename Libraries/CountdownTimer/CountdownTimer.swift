import Foundation

public protocol CountdownTimerProtocol: AnyObject {

    var state: CountdownTimerState { get }
    /// All state changes
    var onStateChanged: ((CountdownTimerState) -> Void)? { get set }
    /// Countdown state changes with seconds left
    var onCountdown: ((Int) -> Void)? { get set }
    /// Finish state changes
    var onFinish: (() -> Void)? { get set }

    func startCountdown(from seconds: Int)
    func stop()
}

public final class CountdownTimer: CountdownTimerProtocol {

    public var onStateChanged: ((CountdownTimerState) -> Void)?
    public var onCountdown: ((Int) -> Void)?
    public var onFinish: (() -> Void)?

    public var state: CountdownTimerState = .idle

    private var task: Task<Void, Never>?
    private var secondsLeft = 0

    // MARK: - Init

    public init() { }

    // MARK: - Public Methods

    public func startCountdown(from seconds: Int) {
        task?.cancel()
        secondsLeft = seconds
        set(state: .running(secondsLeft: seconds))
        task = Task(priority: .userInitiated) { @MainActor in
            await waitSecond()
            countDown()
            if !Task.isCancelled {
                startCountdown(from: seconds - 1)
            }
        }
    }

    public func stop() {
        set(state: .idle)
        task?.cancel()
    }

    // MARK: - Private Methods

    private func countDown() {
        guard case .running = state else { return }
        secondsLeft -= 1
        if secondsLeft <= 0 {
            set(state: .finished)
            stop()
        }
    }

    private func set(state: CountdownTimerState) {
        self.state = state
        onStateChanged?(state)
        if case .running(let secondsLeft) = state {
            onCountdown?(secondsLeft)
        }
        if case .finished = state {
            onFinish?()
        }
    }

    private func waitSecond() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
