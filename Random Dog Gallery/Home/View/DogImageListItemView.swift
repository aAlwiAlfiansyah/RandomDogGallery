//
//  DogImageListItemView.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 03/06/25.
//

import SwiftUI

struct DogImageListItemView: View {
  let size: Double
  let item: DogImage
  
  var body: some View {
    HStack {
      AsyncImage(url: item.getURL()) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        ProgressView()
      }
      .frame(width: size, height: size)
      .clipShape(.rect(cornerRadius: 25))
      
      Text(item.dogBreed)
        .font(.title)
        .padding()
        .foregroundStyle(.black)
        .multilineTextAlignment(.leading)
        .lineLimit(2)
        .allowsTightening(true)
        .minimumScaleFactor(0.5)
    }
    .padding()
  }
}

#Preview {
  let size: Double = 100.0
  let dogImage: DogImage = DogImage(imageUrl: "https://images.dog.ceo/breeds/lhasa/n02098413_1473.jpg")
  dogImage.dogBreed = "lhasa"
  dogImage.imageName = "n02098413_1473.jpg"
  
  return DogImageListItemView(size: size, item: dogImage)
}
