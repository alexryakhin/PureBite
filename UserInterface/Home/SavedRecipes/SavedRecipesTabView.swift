import SwiftUI
import Core
import CoreUserInterface
import Shared

public struct SavedRecipesTabView: View {
    @StateObject private var viewModel = SavedRecipesPageViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            SavedRecipesPageView(viewModel: viewModel)
                .navigationTitle("Saved Recipes")
                .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Handle any tab-specific setup
        }
    }
}

#Preview {
    SavedRecipesTabView()
} 
