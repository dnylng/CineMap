//
//  TVShow.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class TVShow: Movie {
    
    private var _numOfSeasons: Int!
    private var _numOfEpisodes: Int!
    private var _onSeason: Int!
    private var _onEpisode: Int!
    
    var numOfSeasons: Int {
        get {
            return _numOfSeasons
        }
        
        set {
            _numOfSeasons = newValue
        }
    }
    
    var numOfEpisodes: Int {
        get {
            return _numOfEpisodes
        }
        
        set {
            _numOfEpisodes = newValue
        }
    }
    
    var onSeason: Int {
        get {
            return _onSeason
        }
        
        set {
            _onSeason = newValue
        }
    }
    
    var onEpisode: Int {
        get {
            return _onEpisode
        }
        
        set {
            _onEpisode = newValue
        }
    }
    
    init(title: String, summary: String, cast: [Person], id: String, imageUrl: String, numOfSeasons: Int, numOfEpisodes: Int, onSeason: Int) {
        super.init(title: title, summary: summary, cast: cast, id: id, imageUrl: imageUrl)
        
        self._numOfEpisodes = numOfEpisodes
        self._numOfSeasons = numOfSeasons
        self._onSeason = onSeason
        self._onEpisode = 0
    }

}
