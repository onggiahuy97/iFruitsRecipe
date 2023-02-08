//
//  String+Extension.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/8/23.
//

import Foundation

extension String {
  var removeExtraSpace: String {
    let components = self.components(separatedBy: .whitespacesAndNewlines)
    return components.filter { !$0.isEmpty }.joined(separator: " ")
  }
}
