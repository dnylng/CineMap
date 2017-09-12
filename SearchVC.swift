//
//  SearchVC.swift
//  CineMap
//
//  Created by Danny Luong on 9/12/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import TMDBSwift

class SearchVC: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK:- IBOUTLETS
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchCollection: UICollectionView!
    
    // MARK:- VARIABLES
    
    private let cellId = "TMDBCell"
    
    private var pageNum = 1
    private var tmdbObjects: [TMDBObject] = []
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPopup()
        setupCollection()
        searchTopRated()
        
        searchField.delegate = self
    }
    
    // When the view disappears, clean the image cache
    override func viewDidDisappear(_ animated: Bool) {
        for obj in tmdbObjects {
            imageCache.removeObject(forKey: obj.imageUrl as NSString)
        }
    }
    
    // Sets the collection
    fileprivate func setupCollection() {
        searchCollection.dataSource = self
        searchCollection.delegate = self
        
        if let flowLayout = searchCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    // Sets the dimensions of the popup
    fileprivate func setupPopup() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Set the height of icon depending on the phone
        if screenWidth <= 320 {
            widthConstraint.constant = 280
            heightConstraint.constant = 448
            searchField.font = searchField.font?.withSize(14)
        } else if screenWidth >= 414 {
            widthConstraint.constant = 373
            heightConstraint.constant = 616
            searchField.font = searchField.font?.withSize(18)
        } else {
            widthConstraint.constant = 335
            heightConstraint.constant = 547
            searchField.font = searchField.font?.withSize(16)
        }
    }
    
    // MARK:- KEYBOARD FUNCTIONS
    
    // User presses return key to remove keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user touches outside of the keyboard
    @IBAction func closeKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK:- COLLECTION FUNCTIONS
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DANNY: selected a search item")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmdbObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TMDBCell
        
        // Set the TMDB id and image
        cell.id = tmdbObjects[indexPath.item].id
        downloadImage(urlString: tmdbObjects[indexPath.item].imageUrl, imageView: cell.imageView)
        cell.tmdbType = tmdbObjects[indexPath.item].tmdbType
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        let width = searchCollection.frame.width / 2
        let height = width / ratio
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item + 1 >= tmdbObjects.count {
            pageNum += 1
            searchTopRated()
        }
    }
    
    // MARK:- SEARCH FUNCTIONS
    
    // Init the search page with top rated items
    fileprivate func searchTopRated() {
        TVMDB.toprated(TMDB_API_KEY, page: pageNum, language: language) { (clientReturn, tvDB) in
            
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
                print("DANNY: from search \(tvShow.imageUrl)")
                print("DANNY: from search \(tvShow.id)")
                
                self.tmdbObjects.append(tvShow)
                self.searchCollection.reloadData()
            }
        }
    }
    
}
