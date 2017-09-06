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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DANNY: \(self.tvShows.count)")
        return tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TMDBCell
        
        // Set the TMDB id and image
        cell.id = tvShows[indexPath.item].id
        if let url = URL(string: (tvShows[indexPath.item].imageUrl)) {
            downloadImage(url: url, imageView: cell.image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        let width = ratio * CGFloat(self.frame.height)
        let size = CGSize(width: width, height: self.frame.height)
        return size
    }
    
    fileprivate func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    fileprivate func downloadImage(url: URL, imageView: UIImageView) {
        print("DANNY: Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print("DANNY: \(response?.suggestedFilename ?? url.lastPathComponent)")
            print("DANNY: Download Finished")
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
    }
    
}
