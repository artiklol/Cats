//
//  CoverImageView.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

import UIKit

class CoverImageView: UIImageView {

    func fetchImage(with url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }

        if let cachedImage = getCachedImage(url: imageUrl) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            if let error { print(error); return }
            guard let data, let response else { return }
            guard let responseURL = response.url else { return }

            if responseURL.absoluteString != url { return }

            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
            self?.saveImageToCache(data: data, response: response)
        }.resume()
    }

    private func saveImageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cashedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cashedResponse, for: URLRequest(url: responseURL))
    }

    func getCachedImage(url: URL) -> UIImage? {
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cacheResponse.data)
        }
        return nil
    }
}
