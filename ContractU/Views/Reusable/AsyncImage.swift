//
//  AsyncImage.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/8/2021.
//

import Combine
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    
    private let placeholder: Placeholder

    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let url: URL

    private var cancellable: AnyCancellable?
    
    init(url: URL) {
        self.url = url
    }

    deinit {
        cancel()
    }
    
    func load() {
        cancellable = APIService.shared.fetchImage(at: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
