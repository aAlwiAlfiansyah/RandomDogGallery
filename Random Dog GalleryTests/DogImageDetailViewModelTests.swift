//
//  DogImageDetailViewModelTests.swift
//  Random Dog GalleryTests
//
//  Created by Alwi Alfiansyah Ramdan on 03/06/25.
//

import XCTest
import Quick
import Nimble
@testable import Random_Dog_Gallery


final class DogImageDetailViewModelTests: QuickSpec {
  override class func spec(){
    describe("DogImageDetailViewModel") {
      var dogImage: DogImage!
      var sut: DogImageDetailViewModel!
      var imageUrl: String!
      
      describe("init") {
        it("should setup dogImages breed and imageName") {
          imageUrl = "https://images.dog.ceo/breeds/labradoodle/labradoodle-forrest.jpg"
          dogImage = DogImage(imageUrl: imageUrl)
          sut = DogImageDetailViewModel(dogImage: dogImage)
          
          expect(sut.dogImage.dogBreed).to(equal("labradoodle"))
          expect(sut.dogImage.imageName).to(equal("labradoodle-forrest.jpg"))
        }
        
        it("should setup dogImages breed only") {
          imageUrl = "https://images.dog.ceo/breeds/labradoodle/"
          dogImage = DogImage(imageUrl: imageUrl)
          sut = DogImageDetailViewModel(dogImage: dogImage)
          
          expect(sut.dogImage.dogBreed).to(equal("labradoodle"))
          expect(sut.dogImage.imageName).to(equal(""))
        }
        
        it("should not setup dogImages breed and imageName") {
          imageUrl = "https://images.dog.ceo/breeds/"
          dogImage = DogImage(imageUrl: imageUrl)
          sut = DogImageDetailViewModel(dogImage: dogImage)
          
          expect(sut.dogImage.dogBreed).to(equal(""))
          expect(sut.dogImage.imageName).to(equal(""))
        }
        
        it("should not setup dogImages breed and imageName as the url is invalid") {
          imageUrl = "https://images.dog.ceo/mamamia/labradoodle/labradoodle-forrest.jpg"
          dogImage = DogImage(imageUrl: imageUrl)
          sut = DogImageDetailViewModel(dogImage: dogImage)
          
          expect(sut.dogImage.dogBreed).to(equal(""))
          expect(sut.dogImage.imageName).to(equal(""))
        }
      }
    }
  }
}
