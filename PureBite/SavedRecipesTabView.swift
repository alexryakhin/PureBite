import SwiftUI
import Core
import CoreUserInterface
import UserInterface
import Shared

struct SavedRecipesTabView: View {
    @StateObject private var viewModel = SavedRecipesPageViewModel()
    
    var body: some View {
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