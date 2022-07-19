//
//  USConfig.swift
//  RandomImage
//
//  Created by Toheed Jahan Khan on 19/07/22.
//

import Foundation

protocol APIConfigurable {
    var APIKey: String { get }
    var Host: String { get }
    var Endpoint: String { get }
}

struct USConfig: APIConfigurable {
    let APIKey = "--_C1FL317rFhufIiavmDODuYVD1AQzXj50XP6z9h20"
    let Host = "https://api.unsplash.com"
    let Endpoint = "/photos/random"
}
