//
//  TMDBObject.swift
//  CineMap
//
//  This object holds information for a TMDb tv show or movie.
//  When accessing the JSON files from TMDb we need an image and an id.
//  The image will be stored as a url string.
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class TMDBObject: NSObject {

    private var _id: Int!
    private var _imageUrl: String!
    
    var id: Int {
        get {
            return _id
        }
        
        set {
            _id = newValue
        }
    }
    
    var imageUrl: String {
        get {
            return _imageUrl
        }
        
        set {
            _imageUrl = newValue
        }
    }
    
    init(id: Int, imageUrl: String) {
        self._id = id
        self._imageUrl = imageUrl
    }
    
}
