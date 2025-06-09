//
//  DogImage.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 14/05/25.
//

import Foundation
import SwiftData

@Model
class DogImage: Codable {
  var id: UUID
  var imageUrl: String
  var imageName: String
  var dogBreed: String
  
  enum DogImageKeys: CodingKey {
    case id, imageUrl, dogBreed, imageName
  }
  
  init(imageUrl: String) {
    self.id = UUID()
    self.imageUrl = imageUrl
    self.imageName = ""
    self.dogBreed = ""
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: DogImageKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.imageUrl, forKey: .imageUrl)
    try container.encode(self.imageName, forKey: .imageName)
    try container.encode(self.dogBreed, forKey: .dogBreed)
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: DogImageKeys.self)
    
    self.id = try values.decode(UUID.self, forKey: .id)
    self.imageUrl = try values.decode(String.self, forKey: .imageUrl)
    self.imageName = try values.decode(String.self, forKey: .imageName)
    self.dogBreed = try values.decode(String.self, forKey: .dogBreed)
  }
  
  func getURL() -> URL {
    return URL(string: self.imageUrl)!
  }
}
