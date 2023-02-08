//
//  Fruits+Veggies.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/7/23.
//

import Foundation

struct Fruits_Veggies {
  static let all: String = {
    guard let url = Bundle.main.url(forResource: "alphabetizer", withExtension: "txt") else { return "" }
    do {
      let string = try String(contentsOf: url, encoding: .utf8)
      return string.replacingOccurrences(of: "\n", with: " ").lowercased()
    } catch {
      fatalError("Failed to get fruits and veggies name")
    }
  }()
}

