//
//  ClassifyImage.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/6/23.
//

import SwiftUI

struct ClassifyImage: View {
  @EnvironmentObject var viewModel: ViewModel
  
  let imageState: ViewModel.ImageState
  
  var body: some View {
    switch imageState {
    case .success(let uiImage):
      Image(uiImage: uiImage)
        .resizable()
        .onAppear {
          DispatchQueue.global(qos: .userInitiated).async {
            viewModel.classifyImage()
          }
        }
    case .loading:
      ProgressView()
    case .empty:
      Text("Empty Image")
    case .failure:
      Text("Error")
    }
  }
}
