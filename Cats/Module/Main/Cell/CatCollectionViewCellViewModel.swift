//
//  CatCollectionViewCellViewModel.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

import Foundation

protocol CatCollectionViewCellViewModelProtocol {
    var catName: String { get }
    var urlCoverImage: String { get }
    init(cat: Cat)
}

class CatCollectionViewCellViewModel: CatCollectionViewCellViewModelProtocol {
    
    var catName: String {
        return cat.name
    }

    var urlCoverImage: String {
        return "https://cdn2.thecatapi.com/images/\(cat.referenceImageID ?? "").jpg"
    }

    private let cat: Cat

    required init(cat: Cat) {
        self.cat = cat
    }
}
