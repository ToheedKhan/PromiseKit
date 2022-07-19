//
//  USRandomImage.swift
//  RandomImage
//
//  Created by Toheed Jahan Khan on 19/07/22.
//

import Foundation
import PromiseKit

enum USError: Error {
    case CannotCreateURL
}

protocol RandomImage {
    func getRandomImage() -> Promise<Image>
    func getPhotoData(_ image: Image) -> Promise<(Image, Data)>
}

class USRandomImage: RandomImage {
    
    private let config: APIConfigurable
    private let session: URLSession
    private let queue: DispatchQueue
    private let factory: RemoteImageFactory
    
    init(withConfig config: APIConfigurable = USConfig(),
         session: URLSession = URLSession(configuration: .default),
         factory: RemoteImageFactory = USRemoteImageFactory(),
         queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated))
    {
        self.config = config
        self.session = session
        self.queue = queue
        self.factory = factory
    }
    /*
     Compact block can return an optional. If  object is nil, the block will emit an error and chain will break.
     */
    //executing ‘compactMap’ block in the background.
    func getRandomImage() -> Promise<Image> {
        
        let requestString: String = "\(config.Host)\(config.Endpoint)?client_id=\(config.APIKey)"
        
        guard let url = URL(string: requestString) else {
            return Promise(error: USError.CannotCreateURL)
        }
        
        return
        firstly {
            self.session.dataTask(.promise, with: url)
        }.compactMap(on: self.queue) { (data, response) -> [String : Any]? in
            try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        }.compactMap(on: self.queue) { (imageDict) -> Image? in
            self.factory.getImage(fromDict: imageDict)
        }
    }
    
    func getPhotoData(_ image: Image) -> Promise<(Image, Data)> {
        return
        firstly {
            self.session.dataTask(.promise, with: image.imageURL)
        }.then {(data, response) -> Promise<(Image, Data)> in
                .value((image, data))
        }
    }
}
