//
//  Cat.swift
//  Cats
//
//  Created by Artem Sulzhenko on 09.09.2023.
//

//import Foundation
import UIKit

struct Cat: Codable {
    let id: String
    let name: String
    let wikipediaURL: String?
    let referenceImageID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case wikipediaURL = "wikipedia_url"
        case referenceImageID = "reference_image_id"
    }
}
