import SwiftUI
import Combine

@MainActor
open class SwiftUIBaseViewModel: ObservableObject {
    
    @Published public var isLoading = false
    @Published public var error: Error?
    @Published public var showError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func handleError(_ error: Error, showAsAlert: Bool = true) {
        self.error = error
        if showAsAlert {
            self.showError = true
        }
        fault("Error received: \(error)")
    }
    
    public func clearError() {
        error = nil
        showError = false
    }
    
    public func setLoading(_ loading: Bool) {
        isLoading = loading
    }
} 
