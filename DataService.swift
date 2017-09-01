//
//  DataService.swift
//  CineMap
//
//  Created by Danny Luong on 8/31/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import Foundation
import Firebase

let databaseRef = Database.database().reference(fromURL: "https://cinemap-cfddd.firebaseio.com/")
let usersRef = databaseRef.child("users")

func createUserInDB(uid: String, firstName: String, lastName: String, email: String) {
    // Store these values in the database
    let values = ["firstName": firstName, "lastName": lastName, "email": email]
    
    // Create a uid under users in DB
    let newUser = usersRef.child(uid)
    
    // Update that uid with the values associated with it
    newUser.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
        if error != nil {
            print("DANNY: \(error!)")
            return
        }
        
        print("DANNY: Created new user in the DB")
    })
}
