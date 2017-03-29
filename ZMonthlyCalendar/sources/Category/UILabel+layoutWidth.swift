//
//  UILabel+layoutWidth.swift
//  Swift3.0
//
//  Created by 新坐标 on 2016/12/10.
//  Copyright © 2016年 新坐标. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 便利构造函数
    /// - parameter title:          title
    /// - parameter color:          color
    /// - parameter fontSize:       fontSize
    /// - parameter layoutWidth:    布局宽度，一旦大于 0，就是多行文本
    /// - returns: UILabel
    convenience init(title: String?, color: UIColor, fontSize: CGFloat, layoutWidth: CGFloat = 0) {
        // 实例化当前对象
        self.init()
        
        // 设置对象属性
        text = title
        textColor = color
        
        font = UIFont.systemFont(ofSize: fontSize)
       // font = getUIFont_dd(fontSize)
        
        if layoutWidth > 0 {
            preferredMaxLayoutWidth = layoutWidth
            numberOfLines = 0
        }
    }
    
    convenience init(title: String?, color: UIColor, font: UIFont, layoutWidth: CGFloat = 0) {
        // 实例化当前对象
        self.init()
        
        // 设置对象属性
        text = title
        textColor = color
        
        self.font = font
        
        if layoutWidth > 0 {
            preferredMaxLayoutWidth = layoutWidth
            numberOfLines = 0
        }
    }
}



