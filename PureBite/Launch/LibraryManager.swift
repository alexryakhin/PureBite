import FirebaseCore

/// Manager for configuring and launching external libraries
final class LibraryManager {

    func setupFirebase() {
//        FirebaseApp.configure()
    }

    func setupLogger() {
        logger.moduleName = "PURE_BITE"

        let message: String
#if DEBUG
        logger.minLogLevel = .debug
        message = "Logger level: SHOW ALL EVENTS"
#else
        message = "SWIFT_ACTIVE_COMPILATION_CONDITIONS is not set"
#endif
        logger.log(message, eventLevel: .important)
    }
}
