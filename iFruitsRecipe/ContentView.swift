//
//  ContentView.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/2/23.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      MainView()
        .tabItem {
          Label("Home", systemImage: "house")
        }
      RecipesView()
        .tabItem {
          Label("Recipes", systemImage: "list.clipboard")
        }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(ViewModel.init())
      .environment(\.managedObjectContext, DataController.shared.container.viewContext)
  }
}
