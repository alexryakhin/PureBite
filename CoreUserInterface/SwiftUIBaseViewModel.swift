import SwiftUI
import Combine

@MainActor
open class SwiftUIBaseViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func handleError(_ error: Error, showAsAlert: Bool = true) {
        self.error = error
        if showAsAlert {
            self.showError = true
        }
        fault("Error received: \(error)")
    }
    
    func clearError() {
        error = nil
        showError = false
    }
    
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
} 
