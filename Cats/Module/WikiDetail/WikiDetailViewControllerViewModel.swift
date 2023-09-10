//
//  WikiDetailViewControllerViewModel.swift
//  Cats
//
//  Created by Artem Sulzhenko on 10.09.2023.
//

import Foundation

protocol WikiDetailViewControllerViewModelProtocol {
    var url: String { get }
    init(url: String)
}

class WikiDetailViewControllerViewModel: WikiDetailViewControllerViewModelProtocol {
    
    var url = String()

    required init(url: String) {
        self.url = url
    }
}
