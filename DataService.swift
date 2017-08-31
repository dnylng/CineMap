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
