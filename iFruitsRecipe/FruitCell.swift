//
//  FruitCell.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/6/23.
//

import SwiftUI

struct FruitCell: View {
  @EnvironmentObject var viewModel: ViewModel
  
  let prediction: Prediction
  
  var body: some View {
    Button {
      if let index = viewModel.predictions.firstIndex(of: prediction) {
        withAnimation {
          viewModel.predictions.remove(at: index)
        }
      }
    } label: {
      HStack(alignment: .center) {
        Text(prediction.name)
        Image(systemName: "xmark")
          .imageScale(.small)
      }
      .fontDesign(.monospaced)
      .bold()
    }
    .buttonStyle(.bordered)
  }
}
