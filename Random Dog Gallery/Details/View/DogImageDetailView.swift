//
//  DogImageDetailView.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 03/06/25.
//

import SwiftUI

struct DogImageDetailView: View {
  @ObservedObject var viewModel: DogImageDetailViewModel
  
  var body: some View {
    
    NavigationStack {
      ScrollView {
        VStack {
          AsyncImage(url: viewModel.dogImage.getURL()) { image in
            image
              .resizable()
              .scaledToFill()
          } placeholder: {
            ProgressView()
          }
          .frame(width: 200, height: 200)
          .clipShape(.rect(cornerRadius: 25))
          
          Text(viewModel.dogImage.imageName)
            .italic()
            .fontWeight(.light)
          
          Text(viewModel.dogImage.dogBreed)
            .font(.title)
            .bold()
            .padding()
            .foregroundStyle(.blue)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .allowsTightening(true)
            .minimumScaleFactor(0.5)
        }
        .padding(.vertical, 50)
      }
    }
  }
}

#Preview {
  let dogImage = DogImage(imageUrl: "https://images.dog.ceo/breeds/vizsla/n02100583_13353.jpg")
  dogImage.dogBreed = "vizsla"
  dogImage.imageName = "n02100583_13353.jpg"
  let model = DogImageDetailViewModel(dogImage: dogImage)
  return DogImageDetailView(viewModel: model)
}
