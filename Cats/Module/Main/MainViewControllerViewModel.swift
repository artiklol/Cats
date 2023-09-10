//
//  MainViewControllerViewModel.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

import Foundation

protocol MainViewControllerViewModelProtocol {
    var cats: [Cat] { get }
    func fetchCats(page: Int, completion: @escaping() -> Void)
    func fetchNumberPageCats(page: Int, completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func cellViewModel(at indexPath: IndexPath) -> CatCollectionViewCellViewModelProtocol
    func selectedCell(for indexPath: IndexPath)
    func viewModelForSelectedCell() -> WikiDetailViewControllerViewModelProtocol?
}

class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    var cats = [Cat]()
    private var indexPath: IndexPath?

    func numberOfItems() -> Int {
        cats.count
    }

    func cellViewModel(at indexPath: IndexPath) -> CatCollectionViewCellViewModelProtocol {
        let cat = cats[indexPath.row]
        return CatCollectionViewCellViewModel(cat: cat)
    }

    func fetchCats(page: Int, completion: @escaping () -> Void) {
        NetworkManager.fetchCats(page: page) { [weak self] result in
            switch result {
            case .success(let result):
                self?.cats = result
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

    func fetchNumberPageCats(page: Int, completion: @escaping () -> Void) {
        NetworkManager.fetchCats(page: page) { [weak self] result in
            switch result {
            case .success(let result):
                self?.cats += result
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }

    func selectedCell(for indexPath: IndexPath) {
        self.indexPath = indexPath
    }

    func viewModelForSelectedCell() -> WikiDetailViewControllerViewModelProtocol? {
        guard let indexPath else { return nil }
        let url = cats[indexPath.row].wikipediaURL ?? ""
        return WikiDetailViewControllerViewModel(url: url)
    }
}
