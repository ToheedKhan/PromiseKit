//
//  Author.swift
//  RandomImage
//
//  Created by Toheed Jahan Khan on 19/07/22.
//

import Foundation

protocol Author {
    var authorID: String { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var fullName: String? { get }
}
