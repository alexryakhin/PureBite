import SwiftUI

struct ShoppingListTabView: View {
    @StateObject private var viewModel = ShoppingListPageViewModel()


    var body: some View {
        NavigationView {
            ShoppingListPageView(viewModel: viewModel)
                .navigationTitle("Shopping List")
                .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Handle any tab-specific setup
        }
    }
}

#Preview {
    ShoppingListTabView()
} 
