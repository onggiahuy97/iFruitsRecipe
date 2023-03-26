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
              let prediction = Prediction(name: text.removeExtraSpace)
              if !viewModel.predictions.contains(where: { $0.name == prediction.name }) {
                viewModel.predictions.append(prediction)
              }
              self.text = ""
            }
        }
        
        Divider()
        
        Text(viewModel.recipe)
        
      }
      .padding()
    }
  }
}

struct FruitsDetail_Previews: PreviewProvider {
  static var previews: some View {
    FruitsDetail()
      .environmentObject(ViewModel())
  }
}
