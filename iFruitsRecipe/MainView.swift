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
    
    enum ImagePickerType: String, Identifiable {
        var id: String { self.rawValue }
        case fromLibrary, fromCamera
    }
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var ingredient: SaveIngredient = .init(name: "", show: false)
    @State private var showActionSheet = false
    @State private var imagePickerType: ImagePickerType?
    @State private var showSaveAlert = false
    
    
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
                                .bold()
                        }
                        .buttonStyle(.borderedProminent)
                        .alert("🍓 Ingredient", isPresented: $ingredient.show, presenting: ingredient) { detail in
                            TextField("Strawberry...", text: $ingredient.name)
                            Button("Cancel") {
                                ingredient.name = ""
                            }
                            Button("Save") {
                                withAnimation {
                                    ingredient.name.components(separatedBy: ",").forEach { element in
                                        let name = element.removeExtraSpace.lowercased()
                                        let prediction = Prediction(name: name)
                                        viewModel.addPrediction(prediction)
                                    }
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
                                    .bold()
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
                            showSaveAlert.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.cyan)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .alert("Saved!", isPresented: $showSaveAlert) {
                            Text("Done")
                        }
                    }
                }
                .padding()
                .animation(.default, value: viewModel.predictions.count)
            }
            //      .sheet(isPresented: $viewModel.showRecipe) {
            //        TemporaryRecipeView()
            //      }
            .navigationTitle("Fruits IA")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        viewModel.predictions = []
                        viewModel.isGenerating = false
                    }
                    .bold()
                    Picker("Type", selection: $viewModel.foodType) {
                        ForEach(ViewModel.FoodType.allCases, id: \.self) { type in
                            Text(type.name)
                                .id(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Type", selection: $viewModel.foodType) {
                        ForEach(ViewModel.FoodType.allCases, id: \.self) { type in
                            Text(type.name)
                                .id(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                ToolbarItem {
                    Button {
                        showActionSheet = true
                    } label: {
                        Label("Scan Image", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                    .confirmationDialog("Image", isPresented: $showActionSheet) {
                        Button("From Library") {
                            self.imagePickerType = .fromLibrary
                        }
                        Button("From Camera") {
                            self.imagePickerType = .fromCamera
                        }
                        
                    }
                    .sheet(item: $imagePickerType) { type in
                        switch type {
                        case .fromCamera:
                            CameraPhotoPicker(image: $viewModel.pickedImage)
                        case .fromLibrary:
                            ImagePicker(image: $viewModel.pickedImage)
                        }
                    }
                    .onChange(of: viewModel.pickedImage) { _ in
                        self.imagePickerType = nil
                    }
                }
            }
        }
    }
}


//struct TemporaryRecipeView: View {
//  @Environment(\.managedObjectContext) var viewContext
//  @EnvironmentObject var viewModel: ViewModel
//
//  let fruitName = ["carrot", "fork.knife", "cup.and.saucer", "takeoutbag.and.cup.and.straw", "wineglass"].randomElement()!
//
//  var components: [String] {
//    viewModel.recipe.components(separatedBy: "\n")
//  }
//
//  var body: some View {
//    ScrollView {
//      VStack(alignment: .leading) {
//        Color.orange
//          .frame(height: 200)
//          .overlay(alignment: .topTrailing) {
//            Image(systemName: fruitName)
//              .font(.system(size: 80))
//              .padding()
//              .padding(.top, 25)
//          }
//          .overlay(alignment: .bottomLeading) {
//            Text(viewModel.recipe.components(separatedBy: "\n").first ?? "N/A")
//              .font(.title)
//              .padding()
//          }
//          .overlay(alignment: .topLeading) {
//            Button("Save") {
//              let components = viewModel.recipe.components(separatedBy: "\n")
//              let name = components.first ?? "Untitle"
//              let content = components.dropFirst().joined(separator: "\n")
//              let recipe = Recipe(context: viewContext)
//              recipe.name = name
//              recipe.recipe = content
//              try? viewContext.save()
//            }
//          }
//          .foregroundColor(.white)
//
//        Text(viewModel.recipe.components(separatedBy: "\n").dropFirst().joined(separator: "\n"))
//          .padding()
//
//        Spacer()
//      }
//
//    }
//    .edgesIgnoringSafeArea(.top)
//
//  }
//}
