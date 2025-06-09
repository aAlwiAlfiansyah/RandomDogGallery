//
//  DogImageViewModel.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 02/06/25.
//

import Foundation

class DogImageViewModel: ObservableObject {
  var dogAPIServices: DogAPIServicesProtocol
  @Published var dogImages: [DogImage]

  init(dogAPIServices: DogAPIServicesProtocol) {
    self.dogAPIServices = dogAPIServices
    self.dogImages = []
  }
  
  func fetchMoreDogImages() async {
    do {
      let list = try await self.dogAPIServices.fetchDogImages(count: 10)
      await MainActor.run {
        self.dogImages.append(contentsOf: list)
      }
    } catch {
      // Doing Nothing
    }
  }
  
  func fetchInitialDogImages() async {
    do {
      let list = try await self.dogAPIServices.fetchDogImages(count: 20)
      await MainActor.run {
        self.dogImages = list
      }
    } catch {
      await MainActor.run {
        self.dogImages = []
      }
    }
  }
  
  func setupDogBreed(dogImage: DogImage) {
    let dogBreedImageBaseUrl: String = "https://images.dog.ceo/breeds/"
    if dogImage.imageUrl.hasPrefix(dogBreedImageBaseUrl) {
      let breedURLPath = String(dogImage.imageUrl.dropFirst(dogBreedImageBaseUrl.count))
      let paths = breedURLPath.components(separatedBy: "/")
      
      if paths.count > 0 { dogImage.dogBreed = paths[0] }
    }
  }
  
}
