//
//  ViewModel.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/6/23.
//

import SwiftUI
import PhotosUI
import CoreTransferable
import ChatGPTKit

@MainActor
class ViewModel: ObservableObject {
  
  let imagePredictor = ImagePredictor()
  
  private let chatGPTKit = ChatGPTKit(apiKey: "")
  
  private let names = Fruits_Veggies.all
  
  @Published var imageSelection: PhotosPickerItem? = nil {
    didSet {
      if let imageSelection {
        let progress = loadTransferable(form: imageSelection)
        imageState = .loading(progress)
      } else {
        imageState = .empty
      }
    }
  }
  
  @Published private(set) var imageState: ImageState = .empty {
    didSet {
      self.classifyImage()
    }
  }
  @Published private(set) var isGenerating = false
  @Published private(set) var recipe: String = ""
  @Published var predictions: [Prediction] = [] {
    didSet {
      self.recipe = ""
    }
  }
  @Published var pickedImage: UIImage? {
    didSet { self.classifyImage() }
  }
  
  enum ImageState {
    case empty
    case loading(Progress)
    case success(UIImage)
    case failure(Error)
    
    var uiImage: UIImage? {
      switch self {
      case .success(let uiImage):
        return uiImage
      default:
        return nil
      }
    }
  }
  
  struct ClassifyImage: Transferable {
    let uiImage: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in
        guard let uiImage = UIImage(data: data) else {
          fatalError("Failed to get image from data")
        }
        return ClassifyImage(uiImage: uiImage)
      }
    }
  }
  
  func addPrediction(_ prediction: Prediction) {
    guard !predictions.contains(prediction) else { return }
    predictions.append(prediction)
  }
  
  func generateRecipe() async {
    DispatchQueue.main.async {
      self.isGenerating = true
    }
    
    let ingredients = predictions.reduce(into: "") { partialResult, prediction in
      partialResult += prediction.name + ", "
    }
    
    let prompt = "Give me a recipe with these ingredients: \(ingredients)"
    
    do {
      let result = try await chatGPTKit.performCompletions(systemMessage: .init(role: .user, content: prompt))
      DispatchQueue.main.async {
        switch result {
        case .failure(let error):
          self.isGenerating = false
          self.recipe = error.message
        case .success(let res):
          let text = res.choices?.first?.message.content
          self.isGenerating = false
          self.recipe = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "None"
        }
      }
    } catch {
      print("Error \(error.localizedDescription)")
    }
  }
  
  func classifyImage() {
//    guard let uiImage = imageState.uiImage else {
//      return
//    }
    guard let uiImage = pickedImage else { return }
    do {
      try self.imagePredictor.makePredictions(for: uiImage, completionHandler: imagePredictionHandler)
    } catch {
      print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
    }
  }
  
  private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
    guard let predictions = predictions else {
      print("No predictions")
      return
    }
    
    let filteredPredictions = predictions
      .filter { imagePrediction in
        let double = Double(imagePrediction.confidencePercentage) ?? 0.0
        let checkIfFruitsOrVeggies = names.contains(imagePrediction.classification)
        let prediction = Prediction(name: imagePrediction.classification)
        let checkIfExisting = self.predictions.contains(prediction)
        return double > 0.9 && checkIfFruitsOrVeggies && !checkIfExisting
      }
    
    let result = filteredPredictions.reduce(into: [Prediction]()) { next, imagePrediction  in
      next += imagePrediction.classification.split(separator: ", ").map { str in
        return Prediction(name: String(str))
      }
    }
    
    DispatchQueue.main.async {
      self.predictions += result
    }
  }
  
  private func loadTransferable(form imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: ClassifyImage.self) { result in
      DispatchQueue.main.async {
        guard imageSelection == self.imageSelection else {
          print("Failed to get the selected image")
          return
        }
        switch result {
        case .success(let classifyImage?):
          self.imageState = .success(classifyImage.uiImage)
        case .success(nil):
          self.imageState = .empty
        case .failure(let error):
          self.imageState = .failure(error)
        }
      }
    }
  }
}
