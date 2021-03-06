//
//  PhotoDetailViewController.swift
//  Astronomy-ObjcSwift
//
//  Created by Hunter Oppel on 6/16/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takenByLabel: UILabel!
    @IBOutlet var cameraLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var photo: Photo?
    lazy var imageFetcher = ImageFetcher()
    
    lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard let photo = photo else { return }
        
        takenByLabel.text = "Taken by \(photo.rover.id) on \(dateFormatter.string(from: photo.earthDate)) (Sol \(photo.sol))"
        cameraLabel.text = "Camera: \(photo.camera)"
        
        fetchAndSetImage()
    }
    
    private func fetchAndSetImage() {
        guard let photo = photo,
            let imgURL = photo.imgURL.usingHTTPS else { return }
        
        activityIndicator.startAnimating()
        imageFetcher.fetchImage(from: imgURL) { data, error in
            if let error = error {
                NSLog("Failed to fetch image with error: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Data was nil")
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Could not convert data into image")
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
