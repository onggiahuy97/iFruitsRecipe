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
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(recipes) { recipe in
          NavigationLink {
            RecipeDetailView(recipe: recipe)
          } label: {
            Text(recipe.name ?? "")
          }
        }
      }
      .navigationTitle("Recipes")
    }
  }
}

struct RecipeDetailView: View {
  @ObservedObject var recipe: Recipe
  
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading) {
          Text(recipe.recipe ?? "")
        }
        .padding()
      }
      .navigationTitle(recipe.name ?? "")
      .toolbar {
        ToolbarItem {
          Button("Delete") {
            viewContext.delete(recipe)
            try? viewContext.save()
            self.dismiss()
          }
        }
      }
    }
  }
}
