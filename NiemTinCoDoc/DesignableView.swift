//
//  DesignableView.swift
//  NiemTinCoDoc
//
//  Created by Nguyen Hieu Trung on 4/12/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {
    @IBInspectable var customRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = customRadius;
        }
    }
    
}
