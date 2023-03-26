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
        .onDelete { indexSet in
          viewContext.delete(recipes[indexSet.first!])
          try? viewContext.save()
        }
      }
      .navigationTitle("Recipes")
      .toolbar {
        EditButton()
      }
    }
  }
}

struct RecipeDetailView: View {
  @ObservedObject var recipe: Recipe
  
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss
  
  let fruitName = ["carrot", "fork.knife", "cup.and.saucer", "takeoutbag.and.cup.and.straw", "wineglass"].randomElement()!
  let color = [Color.red, .green, .gray, .orange, .blue, .black, .pink, .brown].randomElement()!
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        color
          .frame(height: 200)
          .overlay(alignment: .bottomLeading) {
            HStack(alignment: .bottom) {
              Text(recipe.name ?? "N/A")
                .font(.title2)
                .padding()
              Spacer()
              Image(systemName: fruitName)
                .font(.system(size: 80))
                .padding()
                .padding(.top, 25)
            }
          }
          .foregroundColor(.white)
        
        Text(recipe.recipe ?? "")
          .padding()
        
        Spacer()
      }
      
    }
    .edgesIgnoringSafeArea(.top)

  }
}


struct RecepDetailView_Previews: PreviewProvider {
  static var previews: some View {
    container()
  }
  
  struct container: View {
    var body: some View {
      ScrollView {
        VStack(alignment: .leading) {
          Color.orange
            .frame(height: 200)
            .overlay(alignment: .topTrailing) {
              Image(systemName: "carrot")
                .font(.system(size: 80))
                .padding()
            }
            .overlay(alignment: .bottomLeading) {
              Text("Recepi")
                .font(.title)
                .padding()
            }
            .foregroundColor(.white)
          
          Text("Food")
            .padding()
          
          Spacer()
        }
        
      }
      .edgesIgnoringSafeArea(.top)
    }
  }
}
