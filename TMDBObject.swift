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

enum TMDBType {
    case tv, movie
}

class TMDBObject: NSObject {

    private var _id: Int!
    private var _title: String!
    private var _imageUrl: String!
    private var _tmdbType: TMDBType!
    
    var id: Int {
        get {
            return _id
        }
        
        set {
            _id = newValue
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
    
    var imageUrl: String {
        get {
            return _imageUrl
        }
        
        set {
            _imageUrl = newValue
        }
    }
    
    var tmdbType: TMDBType {
        get {
            return _tmdbType
        }
        
        set {
            _tmdbType = newValue
        }
    }
    
    init(id: Int, imageUrl: String, tmdbType: TMDBType) {
        self._id = id
        self._imageUrl = imageUrl
        self._tmdbType = tmdbType
    }
    
    init(id: Int, title: String, imageUrl: String, tmdbType: TMDBType) {
        self._id = id
        self._title = title
        self._imageUrl = imageUrl
        self._tmdbType = tmdbType
    }
    
}
