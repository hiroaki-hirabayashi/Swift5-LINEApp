//
//  UIColorExtension.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/06.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return self .init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
