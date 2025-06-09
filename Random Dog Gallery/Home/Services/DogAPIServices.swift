//
//  DogAPIServices.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 14/05/25.
//

import Foundation

protocol DogAPIServicesProtocol {
  func fetchDogImages(count: Int) async throws -> [DogImage]
}

struct DogAPIServicesResponse: Decodable {
  let status: String
  let message: [String]
}

enum DogAPIServicesError: Error {
  case responseError
  case decodingError
  case unknown
}

extension DogAPIServicesError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return NSLocalizedString("Failed to convert response", comment: "Invalid response")
        case .responseError:
            return NSLocalizedString("Failed to fetch dog list", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

struct DogAPIServices: DogAPIServicesProtocol {
  static let DOG_API_LIST_URL: String = "https://dog.ceo/api/breeds/image/random/"
  
  func fetchDogImages(count: Int = 10) async throws -> [DogImage] {
    let url = URL(string: "\(DogAPIServices.DOG_API_LIST_URL)\(count)")!
    let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    var dogImages: [DogImage] = []
    
    do {
      let (data, _) = try await URLSession.shared.data(for: urlRequest)
      
      do {
        let response = try JSONDecoder().decode(DogAPIServicesResponse.self, from: data)
        
        for dogURL in response.message {
          let dogImage = DogImage(imageUrl: dogURL)
          dogImages.append(dogImage)
        }
        
        return dogImages
      } catch {
        throw DogAPIServicesError.decodingError
      }
    } catch {
      throw DogAPIServicesError.responseError
    }
  }
}
