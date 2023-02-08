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
    }
  }
}
