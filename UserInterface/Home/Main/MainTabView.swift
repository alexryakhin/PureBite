import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MainPageViewModel()
    @StateObject var searchViewModel = MainPageSearchViewModel()

    @State private var showingSearchResults = false


    var body: some View {
        NavigationView {
            MainPageView(viewModel: viewModel)
                .navigationTitle("PureBite")
                .navigationBarTitleDisplayMode(.large)
                .searchable(
                    text: $searchViewModel.searchTerm,
                    isPresented: $showingSearchResults,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search recipes..."
                )
                .onSubmit(of: .search) {
                    searchViewModel.handle(.search)
                }
                .overlay {
                    if showingSearchResults {
                        MainPageSearchView(viewModel: searchViewModel)
                    }
                }
        }
        .onChange(of: showingSearchResults) { isPresented in
            if !isPresented {
                searchViewModel.searchTerm = ""
            }
        }
        .onAppear {
            // Handle any tab-specific setup
        }
    }
}

#Preview {
    MainTabView()
} 
