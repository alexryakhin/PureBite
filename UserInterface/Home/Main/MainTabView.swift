import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MainPageViewModel()
    @StateObject var searchViewModel = MainPageSearchViewModel()

    @State private var showingSearchResults = false
    @Namespace private var namespace

    var body: some View {
        NavigationView {
            MainPageView(viewModel: viewModel, namespace: namespace) {
                withAnimation {
                    showingSearchResults = true
                }
            }
            .onSubmit(of: .search) {
                searchViewModel.handle(.search)
            }
            .overlay {
                if showingSearchResults {
                    MainPageSearchView(
                        viewModel: searchViewModel,
                        namespace: namespace
                    ) {
                        showingSearchResults = false
                        searchViewModel.searchTerm = ""
                        searchViewModel.searchResults.removeAll()
                    }
                    .transition(.opacity)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    MainTabView()
} 
