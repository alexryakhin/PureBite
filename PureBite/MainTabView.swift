import SwiftUI
import Core
import CoreUserInterface
import UserInterface
import Shared

struct MainTabView: View {
    @StateObject private var viewModel = MainPageViewModel()
    
    var body: some View {
        NavigationView {
            MainPageView(viewModel: viewModel)
                .navigationTitle("PureBite")
                .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Handle any tab-specific setup
        }
    }
}

#Preview {
    MainTabView()
} 