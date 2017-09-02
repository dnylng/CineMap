//
//  CustomNaviBar.swift
//  CineMap
//
//  Created by Danny Luong on 8/31/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class CustomNaviBar: UINavigationBar {
    
    @IBOutlet weak var naviBarHeight: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // Set the background color
    func setup() {
        self.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 244/255, blue: 244/255, alpha: 0.15)
        self.tintColor = UIColor.clear
        self.isTranslucent = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let screen = UIScreen.main.bounds
        naviBarHeight.constant = screen.height / 8
        print("DANNY: Navigation bar height \(naviBarHeight.constant)")
    }

}
