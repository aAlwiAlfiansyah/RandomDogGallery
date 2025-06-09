//
//  DogImageViewModelTests.swift
//  Random Dog GalleryTests
//
//  Created by Alwi Alfiansyah Ramdan on 03/06/25.
//

import XCTest
import Quick
import Nimble
@testable import Random_Dog_Gallery

struct MockDogAPIServices: DogAPIServicesProtocol {
  var mockData: [DogImage]?
  var mockError: Error?

  func fetchDogImages(count: Int) async throws -> [DogImage] {
    if let data = mockData {
      return data
    }
    
    if let error = mockError {
      throw error
    }
    
    return []
  }
}

final class DogImageViewModelTests: AsyncSpec {
  override class func spec(){
    describe("DogImageViewModel") {
      var dogAPIServices: MockDogAPIServices!
      var sut: DogImageViewModel!
      
      beforeEach {
        dogAPIServices = MockDogAPIServices()
        sut = DogImageViewModel(dogAPIServices: dogAPIServices)
      }
      
      describe("init") {
        it("should setup dogImages array") {
          expect(sut.dogImages).to(equal([]))
        }
      }
      
      describe("setupDogBreed") {
        var dogImage: DogImage!
        var imageUrl: String!
        
        it("should set dog breed") {
          imageUrl = "https://images.dog.ceo/breeds/labradoodle/labradoodle-forrest.jpg"
          dogImage = DogImage(imageUrl: imageUrl)
          
          sut.setupDogBreed(dogImage: dogImage)
          
          expect(dogImage.dogBreed).to(equal("labradoodle"))
        }
        
        it("should set not dog breed as there is no breed info") {
          imageUrl = "https://images.dog.ceo/breeds/"
          dogImage = DogImage(imageUrl: imageUrl)
          
          sut.setupDogBreed(dogImage: dogImage)
          
          expect(dogImage.dogBreed).to(equal(""))
        }
        
        it("should set not dog breed as the image url is invalid") {
          imageUrl = "https://images.dog.ceo/dogname/mamaima/labradoodle-forrest.jpg"
          dogImage = DogImage(imageUrl: imageUrl)
          
          sut.setupDogBreed(dogImage: dogImage)
          
          expect(dogImage.dogBreed).to(equal(""))
        }
      }
      
      describe("fetchInitialDogImages") {
        var dogImages: [DogImage]!
        var error: Error!
        var urlList: [String]!
        
        beforeEach {
          urlList = [
            "https://images.dog.ceo/breeds/labradoodle/labradoodle-forrest.jpg",
            "https://images.dog.ceo/breeds/briard/n02105251_8891.jpg",
            "https://images.dog.ceo/breeds/beagle/n02088364_12710.jpg"
          ]
          
          dogImages = []
          for theURL in urlList {
            dogImages.append(DogImage(imageUrl: theURL))
          }
          
          error = DogAPIServicesError.responseError
        }
        
        it("should set dogImages array") {

          dogAPIServices.mockData = dogImages
          dogAPIServices.mockError = nil
          sut.dogAPIServices = dogAPIServices

          await sut.fetchInitialDogImages()
          await expect(sut.dogImages).toEventually(equal(dogImages))
        }
        
        it("should set empty dogImages array as the fetch failed") {
          dogAPIServices.mockData = nil
          dogAPIServices.mockError = error
          sut.dogAPIServices = dogAPIServices
          
          await sut.fetchInitialDogImages()
          await expect(sut.dogImages).toEventually(equal([]))
        }
      }
      
      describe("fetchMoreDogImages") {
        var dogImages: [DogImage]!
        var newDogImages: [DogImage]!
        var error: Error!
        var urlList: [String]!
        var newUrlList: [String]!
        
        beforeEach {
          urlList = [
            "https://images.dog.ceo/breeds/labradoodle/labradoodle-forrest.jpg",
            "https://images.dog.ceo/breeds/briard/n02105251_8891.jpg",
            "https://images.dog.ceo/breeds/beagle/n02088364_12710.jpg"
          ]
          
          newUrlList = [
            "https://images.dog.ceo/breeds/setter-gordon/n02101006_3766.jpg",
            "https://images.dog.ceo/breeds/puggle/IMG_075427.jpg",
            "https://images.dog.ceo/breeds/terrier-norwich/n02094258_936.jpg"
          ]
          
          dogImages = []
          for theURL in urlList {
            dogImages.append(DogImage(imageUrl: theURL))
          }
          
          newDogImages = []
          for theURL in newUrlList {
            newDogImages.append(DogImage(imageUrl: theURL))
          }
          
          error = DogAPIServicesError.responseError
          
          sut.dogImages = dogImages
        }
        
        it("should set dogImages array") {
          dogAPIServices.mockData = newDogImages
          dogAPIServices.mockError = nil
          sut.dogAPIServices = dogAPIServices
          
          let expectedDogImages = dogImages + newDogImages

          await sut.fetchMoreDogImages()
          await expect(sut.dogImages).toEventually(equal(expectedDogImages))
        }
        
        it("should not add new dogImages array as the fetch failed") {
          dogAPIServices.mockData = nil
          dogAPIServices.mockError = error
          sut.dogAPIServices = dogAPIServices
          
          await sut.fetchMoreDogImages()
          await expect(sut.dogImages).toEventually(equal(dogImages))
        }
      }
    }
  }
}
