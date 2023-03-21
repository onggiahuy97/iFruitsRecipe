//
//  ImagePicker.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/20/23.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  
  func makeUIViewController(context: Context) -> some UIImagePickerController {
    let vc = UIImagePickerController()
    vc.delegate = context.coordinator
    return vc
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(image: $image)
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var image: UIImage?
    
    init(image: Binding<UIImage?>) {
      _image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let uiImage = info[.originalImage] as? UIImage {
        self.image = uiImage
      }
    }
  }
}
