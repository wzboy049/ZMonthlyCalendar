//
//  UIView+AutoLayout.swift
//
//
//  Created by apple on 15/9/1.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit
/**
    对齐类型枚举，设置控件相对于父视图的位置
  - topLeft:      左上
  - topRightt:     右上
  - topcenter:    中上
  - bottomLeft:   左下
  - bottomRight:  右下
  - bottomcenter: 中下
  - centerLeft:   左中
  - centerRight:  右中
  - center: 中中
*/
public enum alignType_dd {
    case topLeft
    case topRight
    case topcenter
    case bottomLeft
    case bottomRight
    case bottomcenter
    case centerLeft
    case centerRight
    case center
    
    @discardableResult fileprivate func layoutAttributes(isInner: Bool, isVertical: Bool) -> LayoutAttributes_dd {
        let attributes = LayoutAttributes_dd()
        
        switch self {
            case .topLeft:
                _ = attributes.horizontals(from: .left, to: .left).verticals(from: .top, to: .top)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(from: .bottom, to: .top)
                } else {
                    return attributes.horizontals(from: .right, to: .left)
                }
            case .topRight:
               _ =  attributes.horizontals(from: .right, to: .right).verticals(from: .top, to: .top)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(from: .bottom, to: .top)
                } else {
                    return attributes.horizontals(from: .left, to: .right)
                }
            case .bottomLeft:
                _ = attributes.horizontals(from: .left, to: .left).verticals(from: .bottom, to: .bottom)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(from: .top, to: .bottom)
                } else {
                    return attributes.horizontals(from: .right, to: .left)
                }
            case .bottomRight:
                _ = attributes.horizontals(from: .right, to: .right).verticals(from: .bottom, to: .bottom)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(from: .top, to: .bottom)
                } else {
                    return attributes.horizontals(from: .left, to: .right)
                }
            // 仅内部 & 垂直参照需要
            case .topcenter:
                _ = attributes.horizontals(from: .centerX, to: .centerX).verticals(from: .top, to: .top)
                return isInner ? attributes : attributes.verticals(from: .bottom, to: .top)
            // 仅内部 & 垂直参照需要
            case .bottomcenter:
                _ = attributes.horizontals(from: .centerX, to: .centerX).verticals(from: .bottom, to: .bottom)
                return isInner ? attributes : attributes.verticals(from: .top, to: .bottom)
            // 仅内部 & 水平参照需要
            case .centerLeft:
               _ = attributes.horizontals(from: .left, to: .left).verticals(from: .centerY, to: .centerY)
                return isInner ? attributes : attributes.horizontals(from: .right, to: .left)
            // 仅内部 & 水平参照需要
            case .centerRight:
                _ = attributes.horizontals(from: .right, to: .right).verticals(from: .centerY, to: .centerY)
                return isInner ? attributes : attributes.horizontals(from: .left, to: .right)
            // 仅内部参照需要
            case .center:
                return LayoutAttributes_dd(horizontal: .centerX, referHorizontal: .centerX, vertical: .centerY, referVertical: .centerY)
        }
    }
}

extension UIView {
    

    /**  1
    填充子视图
    :param: referView 参考视图
    :param: insets    间距
    :returns: 约束数组
    */
    @discardableResult public func  fill_dd(referView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[subView]-\(insets.right)-|", options: .alignAllLastBaseline, metrics: nil, views: ["subView" : self])
        
        //NSLayoutFormatOptions.alignAllBaseline - > alignAllLastBaseline
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: .alignAllLastBaseline, metrics: nil, views: ["subView" : self])
        

        superview?.addConstraints(cons)
        
