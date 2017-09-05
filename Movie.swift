//
//  Movie.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class Movie: NSObject {

    private var _imageUrl: String!
    private var _title: String!
    private var _summary: String!
    private var _cast: [Person]!
    private var _status: Status!
    
    enum Status {
        case unwatched, planToWatch, currentlyWatching, completed
    }
    
    var imageUrl: String {
        get {
            return _imageUrl
        }
        
        set {
            _imageUrl = newValue
        }
    }
    
    var title: String {
        get {
            return _title
        }
        
        set {
            _title = newValue
        }
    }
    
    var summary: String {
        get {
            return _summary
        }
        
        set {
            _summary = newValue
        }
    }
    
    var cast: [Person] {
        get {
            return _cast
        }
        
        set {
            _cast = newValue
        }
    }

    var status: Status {
        get {
            return _status
        }
        
        set {
            _status = newValue
        }
    }
    
}
