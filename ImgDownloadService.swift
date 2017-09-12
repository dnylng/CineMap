//
//  ImgDownloadService.swift
//  CineMap
//
//  Created by Danny Luong on 9/10/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

// Downloads image from url string
func downloadImage(urlString: String, imageView: UIImageView) {
    guard let url = URL(string: urlString) else { return }
    
    // Clear the image for testing
    imageView.image = nil
    
    // If image is already cached, then set image and return
    if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
        imageView.image = imageFromCache
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        // Check for errors
        if error != nil {
            print("DANNY: \(error!)")
            return
        }
        
        // Guard the data
        guard let data = data else { return }
        
        print("DANNY: Download from \(urlString) finished")
        
        // Asynchronously download and set images in cache
        DispatchQueue.main.async() { () -> Void in
            let imageToCache = UIImage(data: data)
            
            // If image hasn't been cached yet, then set the image
            if imageCache.object(forKey: urlString as NSString) == nil {
                imageView.image = imageToCache
            }
            
            // Cache the image
            imageCache.setObject(imageToCache!, forKey: urlString as NSString)
        }
        }.resume()
}
