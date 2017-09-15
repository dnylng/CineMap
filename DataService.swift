//
//  DataService.swift
//  CineMap
//
//  Created by Danny Luong on 8/31/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import Foundation
import Firebase

// Reference to the database
let databaseRef = Database.database().reference(fromURL: "https://cinemap-cfddd.firebaseio.com/")

// Reference to the users in the database
let usersRef = databaseRef.child("users")

// Reference to the current user in the database
let currentUserRef = usersRef.child((Auth.auth().currentUser?.uid)!)

// Reference to tv in database under earch user
let tvCurrentlyWatchingRef = currentUserRef.child("tv").child("currentlyWatching")
let tvPlanToWatchRef = currentUserRef.child("tv").child("planToWatch")
let tvCompletedRef = currentUserRef.child("tv").child("completed")

// Reference to movie in database under earch user
let moviePlanToWatchRef = currentUserRef.child("movie").child("planToWatch")
let movieCompletedRef = currentUserRef.child("movie").child("completed")

// Function that creates a user in the database
func createUserInDB(uid: String, firstName: String, lastName: String, email: String) {
    // Store these values in the database
    let values = ["firstName": firstName, "lastName": lastName, "email": email]
    
    // Create a uid under users in DB
    let newUser = usersRef.child(uid)
    
    // Update that uid with the values associated with it
    newUser.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
        if error != nil {
            print("DANNY: updated new user \(error!)")
            return
        }
        
        print("DANNY: Created new user in the DB")
    })
}

func updateCurrentlyWatchingDB(tmdbObject: TMDBObject) {
    // Refer to the tv currently watching child
    let tvRef = tvCurrentlyWatchingRef.child("\(tmdbObject.id)")
    
    // Update that child with this show
    let values: [String : Any] = ["id": tmdbObject.id, "imageUrl": tmdbObject.imageUrl, "numOfEpisodes": tmdbObject.numOfEpisodes, "onEpisode": tmdbObject.onEpisode]
    tvRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
        if error != nil {
            print("DANNY: updated completed tv \(error!)")
            return
        }
        
        print("DANNY: Added new currently watching tv show")
    })
}

func updatePlanToWatch(tmdbObject: TMDBObject) {
    // Check for tv or movie
    if tmdbObject.tmdbType == .tv {
        
        // Refer to the tv plan to watch child
        let tvRef = tvPlanToWatchRef.child("\(tmdbObject.id)")
        
        // Update that child with this show
        let values: [String : Any] = ["id": tmdbObject.id, "imageUrl": tmdbObject.imageUrl, "numOfEpisodes": tmdbObject.numOfEpisodes]
        tvRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print("DANNY: updated completed tv \(error!)")
                return
            }
            
            print("DANNY: Added new plan to watch tv show")
        })
    } else {
        
        // Refer to the movie plan to watch child
        let movieRef = moviePlanToWatchRef.child("\(tmdbObject.id)")
        
        // Update that child with this movie
        let values: [String : Any] = ["id": tmdbObject.id, "imageUrl": tmdbObject.imageUrl]
        movieRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print("DANNY: updated completed movie \(error!)")
                return
            }
            
            print("DANNY: Added new plan to watch movie")
        })
    }
}

func updateCompletedDB(tmdbObject: TMDBObject) {
    // Check for tv or movie
    if tmdbObject.tmdbType == .tv {
        
        // Refer to the tv completed child
        let tvRef = tvCompletedRef.child("\(tmdbObject.id)")
        
        // Update that child with this show
        let values: [String : Any] = ["id": tmdbObject.id, "imageUrl": tmdbObject.imageUrl]
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
        let values: [String : Any] = ["id": tmdbObject.id, "imageUrl": tmdbObject.imageUrl]
        movieRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print("DANNY: updated completed movie \(error!)")
                return
            }
            
            print("DANNY: Added new completed movie")
        })
    }
}
