//
//  DogImageDetailViewModel.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 03/06/25.
//

import Foundation

class DogImageDetailViewModel: ObservableObject {
  @Published var dogImage: DogImage
  
  static let DOG_BREEDS_IMAGE_BASE_URL: String = "https://images.dog.ceo/breeds/"
  
  init(dogImage: DogImage) {
    self.dogImage = dogImage
    
    if dogImage.imageUrl.hasPrefix(DogImageDetailViewModel.DOG_BREEDS_IMAGE_BASE_URL) {
      let breedURLPath = String(dogImage.imageUrl.dropFirst(DogImageDetailViewModel.DOG_BREEDS_IMAGE_BASE_URL.count))
      let paths = breedURLPath.components(separatedBy: "/")
      
      if paths.count > 0 { self.dogImage.dogBreed = paths[0] }
      if paths.count > 1 { self.dogImage.imageName = paths[1] }
    }
  }
}