        return cons 
    }
    
    /** 2
    参照参考视图内部对齐
    :param: type      对齐方式
    :param: referView 参考视图
    :param: size      视图大小，如果是 nil 则不设置大小
    :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
    :returns: 约束数组
    */
    @discardableResult public func  alignInner_dd(type: alignType_dd, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint]  {
        
        return  alignLayout_dd(referView: referView, attributes: type.layoutAttributes(isInner: true, isVertical: true), size: size, offset: offset)
    }

    /**  3
    参照参考视图垂直对齐
    :param: type      对齐方式
    :param: referView 参考视图
    :param: size      视图大小，如果是 nil 则不设置大小
    :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
    :returns: 约束数组
    */
    @discardableResult public func alignVertical_dd(type: alignType_dd, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint(x: 0, y: 0) ) -> [NSLayoutConstraint] {
        
        return  alignLayout_dd(referView: referView, attributes: type.layoutAttributes(isInner: false, isVertical: true), size: size, offset: offset)
    }
    
    /**  4
    参照参考视图水平对齐
    :param: type      对齐方式
    :param: referView 参考视图
    :param: size      视图大小，如果是 nil 则不设置大小
    :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
    :returns: 约束数组
    */
    @discardableResult public func  alignHorizontal_dd(type: alignType_dd, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return  alignLayout_dd(referView: referView, attributes: type.layoutAttributes(isInner: false, isVertical: false), size: size, offset: offset)
    }


    /**  5
    在当前视图内部水平平铺控件
    :param: views  子视图数组
    :param: insets 间距
    :returns: 约束数组
    */
    @discardableResult public func  horizontalTile_dd(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "子视图数组为空!")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        _ = firstView.alignInner_dd(type: alignType_dd.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.sizeConstraints_dd(referView: firstView)
            _ = subView.alignHorizontal_dd(type: alignType_dd.topRight, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        addConstraints(cons)
        return cons
    }

    /**  6
    在当前视图内部垂直平铺控件
    :param: views  子视图数组
    :param: insets 间距
    :returns: 约束数组
    */
    @discardableResult public func  verticalTile_dd(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "子视图数组为空!")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        _ = firstView.alignInner_dd(type: alignType_dd.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.sizeConstraints_dd(referView:firstView)
            _ = subView.alignVertical_dd(type: alignType_dd.bottomLeft, referView: preView, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        
        return cons
    }
    
    /**  7
     参照参考视图 上下左右 带偏移量的布局
     :param: topReferView      顶部参考视图
     :param: topMargin         顶部相对于顶部的距离(y方向的偏移量) -_ 默认为0
     :param: leftReferView     左边参考视图
     :param: leftMargin        左边相对与作参考视图右边的距离 (x方向的偏移量) || 默认为0
     :param: bottomReferView   底部参考视图
     :param: bottomMargin      底部相对于参考视图底部的距离(y方向的偏移量) -_ 默认为0
     :param: rightReferView    右边参考视图
     :param: rightMargin       右边相对于参考视图左边部的距离(x方向的偏移量) || 默认为0
     */
    @discardableResult public func  alignRefer_dd(topReferView: UIView,topMargin: CGFloat = 0, leftReferView: UIView, leftMargin: CGFloat = 0,bottomReferView: UIView, bottomMargin: CGFloat = 0,rightReferView: UIView, rightMargin: CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false //这句一定要写,不写没效果
        
        var cons = [NSLayoutConstraint]()
       
        cons.append(NSLayoutConstraint(item: self, attribute:.top, relatedBy: NSLayoutRelation.equal, toItem: topReferView, attribute: .top, multiplier: 1.0, constant: topMargin))
        cons.append(NSLayoutConstraint(item: self, attribute:.left, relatedBy: NSLayoutRelation.equal, toItem: leftReferView, attribute: .right, multiplier: 1.0, constant: leftMargin))
        cons.append(NSLayoutConstraint(item: self, attribute:.bottom, relatedBy: NSLayoutRelation.equal, toItem: bottomReferView, attribute: .bottom, multiplier: 1.0, constant: bottomMargin))
        cons.append(NSLayoutConstraint(item: self, attribute:.right, relatedBy: NSLayoutRelation.equal, toItem: rightReferView, attribute: .left, multiplier: 1.0, constant: rightMargin))
        
        superview?.addConstraints(cons)
        
        return cons
    }
    
  //______________________
    /**
    从约束数组中查找指定 attribute 的约束
    
    :param: constraintsList 约束数组
    :param: attribute       约束属性
    
    :returns: 对应的约束
    */
    @discardableResult public func  getConstraint_dd(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    
    
    // MARK: - 私有函数
    
    /** 1
    参照参考视图对齐布局
    
    :param: referView  参考视图
    :param: attributes 参照属性
    :param: size       视图大小，如果是 nil 则不设置大小
    :param: offset     偏移量，默认是 CGPoint(x: 0, y: 0)
    
    :returns: 约束数组
    */
    @discardableResult fileprivate func  alignLayout_dd(referView: UIView, attributes: LayoutAttributes_dd, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons +=  positionConstraints_dd(referView: referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons +=  sizeConstraints_dd(size: size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons
    }
    

    /** 2
    尺寸约束数组
    :param: size 视图大小
    :returns: 约束数组
    */
    @discardableResult private func  sizeConstraints_dd(size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size .height))
        
        return cons
    }
    

    /** 2.1
    尺寸约束数组
    :param: referView 参考视图，与参考视图大小一致
    :returns: 约束数组
    */
    @discardableResult private func  sizeConstraints_dd(referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute .height, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute .height, multiplier: 1.0, constant: 0))
        
        return cons
    }
    
    /** 3
    位置约束数组
    :param: referView  参考视图
    :param: attributes 参照属性
    :param: offset     偏移量
    :returns: 约束数组
    */
   @discardableResult private func  positionConstraints_dd(referView: UIView, attributes: LayoutAttributes_dd, offset: CGPoint) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        
        return cons
    }
}

///  布局属性
private final class LayoutAttributes_dd {
    var horizontal:         NSLayoutAttribute
    var referHorizontal:    NSLayoutAttribute
    var vertical:           NSLayoutAttribute
    var referVertical:      NSLayoutAttribute
    
    init() {
        horizontal = NSLayoutAttribute.left
        referHorizontal = NSLayoutAttribute.left
        vertical = NSLayoutAttribute.top
        referVertical = NSLayoutAttribute.top
    }
    
    init(horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    fileprivate func horizontals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        
        return self
    }
    
    fileprivate func verticals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        
        return self
    }
}

// MARK: - 毛玻璃效果

extension UIView {
    
    func addDarkBlurEffect(){
        
        addBlurEffect(style: .dark)
    }
    
    func addBlurEffect(style:UIBlurEffectStyle, alpha : CGFloat = 0.5){
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style:style))
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = alpha
        
        self.addSubview(blurEffectView)
    }
    
}





