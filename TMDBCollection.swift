//
//  TMDBCollection.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class TMDBCollection: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- VARIABLES
    
    var tvShows: [TMDBObject] = {
        let gameOfThrones = TMDBObject(id: "1399", imageUrl: "https://image.tmdb.org/t/p/w640/ijKEdinAQUfYNQTKfrhGnSdm5HQ.jpg")
        let breakingBad = TMDBObject(id: "1396", imageUrl: "https://image.tmdb.org/t/p/w640/1yeVJox3rjo2jBKrrihIMj7uoS9.jpg")
        let suits = TMDBObject(id: "37680", imageUrl: "https://image.tmdb.org/t/p/w640/i6Iu6pTzfL6iRWhXuYkNs8cPdJF.jpg")
        return [gameOfThrones, breakingBad, suits]
    }()
    
    let cellId = "TMDBCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataSource = self
        delegate = self
        
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TMDBCell
        
        // Set the TMDB id and image
        cell.id = tvShows[indexPath.item].id
        if let url = URL(string: tvShows[indexPath.item].imageUrl) {
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
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
    }
    
}
