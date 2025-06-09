//
//  StringExtensions.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 14/05/25.
//

import Foundation

extension String {
  func deletingPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    
    return String(self.dropFirst(prefix.count))
  }
}
