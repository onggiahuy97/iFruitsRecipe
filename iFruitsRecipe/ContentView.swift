//
//  ContentView.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/2/23.
//

import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var showPredictions = false
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 10) {
          ClassifyImage(imageState: viewModel.imageState)
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipped()
          
          Spacer()
        }
        .sheet(isPresented: $showPredictions) {
          FruitsDetail()
            .presentationDetents([.medium, .large])
        }
      }
      .navigationTitle("Fruits AI")
      .toolbar {
        ToolbarItem {
          PhotosPicker(selection: $viewModel.imageSelection) {
            Text("Pick Image")
          }
        }
        ToolbarItem {
          Button("Show") {
            self.showPredictions = true
          }
        }
      }
    }
  }
}
