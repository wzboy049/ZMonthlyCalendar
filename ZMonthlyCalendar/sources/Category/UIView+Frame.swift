//
//  UIView+Frame.swift
//  ZMonthlyCalendar
//
//  Created by 李斌 on 17/3/28.
//  Copyright © 2017年 zbx. All rights reserved.
//

import UIKit

extension UIView{
    
    var width: CGFloat{
        set{
            var fr = self.frame
            fr.size.width = newValue
            self.frame = fr
        }
        get{
            return self.frame.size.width
        }
    }
    
    var height: CGFloat{
        set{
            var fr = self.frame
            fr.size.height = newValue
            self.frame = fr
        }
        get{
            return self.frame.size.height
        }
    }
    
    var x: CGFloat{
        set{
            var fr = self.frame
            fr.origin.x = newValue
            self.frame = fr
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat{
        set{
            var fr = self.frame
            fr.origin.y = newValue
            self.frame = fr
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var size: CGSize{
        set{
            var fr = self.frame
            fr.size = newValue
            self.frame = fr
        }
        get{
            return self.frame.size
        }
    }
    
    var centerX : CGFloat {
        set{
            var fr = self.center
            fr.x = newValue
            self.center = fr
        }
        get{
            return self.center.x
        }
    }

    var centerY : CGFloat {
        set{
            var fr = self.center
            fr.y = newValue
            self.center = fr
        }
        get{
            return self.center.y
        }
    }
}

extension CGPoint {
    
    init(_ x:CGFloat, _ y : CGFloat){
        self.init()
        
        self.x = x
        self.y = y
    }
    
    init(_ x: Int, _ y: Int) {
        self.init()
        
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }
    
    init(_ x: Double,_ y: Double){
        self.init()
        
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }
    
}

extension CGSize {
    
    init(_ width : CGFloat, _ height : CGFloat){
        self.init()
        
        self.width = width
        self.height = height
    }
    
    init(_ width : Int, _ height : Int){
        self.init()
        
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
    init(_ width : Double, _ height : Double){
        self.init()
        
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
}

extension CGRect {
    
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat){
        self.init()
        
        self.origin.x = x
        self.origin.y = y
        self.size.width = width
        self.size.height = height
    }
    
    init(_ x: Double, _ y: Double, _ width: Double, _ height: Double){
        self.init()
        
        self.origin.x = CGFloat(x)
        self.origin.y = CGFloat(y)
        self.size.width = CGFloat(width)
        self.size.height = CGFloat(height)
    }
    
    init( _ x: Int, _  y: Int, _  width: Int, _  height: Int){
        self.init()
        
        self.origin.x = CGFloat(x)
        self.origin.y = CGFloat(y)
        self.size.width = CGFloat(width)
        self.size.height = CGFloat(height)
    }
}
