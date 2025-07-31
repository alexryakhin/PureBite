import SwiftUI
import Core
import CoreUserInterface
import Shared

public struct ShoppingListTabView: View {
    @StateObject private var viewModel = ShoppingListPageViewModel()

    public init() {}

    public var body: some View {
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
