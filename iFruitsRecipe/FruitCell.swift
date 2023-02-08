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
    HStack(alignment: .center) {
      Text(prediction.name)
      Button {
        guard let index = viewModel.predictions.firstIndex(where: { $0.id == prediction.id }) else { return }
        viewModel.predictions.remove(at: index)
      } label: {
        Image(systemName: "xmark")
          .imageScale(.small)
      }
    }
    .padding(6)
    .background(Color.secondary.opacity(0.2))
    .cornerRadius(5)
  }
}
