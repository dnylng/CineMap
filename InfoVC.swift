//
//  InfoVC.swift
//  CineMap
//
//  Created by Danny Luong on 9/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import TMDBSwift

// Public variable that determines which movie/tv show was selected
var selectedCellId: Int!
var selectedCellImage: UIImage!
var selectedCellType: TMDBType!

class InfoVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var infoSummary: UITextView!
    @IBOutlet weak var castCollection: UICollectionView!
    @IBOutlet weak var topBilledCast: UILabel!
    @IBOutlet weak var currentlyWatchingBtn: UIButton!
    
    // MARK:- VARIABLES
    
    private let cellId = "CastCell"
    
    private var castArray = [Person]()
    private var tmdbObject: TMDBObject!
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopup()
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupInfo()
    }
    
    // Sets the delegates
    fileprivate func setupCollection() {
        castCollection.dataSource = self
        castCollection.delegate = self
        
        if let flowLayout = castCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
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
            infoTitle.font = infoTitle.font.withSize(14)
            infoSummary.font = infoSummary.font?.withSize(10)
            topBilledCast.font = topBilledCast.font.withSize(10)
        } else if screenWidth >= 414 {
            widthConstraint.constant = 373
            heightConstraint.constant = 616
            infoTitle.font = infoTitle.font.withSize(18)
            infoSummary.font = infoSummary.font?.withSize(14)
            topBilledCast.font = topBilledCast.font.withSize(14)
        } else {
            widthConstraint.constant = 335
            heightConstraint.constant = 547
            infoTitle.font = infoTitle.font.withSize(16)
            infoSummary.font = infoSummary.font?.withSize(12)
            topBilledCast.font = topBilledCast.font.withSize(12)
        }
    }
    
    // MARK:- INFORMATION DISPLAY
    
    // Sets the image, title, and summary
    fileprivate func setupInfo() {
        infoImage.image = selectedCellImage
        
        // Depending on TMDB data type, grab from respective TMDBSwift calls
        if selectedCellType == .tv {
            // Grab info for the title and summary
            TVMDB.tv(TMDB_API_KEY, tvShowID: selectedCellId, language: language, completion: { (clientReturn, tvShow) in
                self.infoTitle.text = tvShow?.name
                self.infoSummary.text = tvShow?.overview
                self.infoSummary.setContentOffset(CGPoint.zero, animated: true)
                
                // Create an object for this info page
                var imageUrl: String!
                guard let id = tvShow?.id else { return }
                if tvShow?.poster_path != nil {
                    imageUrl = ("\(IMAGE_URL_PREFIX)\((tvShow?.poster_path)!)")
                } else {
                    imageUrl = ""
                }
                guard let numOfEpisodes = tvShow?.number_of_episodes else { return }
                self.tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .tv, numOfEpisodes: numOfEpisodes)
            })
            
            // Grab info for the cast
            TVMDB.credits(TMDB_API_KEY, tvShowID: selectedCellId, completion: { (clientReturn, castDB) in
                
                // Grab each obj in the tv database
                for obj in (castDB?.cast)! {
                    
                    // Set up vars
                    var imageUrl: String!
                    guard let name = obj.name else { return }
                    guard let character = obj.character else { return }
                    if obj.profile_path != nil {
                        imageUrl = ("\(IMAGE_URL_PREFIX)\(obj.profile_path!)")
                    } else {
                        imageUrl = ""
                    }
                    
                    // Create a TMDBObject out of the array info
                    let person = Person(name: name, character: character, imageUrl: imageUrl)
                    print("DANNY: from cast \(person.imageUrl)")
                    print("DANNY: from cast \(person.name)")
                    print("DANNY: from cast \(person.character)")
                    
                    self.castArray.append(person)
                    print("DANNY: array count \(self.castArray.count)")
                    self.castCollection.reloadData()
                }
            })
        } else if selectedCellType == .movie {
            // Remove the currently watching btn
            currentlyWatchingBtn.removeFromSuperview()
            
            MovieMDB.movie(TMDB_API_KEY, movieID: selectedCellId, completion: { (clientReturn, movie) in
                self.infoTitle.text = movie?.title
                self.infoSummary.text = movie?.overview
                self.infoSummary.setContentOffset(CGPoint.zero, animated: false)
                
                // Create an object for this info page
                var imageUrl: String!
                guard let id = movie?.id else { return }
                if movie?.poster_path != nil {
                    imageUrl = ("\(IMAGE_URL_PREFIX)\((movie?.poster_path)!)")
                } else {
                    imageUrl = ""
                }
                self.tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .movie)
                print("DANNY: tmdbObject id \(id), imageUrl \(imageUrl)")
            })
            
            MovieMDB.credits(TMDB_API_KEY, movieID: selectedCellId, completion: { (clientReturn, castDB) in
                // Grab each obj in the tv database
                for obj in (castDB?.cast)! {
                    
                    // Set up vars
                    var imageUrl: String!
                    guard let name = obj.name else { return }
                    guard let character = obj.character else { return }
                    if obj.profile_path != nil {
                        imageUrl = ("\(IMAGE_URL_PREFIX)\(obj.profile_path!)")
                    } else {
                        imageUrl = ""
                    }
                    
                    // Create a TMDBObject out of the array info
                    let person = Person(name: name, character: character, imageUrl: imageUrl)
                    print("DANNY: from cast \(person.imageUrl)")
                    print("DANNY: from cast \(person.name)")
                    print("DANNY: from cast \(person.character)")
                    
                    self.castArray.append(person)
                    print("DANNY: array count \(self.castArray.count)")
                    self.castCollection.reloadData()
                }
            })
        }
    }
    
    // MARK:- DATABASE HANDLING FUNCTIONS
    
    @IBAction func planToWatch(_ sender: Any) {
        // Check for tv or movie
        if tmdbObject.tmdbType == .tv {
            
            // Refer to the tv plan to watch child
            let tvRef = tvPlanToWatchRef.child("\(tmdbObject.id)")
            
            // Update that child with this show
            let values = ["imageUrl": tmdbObject.imageUrl]
            tvRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
                if error != nil {
                    print("DANNY: updated completed tv \(error!)")
                    return
                }
                
                print("DANNY: Added new completed tv show")
            })
        } else {
            
            // Refer to the movie plan to watch child
            let movieRef = moviePlanToWatchRef.child("\(tmdbObject.id)")
            
            // Update that child with this movie
            let values = ["imageUrl": tmdbObject.imageUrl]
            movieRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
                if error != nil {
                    print("DANNY: updated completed movie \(error!)")
                    return
                }
                
                print("DANNY: Added new completed movie")
            })
        }
    }
    
    @IBAction func currentlyWatching(_ sender: Any) {
        // Refer to the tv currently watching child
        let tvRef = tvCurrentlyWatchingRef.child("\(tmdbObject.id)")
        
        // Update that child with this show
        let values: [String : Any] = ["imageUrl": tmdbObject.imageUrl, "numOfEpisodes": tmdbObject.numOfEpisodes, "onEpisode": tmdbObject.onEpisode]
        tvRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print("DANNY: updated completed tv \(error!)")
                return
            }
            
            print("DANNY: Added new completed tv show")
        })
    }
    
    @IBAction func completed(_ sender: Any) {
        // Check for tv or movie
        if tmdbObject.tmdbType == .tv {
            
            // Refer to the tv completed child
            let tvRef = tvCompletedRef.child("\(tmdbObject.id)")
            
            // Update that child with this show
            let values = ["imageUrl": tmdbObject.imageUrl]
            tvRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
                if error != nil {
                    print("DANNY: updated completed tv \(error!)")
                    return
                }
                
                print("DANNY: Added new completed tv show")
            })
        } else {
            
            // Refer to the movie completed child
            let movieRef = movieCompletedRef.child("\(tmdbObject.id)")
            
            // Update that child with this movie
            let values = ["imageUrl": tmdbObject.imageUrl]
            movieRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
                if error != nil {
                    print("DANNY: updated completed movie \(error!)")
                    return
                }
                
                print("DANNY: Added new completed movie")
            })
        }
    }
    
    // MARK:- COLLECTION FUNCTIONS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        let cell = castCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CastCell
        
        // Set the image, character, and name
        if castArray.count > 0 {
            cell.name.text = castArray[indexPath.item].name
            cell.character.text = castArray[indexPath.item].character
            if castArray[indexPath.item].imageUrl == "" {
                cell.imageView.image = UIImage(named: "castPlaceholder")
            } else {
                downloadImage(urlString: castArray[indexPath.item].imageUrl, imageView: cell.imageView, collectionView: collectionView)
            }
        }
        
        return cell
    }
    
    // Each cast cell has to keep the aspect ratio of 300/450
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedCellType == .tv {
            let ratio: CGFloat = 300/450
            let width = collectionView.frame.width / 4.08
            let height = width / ratio
            let size = CGSize(width: width, height: height)
            return size
        } else {
            let ratio: CGFloat = 300/450
            let width = collectionView.frame.width / 3.50
            let height = width / ratio
            let size = CGSize(width: width, height: height)
            return size
        }
    }
    
}
