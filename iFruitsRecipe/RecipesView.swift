//
//  RecipesView.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/8/23.
//

import SwiftUI

struct RecipesView: View {
  @Environment(\.managedObjectContext) var viewContext
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)])
  private var recipes: FetchedResults<Recipe>
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading) {
          ForEach(recipes) { recipe in
            Text(recipe.name ?? "Unknown")
              .bold()
              .frame(maxWidth: .infinity)
          }
        }
        .padding()
      }
      .navigationTitle("Recipes")
    }
  }
}
