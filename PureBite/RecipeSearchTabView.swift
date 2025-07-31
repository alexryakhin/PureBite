import SwiftUI
import Core
import CoreUserInterface
import UserInterface
import Shared

struct RecipeSearchTabView: View {
    @StateObject private var viewModel = RecipeSearchPageViewModel()
    
    var body: some View {
        NavigationView {
            RecipeSearchPageView(viewModel: viewModel)
                .navigationTitle("Search Recipes")
                .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Handle any tab-specific setup
        }
    }
}

#Preview {
    RecipeSearchTabView()
} 