//
//  MainView.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/8/23.
//

import SwiftUI
import PhotosUI

struct MainView: View {
  
  struct SaveIngredient: Identifiable {
    let id = UUID()
    var name: String
    var show: Bool
  }
  
  @EnvironmentObject var viewModel: ViewModel
  @Environment(\.managedObjectContext) var viewContext
  
  @State private var ingredient: SaveIngredient = .init(name: "", show: false)
  
  var buttonLabel: String {
    return viewModel.recipe.isEmpty ? "Get Recipe" : "Get Different Recipe"
  }
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading) {
          HStack { Spacer() }
          FlowLayout(alignment: .leading, spacing: 10) {
            ForEach(viewModel.predictions) { prediction in
              FruitCell(prediction: prediction)
            }
          }
          
          HStack {
            Button {
              ingredient.show = true
            } label: {
              Label("Ingredient", systemImage: "plus.app")
            }
            .buttonStyle(.borderedProminent)
            .alert("🍓 Ingredient", isPresented: $ingredient.show, presenting: ingredient) { detail in
              TextField("Strawberry...", text: $ingredient.name)
              Button("Cancel") {
                ingredient.name = ""
              }
              Button("Save") {
                withAnimation {
                  let name = ingredient.name.removeExtraSpace.lowercased()
                  let prediction = Prediction(name: name)
                  viewModel.addPrediction(prediction)
                  ingredient.name = ""
                }
              }
            }
            
            if !viewModel.predictions.isEmpty {
              Button {
                Task {
                  await viewModel.generateRecipe()
                }
              } label: {
                Label(buttonLabel, systemImage: "wand.and.stars")
              }
              .buttonStyle(.borderedProminent)
              .tint(Color.pink)
            }
          }
          
          if viewModel.isGenerating {
            Divider()
              .padding(.vertical)
            HStack(spacing: 12) {
              Spacer()
              ProgressView()
              Text("Generating Recipe")
              Spacer()
            }
            .font(.headline)
          }
          
          if !viewModel.recipe.isEmpty && !viewModel.isGenerating {
            Divider()
              .padding(.vertical)
            Text(viewModel.recipe)
            Button("Save Recipe") {
              let components = viewModel.recipe.components(separatedBy: "\n")
              let name = components.first ?? "Untitle"
              let content = components.dropFirst().joined(separator: "\n")
              let recipe = Recipe(context: viewContext)
              recipe.name = name
              recipe.recipe = content
              try? viewContext.save()
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
            .frame(maxWidth: .infinity, alignment: .center)
          }
        }
        .padding()
      }
      .navigationTitle("Fruits IA")
      .toolbar {
        ToolbarItem {
          PhotosPicker(selection: $viewModel.imageSelection) {
            Label("Scan Image", systemImage: "rectangle.and.text.magnifyingglass")
          }
        }
      }
    }
  }
}


