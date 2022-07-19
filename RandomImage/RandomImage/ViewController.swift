//
//  ViewController.swift
//  RandomImage
//
//  Created by Toheed Jahan Khan on 19/07/22.
//

import UIKit
import PromiseKit

enum VCError: Error {
    case cantCreateUIImage
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let controller: RandomImage = USRandomImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getRandomPhoto()
        
        //self.promiseChain()
    }
    
    private func getRandomPhoto() {
        firstly {
            self.startLoading()
        }.then { _ in
            self.controller.getRandomImage()
        }.then { (image) in
            self.controller.getPhotoData(image)
        }.then(on: DispatchQueue.global(qos: .userInitiated)) { (image, data) -> Promise<(Image, UIImage)> in
            Promise<(Image, UIImage)> { seal in
                guard let uiImage = UIImage(data: data) else {
                    seal.reject(VCError.cantCreateUIImage)
                    return
                }
                seal.fulfill((image, uiImage))
            }
        }.done { (result) in
            self.imageTitle.text = result.0.description
            self.imageView.image = result.1
        }.ensure {
            self.stopLoading()
        }.catch { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func startLoading() -> Guarantee<Bool> {
        self.activityIndicator.startAnimating()
        self.imageView.isUserInteractionEnabled = false
        return UIView.animate(.promise, duration: 0.25) {
            self.imageView.alpha = 0.5
        }
    }
    
    private func stopLoading() {
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.alpha = 1.0
        }) { (success) in
            self.imageView.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func imageTapAction(_ sender: Any) {
        self.getRandomPhoto()
    }
    
    func promiseChain() {
        firstly {
            self.fetchData()
        }.then { data in
            self.processData(data)
        }.done { (value) in
            print("did get value: \(value)")
        }.catch { (error) in
            print("got an error: \(error)")
        }
    }
    
    func fetchData() -> Promise<String> {
        return Promise { seal in
            seal.resolve(.fulfilled("did fetch data"))
        }
    }
    
    func processData(_ data: String) -> Promise<Int> {
        print("processing data: \(data)")
        return Promise { seal in
            seal.resolve(.fulfilled(42))
        }
    }
}
