public enum CountdownTimerState: Equatable {

    case idle
    case running(secondsLeft: Int)
    case finished
}
