//
//  IndentSignUpfields.swift
//  CineMap
//
//  Created by Danny Luong on 8/30/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class IndentSignUpfields: UITextField {

    // Create an indent to the left and slight padding on the right
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8);
    
    // Padding for the text box
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Padding for placeholder text
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Padding for the text being edited
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
