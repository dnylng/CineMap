//
//  TVCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/4/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class TVCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var currentlyWatchingBtn: UIButton!
    @IBOutlet weak var planToWatchBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var tvCollection: UICollectionView!

    // MARK:- VARIABLES
    
    private var statusButtons: [UIButton]!
    private var selectedStatus: Int!
    
    let cellId = "EpisodeCell"
    
    // MARK:- INITIALIZATION
    
    override func awakeFromNib() {
        setupTVCollection()
        setupStatusButtons()
    }
    
    fileprivate func setupTVCollection() {
        tvCollection.dataSource = self
        tvCollection.delegate = self
        tvCollection.allowsSelection = true
        
        if let flowLayout = tvCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    fileprivate func setupStatusButtons() {
        statusButtons = [currentlyWatchingBtn, planToWatchBtn, completedBtn]
        selectedStatus = statusButtons.index(of: currentlyWatchingBtn)
        
    }
    
    // MARK:- COLLECTION FUNCTIONS
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        let width = collectionView.frame.width / 3
        let height = width / ratio
        let size = CGSize(width: width, height: height)
        return size
    }
    
}
