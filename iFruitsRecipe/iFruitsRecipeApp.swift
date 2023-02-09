//
//  iFruitsRecipeApp.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/2/23.
//

import SwiftUI

@main
struct iFruitsRecipeApp: App {
  @StateObject var viewModel = ViewModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(viewModel)
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
  }
}
