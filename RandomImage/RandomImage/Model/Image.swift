//
//  Image.swift
//  RandomImage
//
//  Created by Toheed Jahan Khan on 19/07/22.
//

import Foundation

protocol Image {
    var imageID: String { get }
    var dateCreated: Date { get }
    var dateUpdated: Date { get }
    var description: String? { get }
    var likes: Int { get }
    var thumbURL: URL { get }
    var imageURL: URL { get }
    var author: Author { get }
}
