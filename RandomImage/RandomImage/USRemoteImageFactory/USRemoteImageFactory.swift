//
//  USRemoteImageFactory.swift
//  RandomImage
//
//  Created by Toheed Jahan Khan on 19/07/22.
//

import Foundation

protocol RemoteImageFactory {
    func getImage(fromDict dict: [String : Any]) -> Image?
}

class USRemoteImageFactory: RemoteImageFactory {
    
    private enum JSONKey: String {
        case results
    }
    
    private enum ImageKey: String {
        case id
        case created_at
        case updated_at
        case description
        case likes
        case urls
        case full
        case thumb
        case user
    }
    
    private enum AuthorKey: String {
        case id
        case name
        case first_name
        case last_name
    }
    
    private static let dateFormatter = DateFormatter()
    init(_ dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ") {
        USRemoteImageFactory.dateFormatter.dateFormat = dateFormat
    }
    
    func getImage(fromDict dict: [String : Any]) -> Image? {
        guard
            let id = dict[ImageKey.id.rawValue] as? String,
            let dateCreatedString = dict[ImageKey.created_at.rawValue] as? String,
            let dateCreated = self.getDate(dateCreatedString),
            let dateUpdatedString = dict[ImageKey.updated_at.rawValue] as? String,
            let dateUpdated = self.getDate(dateUpdatedString),
            let likes = dict[ImageKey.likes.rawValue] as? Int,
            let urlsDict = dict[ImageKey.urls.rawValue] as? [String : Any],
            let fullURLString = urlsDict[ImageKey.full.rawValue] as? String,
            let fullURL = URL(string: fullURLString),
            let thumbURLString = urlsDict[ImageKey.thumb.rawValue] as? String,
            let thumbURL = URL(string: thumbURLString),
            let userDict = dict[ImageKey.user.rawValue] as? [String : Any],
            let author = self.getAuthor(userDict)
        else {
            return nil
        }
        
        return USImage(imageID: id,
                       dateCreated: dateCreated,
                       dateUpdated: dateUpdated,
                       description: dict[ImageKey.description.rawValue] as? String,
                       likes: likes,
                       thumbURL: thumbURL,
                       imageURL: fullURL,
                       author: author)
    }
    
    private func getDate(_ dateString: String) -> Date? {
        return USRemoteImageFactory.dateFormatter.date(from: dateString)
    }
    
    private func getAuthor(_ dict: [String : Any]) -> Author? {
        guard let id = dict[AuthorKey.id.rawValue] as? String else {
            return nil
        }
        return USAuthor(authorID: id,
                        firstName: dict[AuthorKey.first_name.rawValue] as? String,
                        lastName: dict[AuthorKey.last_name.rawValue] as? String,
                        fullName: dict[AuthorKey.name.rawValue] as? String)
    }
}

fileprivate struct USAuthor: Author {
    let authorID: String
    let firstName: String?
    let lastName: String?
    let fullName: String?
}

fileprivate struct USImage: Image {
    let imageID: String
    let dateCreated: Date
    let dateUpdated: Date
    let description: String?
    let likes: Int
    let thumbURL: URL
    let imageURL: URL
    let author: Author
}
