//
//  NetworkManager.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

import UIKit

class NetworkManager {

    static func fetchCats(page: Int, completion: @escaping (Result<[Cat], Error>) -> Void) {
        let urlCatsJson = "https://api.thecatapi.com/v1/breeds?limit=10&page=\(page)"

        guard let url = URL(string: urlCatsJson) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print(error.localizedDescription)
                return
            }

            guard let data else { return }
            guard let result = try? JSONDecoder().decode([Cat].self, from: data) else { return }

            DispatchQueue.main.async {
                completion(.success(result))
            }

        }.resume()
    }
}
