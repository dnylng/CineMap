//
//  Person.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class Person: NSObject {

    private var _name: String!
    private var _character: String!
    private var _imageUrl: String!
    
    var name: String {
        get {
            return _name
        }
        
        set {
            _name = newValue
        }
    }
    
    var character: String {
        get {
            return _character
        }
        
        set {
            _character = newValue
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
    
    init(name: String, character: String, imageUrl: String) {
        self._name = name.capitalized
        self._character = character.capitalized
        self._imageUrl = imageUrl
    }
    
}
