//
//  Prediction.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/6/23.
//

import Foundation

struct Prediction: Equatable, Identifiable {
  var id: String { return name.lowercased() }
  let name: String
}
