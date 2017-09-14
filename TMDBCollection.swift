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
    
    var tmdbObjects: [TMDBObject] = []
    
    let cellId = "TMDBCell"
    
    enum Collection {
        case tv, movie, airing
    }
    
    // MARK:- INITIALIZATION
    override func awakeFromNib() {
        collectionViewSetup()
    }
    
    // Sets datasource and delegate for the collection view
    fileprivate func collectionViewSetup() {
        dataSource = self
        delegate = self
        
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
        
        reloadData()
    }
    
    // Setup array depending on type of collection tv, movie, or discover
    func collectionArraySetup(collection: Collection) {
        if collection == Collection.tv {
            TVMDB.popular(TMDB_API_KEY, page: 1, language: language) { (clientReturn, tvDB) in
                
                // Grab each obj in the tv database
                for obj in tvDB! {
                    
                    // Set up vars
                    var imageUrl: String!
                    guard let id = obj.id else { return }
                    if obj.poster_path != nil {
                        imageUrl = ("\(IMAGE_URL_PREFIX)\(obj.poster_path!)")
                    } else {
                        imageUrl = ""
                    }
                    
                    // Create a TMDBObject out of the array info
                    let tvShow = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .tv)
                    print("DANNY: from tv \(tvShow.imageUrl)")
                    print("DANNY: from tv \(tvShow.id)")
                    
                    self.tmdbObjects.append(tvShow)
                    self.reloadData()
                }
            }
        } else if collection == Collection.movie {
            MovieMDB.popular(TMDB_API_KEY, language: language, page: 1, completion: { (clientReturn, movieDB) in
                
                // Grab each obj in the movie database
                for obj in movieDB! {
                    
                    // Set up vars
                    var imageUrl: String!
                    guard let id = obj.id else { return }
                    if obj.poster_path != nil {
                        imageUrl = ("\(IMAGE_URL_PREFIX)\(obj.poster_path!)")
                    } else {
                        imageUrl = ""
                    }
                    
                    // Create a TMDBObject out of the array info
                    let movie = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .movie)
                    print("DANNY: from movie \(movie.imageUrl)")
                    print("DANNY: from movie \(movie.id)")
                    
                    self.tmdbObjects.append(movie)
                    self.reloadData()
                }
            })
        } else if collection == Collection.airing {
            TVMDB.ontheair(TMDB_API_KEY, page: 1, language: language, completion: { (clientReturn, tvDB) in
                
                // Grab each obj in the tv database
                for obj in tvDB! {
                    
                    // Set up vars
                    var imageUrl: String!
                    guard let id = obj.id else { return }
                    if obj.poster_path != nil {
                        imageUrl = ("\(IMAGE_URL_PREFIX)\(obj.poster_path!)")
                    } else {
                        imageUrl = ""
                    }
                    
                    // Create a TMDBObject out of the array info
                    let tvShow = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .tv)
                    print("DANNY: from airing \(tvShow.imageUrl)")
                    print("DANNY: from airing \(tvShow.id)")
                    
                    self.tmdbObjects.append(tvShow)
                    self.reloadData()
                }
            })
        }
    }

    // Returns the size of the tvShows, movies, discoveries array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmdbObjects.count
    }
    
    // Sets the id and image for the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TMDBCell
        
        // Set the TMDB id and image
        cell.id = tmdbObjects[indexPath.item].id
        downloadImage(urlString: tmdbObjects[indexPath.item].imageUrl, imageView: cell.imageView, collectionView: collectionView)
        cell.tmdbType = tmdbObjects[indexPath.item].tmdbType
        
        return cell
    }
    
    // Each tv show/movie cell has to keep the aspect ratio of 185/278
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        let width = ratio * CGFloat(self.frame.height)
        let size = CGSize(width: width, height: self.frame.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as! TMDBCell
        selectedCellId = cell.id
        selectedCellImage = cell.imageView.image
        selectedCellType = cell.tmdbType
        print("DANNY: cell id \(cell.id!)")
    }
    
}
