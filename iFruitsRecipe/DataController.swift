//
//  DataController.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/8/23.
//

import Foundation
import CoreData

class DataController {
  
  static let shared = DataController()
  
  var container: NSPersistentContainer
  
  init() {
    self.container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("Failed to load persistent \(error.localizedDescription)")
      }
    }
  }
}
