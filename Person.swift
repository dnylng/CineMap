//
//  Person.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class Person: NSObject {

    private var _firstName: String!
    private var _lastName: String!
    private var _fullName: String!
    private var _imageUrl: String!
    
    var firstName: String {
        get {
            return _firstName
        }
        
        set {
            _firstName = newValue
        }
    }
    
    var lastName: String {
        get {
            return _lastName
        }
        
        set {
            _lastName = newValue
        }
    }
    
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
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
    
}
