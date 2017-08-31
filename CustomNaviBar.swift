//
//  CustomNaviBar.swift
//  CineMap
//
//  Created by Danny Luong on 8/31/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class CustomNaviBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
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
        self.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height / 8)
        
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }

}
