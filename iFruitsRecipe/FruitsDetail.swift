//
//  FruitsDetail.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/6/23.
//

import SwiftUI

struct FruitsDetail: View {
  @EnvironmentObject var viewModel: ViewModel
  
  @State private var text = ""
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading) {
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
          
          Text(viewModel.recipe)
            
        }
        .padding()
      }
      .navigationTitle("Fruits")
      .toolbar {
        ToolbarItem {
          Button("Get Recipe") {
            Task {
              await viewModel.generateRecipe()
            }
          }
        }
      }
    }
  }
}
