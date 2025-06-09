//
//  DogImageGridItemView.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 02/06/25.
//

import SwiftUI

struct DogImageGridItemView: View {
  let size: Double
  let item: DogImage

  var body: some View {
    ZStack(alignment: .top) {
      AsyncImage(url: item.getURL()) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        ProgressView()
      }
      .frame(width: size, height: size)
      .clipShape(.rect(cornerRadius: 25))
    }
  }
}

#Preview {
  let size: Double = 100.0
  let dogImage: DogImage = DogImage(imageUrl: "https://images.dog.ceo/breeds/lhasa/n02098413_1473.jpg")
  dogImage.dogBreed = "lhasa"
  dogImage.imageName = "n02098413_1473.jpg"
  return DogImageGridItemView(size: size, item: dogImage)
}
