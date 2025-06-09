//
//  DogImageGridView.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 02/06/25.
//

import SwiftUI

enum DogImageViewStyle {
  case grid
  case list
}

struct DogImageGridView: View {
  @ObservedObject var viewModel: DogImageViewModel
  
  private static let initialColumns = 3
  private let COORDINATE_SPACE: String = "InfiniteScrollContainer"
  
  @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
  @State private var numColumns = initialColumns
  
  @State private var bottomOffset: CGFloat?
  @State private var loadMoreViewHeight: CGFloat?
  // Lock for loading to prevent multiple calls
  @State private var loading: Bool = false
  
  @State var dataID: UUID?
  @State var viewStyle: DogImageViewStyle = .grid
  
  private var columnsTitle: String {
    gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
  }
  
  var body: some View {
    NavigationStack {
      ScrollView {
        if viewStyle == .grid {
          LazyVGrid(columns: gridColumns) {
            ForEach(viewModel.dogImages) { item in
              GeometryReader { geo in
                NavigationLink(destination: DogImageDetailView(viewModel: DogImageDetailViewModel(dogImage: item))) {
                  DogImageGridItemView(size: geo.size.width, item: item)
                }
              }
              .cornerRadius(8.0)
              .aspectRatio(1, contentMode: .fit)
            }
          }
          .padding()
          .scrollTargetLayout()
          .padding(.bottom, loadMoreViewHeight)
          .background {
            GeometryReader { proxy -> Color in
              onScroll(proxy: proxy)
              return Color.clear
            }
          }
        } else {
          LazyVStack(alignment: .leading) {
            ForEach(viewModel.dogImages) { item in
              NavigationLink(destination: DogImageDetailView(viewModel: DogImageDetailViewModel(dogImage: item))) {
                DogImageListItemView(size: 100, item: item)
              }
              .cornerRadius(8.0)
              .aspectRatio(1, contentMode: .fit)
              
              Divider()
            }
          }
          .padding()
          
          .scrollTargetLayout()
          .padding(.bottom, loadMoreViewHeight)
          .background {
            GeometryReader { proxy -> Color in
              onScroll(proxy: proxy)
              return Color.clear
            }
          }
        }
        
      }
      .scrollPosition(id: $dataID)
      .coordinateSpace(name: COORDINATE_SPACE)
      .overlay(alignment: .bottom) {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .scaleEffect(1.5)
          .padding()
          .tint(.black)
          .readGeometry {
            if loadMoreViewHeight != $0.height {
              loadMoreViewHeight = $0.height
            }
          }
          .offset(y: bottomOffset ?? 1000)
      }
      .onChange(of: viewModel.dogImages.count) { oldValue, newValue in
        if newValue < oldValue {
          Task {
            await viewModel.fetchInitialDogImages()
            dataID = viewModel.dogImages.first?.id
          }
        } else if loading {
          Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000)
            loading = false
          }
        }
      }
      .toolbar {
        Button {
          Task {
            await viewModel.fetchInitialDogImages()
            dataID = viewModel.dogImages.first?.id
          }
        } label: {
          Image(systemName: "arrow.clockwise")
        }
        Button {
          dataID = viewModel.dogImages.first?.id
        } label: {
          Image(systemName: "arrow.up.to.line")
        }
        
        Button {
          changeStype()
        } label: {
          if viewStyle == .list {
            Image(systemName: "square.grid.2x2")
          } else {
            Image(systemName: "list.bullet")
          }
          
        }
      }
    }
    .onAppear {
      Task {
        await viewModel.fetchInitialDogImages()
      }
    }
    .refreshable {
      await viewModel.fetchInitialDogImages()
    }
  }
  
  private func onScroll(proxy: GeometryProxy) {
    guard let bound = proxy.bounds(of: .named(COORDINATE_SPACE)) else { return }

    let topOffset = bound.minY
    let contentHeight = proxy.frame(in: .global).height
    let bottomOffset = contentHeight - bound.maxY
    
    Task { @MainActor in
      if self.bottomOffset != bottomOffset {
        self.bottomOffset = bottomOffset
      }
      
      if loading { return }
      
      // TODO: fix hard code 0.8
      if let loadMoreViewHeight {
        if bottomOffset <= loadMoreViewHeight * 0.8 && topOffset >= 0 {
          loading = true
          await viewModel.fetchMoreDogImages()
        }
      }
    }
  }
  
  private func changeStype() {
    if viewStyle == .grid {
      viewStyle = .list
    } else {
      viewStyle = .grid
    }
  }
}

#Preview {
  let model = DogImageViewModel(dogAPIServices: DogAPIServices())
  return DogImageGridView(viewModel: model)
}
