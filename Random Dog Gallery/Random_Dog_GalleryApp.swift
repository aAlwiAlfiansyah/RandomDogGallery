//
//  Random_Dog_GalleryApp.swift
//  Random Dog Gallery
//
//  Created by Alwi Alfiansyah Ramdan on 14/05/25.
//

import SwiftUI
import SwiftData

@main
struct Random_Dog_GalleryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DogImage.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
          let model = DogImageViewModel(dogAPIServices: DogAPIServices())
          DogImageGridView(viewModel: model)
        }
        .modelContainer(sharedModelContainer)
    }
}
