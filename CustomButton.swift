//
//  CustomButton.swift
//  CineMap
//
//  Created by Danny Luong on 9/2/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.imageView?.contentMode = .scaleAspectFit
    }
    
}
