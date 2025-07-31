import SwiftUI
import Core
import CoreUserInterface
import UserInterface
import Shared

struct ContentView: View {
    
    @State private var selectedTab: TabItem = .main
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainTabView()
                .tabItem {
                    Image(systemName: selectedTab == .main ? "house.fill" : "house")
                    Text("Main")
                }
                .tag(TabItem.main)
            
            RecipeSearchTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(TabItem.search)
            
            SavedRecipesTabView()
                .tabItem {
                    Image(systemName: selectedTab == .saved ? "bookmark.fill" : "bookmark")
                    Text("Saved")
                }
                .tag(TabItem.saved)
            
            ShoppingListTabView()
                .tabItem {
                    Image(systemName: selectedTab == .shoppingList ? "list.bullet.rectangle.portrait.fill" : "list.bullet.rectangle.portrait")
                    Text("Shopping List")
                }
                .tag(TabItem.shoppingList)
        }
        .accentColor(.accentColor)
    }
}

enum TabItem: Int, CaseIterable {
    case main
    case search
    case saved
    case shoppingList
    case profile
}

#Preview {
    ContentView()
} 