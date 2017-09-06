//
//  TMDBCollection.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import TMDBSwift

class TMDBCollection: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- VARIABLES
    
    var tvShows: [TMDBObject] = []
    
    let cellId = "TMDBCell"
    
    override func awakeFromNib() {
        collectionViewSetup()
        tvCollectionSetup()
    }
    
    fileprivate func collectionViewSetup() {
        dataSource = self
        delegate = self
        
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    fileprivate func tvCollectionSetup() {
        TVMDB.popular(TMDB_API_KEY, page: 1, language: "en") { (clientReturn, apiReturn) in
            let tv = apiReturn
            
            for obj in tv! {
                var imageUrl: String!
                guard let id = obj.id else { return }
                if obj.poster_path != nil {
                    imageUrl = ("\(IMAGE_URL_PREFIX_S)\(obj.poster_path!)")
                } else {
                    imageUrl = ""
                }
                
                let tvShow = TMDBObject(id: id, imageUrl: imageUrl)
                print("DANNY: \(tvShow.imageUrl)")
                print("DANNY: \(tvShow.id)")
                
                self.tvShows.append(tvShow)
                self.reloadData()
            }
        }
    }
    
    // Returns the size of the tvShows, movies, discoveries array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DANNY: \(self.tvShows.count)")
        return tvShows.count
    }
    
    // Sets the id and image for the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TMDBCell
        
        // Set the TMDB id and image
        cell.id = tvShows[indexPath.item].id
        downloadImage(urlString: tvShows[indexPath.item].imageUrl, imageView: cell.image)
        
        return cell
    }
    
    // Each tv show/movie cell has to keep the aspect ratio of 185/278
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        let width = ratio * CGFloat(self.frame.height)
        let size = CGSize(width: width, height: self.frame.height)
        return size
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    // Downloads image from url string
    fileprivate func downloadImage(urlString: String, imageView: UIImageView) {
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
                if self.imageCache.object(forKey: urlString as NSString) == nil {
                    imageView.image = imageToCache
                }
                
                // Cache the image
                self.imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
        }.resume()
    }
}
