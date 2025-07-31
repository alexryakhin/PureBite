import SwiftUI

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
    case shoppingList
}

#Preview {
    ContentView()
} 
