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
        VStack(alignment: .leading) {
          FlowLayout(alignment: .leading, spacing: 10) {
            ForEach(viewModel.predictions) { prediction in
              FruitCell(prediction: prediction)
            }
          }
          
          if !viewModel.predictions.isEmpty {
            NavigationLink {
              Text(viewModel.recipe)
                .onAppear {
                  Task {
                    await viewModel.generateRecipe()
                  }
                }
            } label: {
              Text("Generate")
            }

          } else {
            VStack {
              Spacer()
              VStack(spacing: 12) {
                Image(systemName: "rectangle.and.text.magnifyingglass")
                  .font(.system(size: 34))
                Text("Scan Image To Get Ingredients")
                  .bold()
              }
              Spacer()
            }
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
        ToolbarItem(placement: .navigationBarLeading) {
          TextField("Add Fruit", text: $text)
            .textFieldStyle(.roundedBorder)
            .onSubmit {
              viewModel.predictions.append(Prediction(name: text))
              self.text = ""
            }
        }
      }
    }
  }
}
