//
//  MainView.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/8/23.
//

import SwiftUI
import PhotosUI

struct MainView: View {
  @EnvironmentObject var viewModel: ViewModel
  
  @State private var text = ""
  
  private let colums: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 10) {
          Text("Ingredients")
            .bold()
          
          FlowLayout(alignment: .leading, spacing: 10) {
            ForEach(viewModel.predictions) { prediction in
              FruitCell(prediction: prediction)
            }
            TextField("Add Fruit", text: $text)
              .textFieldStyle(.roundedBorder)
              .onSubmit {
                viewModel.predictions.append(Prediction(name: text))
                self.text = ""
              }
          }
          
          Divider()
            .padding(.vertical, 5)
          
          if !viewModel.recipe.isEmpty {
            Text("Recipe")
              .bold()
            Text(viewModel.recipe)
          }
          
        }
        .padding()
      }
      .navigationTitle("Fruits IA")
      .toolbar {
        ToolbarItem {
          PhotosPicker(selection: $viewModel.imageSelection) {
            Text("Pick Image")
          }
        }
        ToolbarItem {
          Button("Generate Recipe") {
            Task {
             await viewModel.generateRecipe()
            }
          }
        }
      }
    }
  }
}
