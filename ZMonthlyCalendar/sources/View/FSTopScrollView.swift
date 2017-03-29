//
//  FSTopScrollView.swift
//  ZBXMobile
//
//  Created by wzboy on 17/3/20.
//  Copyright © 2017年 zbx. All rights reserved.
//

import UIKit

typealias fscMonthClickBlock = (Int)->Void

typealias fscYearClickBlock = (Int)->Void

let kAnimateDuration = 0.25

let kLeftMargin : CGFloat = 13.0
let kNaviMaxY : CGFloat = 64.0
let kDefaultCellHeight : CGFloat = 44.0
let kScreenWidth : CGFloat = UIScreen.main.bounds.width
let kScreenHeight : CGFloat = UIScreen.main.bounds.height

let fcBtnWidth = kScreenWidth * 0.5

let fcCollectionHeight : CGFloat = 100
let fcCvCellHeight : CGFloat = 40


class FSTopScrollView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
   
    lazy var currentMonth : Int = {
        
        let formate = DateFormatter()
        formate.dateFormat = "MM"
        let currentM = Int(formate.string(from: Date()))!
        return currentM
    }()
    
    var yearBlock : fscYearClickBlock?
    
    var monthBlock : fscMonthClickBlock?
    
    var expandBlock : ( ()->() )?
    
    var scorllBgView : UIView?
    
    var collectionView : UICollectionView?
    
    var collectionViewHeight : NSLayoutConstraint?
    
    var clearCover : UIImageView?
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kDefaultCellHeight))
        scrollView.showsHorizontalScrollIndicator = false;
        
        scrollView.isPagingEnabled = false
        self.addSubview(scrollView)
        scrollView.alignInner_dd(type: .topLeft, referView: self, size: CGSize(kScreenWidth,fsvTopViewHeight))

        return scrollView
    }()
    
    var modelArray : [[FSCellModel]] = [[FSCellModel]](){
        didSet{
            if modelArray.count > 0 {
                fscSetupSubview()
            }
        }
    }
    
    var fscCurrentBtn : FSYearButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(modelArray:[[FSCellModel]]){
        self.init()
        
        self.modelArray = modelArray //set 里set subView //!!! convenience init 不走didSet!!!!
        
        fscSetupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fscSetupSubview(){
        if scorllBgView != nil {
            scorllBgView!.removeFromSuperview()
        }
        scorllBgView = UIView(frame: CGRect(x:0,y:0,width:kScreenWidth,height:fsvTopViewHeight))
        scrollView.addSubview(scorllBgView!)

        
        let formate = DateFormatter()
        formate.dateFormat = "yyyy"
        let currentYear = Int(formate.string(from: Date()))!
        
        
        for (i, arr) in modelArray.enumerated() {
            
            let btn = FSYearButton()
            btn.setTitle("\(arr[0].year)年", for: .normal)
            
            if arr[0].year == currentYear {
                                
                btn.isSelected = true
                fscCurrentBtn = btn
            }
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16) //dFont16
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.black, for: .selected)
            btn.setImage(UIImage(named:"financialStatements_topArror_up"), for: .selected)
            btn.setImage(UIImage(named:""), for: .normal)
            
            btn.isSelected = arr[0].year == currentYear
            btn.tag = i
            
            btn.frame = CGRect(x: CGFloat(i) * fcBtnWidth, y: 0, width: fcBtnWidth, height: fsvTopViewHeight)
            scorllBgView?.addSubview(btn)
//            btn.backgroundColor = ddRandomColor_dd()
            btn.addTarget(self, action: #selector(fscBtnClick(btn:)), for: .touchUpInside)
        }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: fcBtnWidth * 0.5, bottom: 0, right: 0)
        scorllBgView?.width = fcBtnWidth * CGFloat(modelArray.count)
        scrollView.contentSize = scorllBgView!.size
        
        scrollView.contentOffset = CGPoint(x: CGFloat(fscCurrentBtn!.tag) * fcBtnWidth - fcBtnWidth * 0.5, y: 0)
        
        fscSetupCollectionView()
        
        clearCover?.removeFromSuperview()
        clearCover = UIImageView(image: UIImage(named:"financialStatements_topSlider_hud"))
//        clearCover?.isUserInteractionEnabled = true
        clearCover!.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: fsvTopViewHeight + 1) //+1 sb
        
        addSubview(clearCover!)
        
    }
    
    func fscSetupCollectionView() {
        
        ///每行 2个cell
        let cellNumPerRow : CGFloat = 6
        let ueiCellWidth :  CGFloat  = fcCvCellHeight
        //        let ueiCellHeight : CGFloat = dheight(170)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ueiCellWidth, height: ueiCellWidth)
//        layout.scrollDirection = .vertical
        let margin = (kScreenWidth - ueiCellWidth * cellNumPerRow ) / (cellNumPerRow + 1)
        layout.sectionInset = UIEdgeInsetsMake(5, margin, 5, margin);
        
        collectionView = UICollectionView(frame: CGRect(x:0,y:fsvTopViewHeight,width:kScreenWidth,height:0), collectionViewLayout: layout)
        addSubview(collectionView!)
        
        let cCons = collectionView!.alignInner_dd(type: .topLeft, referView: self, size: CGSize(kScreenWidth,0),offset:CGPoint(0,fsvTopViewHeight))
        collectionViewHeight = collectionView!.getConstraint_dd(constraintsList: cCons, attribute: .height)
        
        collectionView?.register(FSTopCVCell.self, forCellWithReuseIdentifier: String(describing: FSTopCVCell.self))
        collectionView?.bounces = false
        collectionView?.backgroundColor = UIColor.lightGray
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
//        collectionView!.reloadData()
    }

    ///年 按钮的点击事件
    func fscBtnClick(btn:FSYearButton ){
        
        let arr = modelArray[btn.tag]
        
        if fscCurrentBtn!.isExpand {
            collectionView?.reloadData()  //刷新
        }
        
        //还是点击了当前 按钮 展开/收起collectionView
        if fscCurrentBtn == btn {
        
            let offset = CGPoint(x: fscCurrentBtn!.centerX - fcBtnWidth , y: 0)
            scrollView.setContentOffset(offset, animated: true)
            
            fscCurrentBtn!.isExpand = !(fscCurrentBtn!.isExpand)
            if expandBlock != nil {
                expandBlock!()
            }
            return
        }
        
        if yearBlock != nil {
            yearBlock!(arr[0].year)
        }
        
        if fscCurrentBtn!.isExpand {
            if expandBlock != nil {
                expandBlock!()
            }
            fscCurrentBtn!.isExpand = !fscCurrentBtn!.isExpand
        }
        
        fscCurrentBtn?.isSelected = false
        btn.isSelected = true
        fscCurrentBtn = btn

        let offset = CGPoint(x: fscCurrentBtn!.centerX - fcBtnWidth , y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }

    func showMonthView(){
        collectionViewHeight?.constant = fcCollectionHeight
        collectionView?.reloadData()
    }
    
    func hideMonthView(){
        collectionViewHeight?.constant = 0
    }
    
    
}

extension FSTopScrollView {
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FSTopCVCell.self), for: indexPath) as! FSTopCVCell
        
        let model = modelArray[fscCurrentBtn!.tag][indexPath.item]
        
        ///下面这段是假数据
        if model.month > currentMonth{
            model.fileId = nil
        }else if model.month == currentMonth {
            model.fileId = "2"
        }else {
            model.fileId = "1"
        }
        
        cell.monthModel = model
        
//        cell.btn.tag = indexPath.item
//        
//        cell.btn.addTarget(self, action: #selector(fscMonthBtnClick(btn:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 //一年12月
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if monthBlock != nil && indexPath.item + 1 <= currentMonth {
            monthBlock!(indexPath.item)
        }
    }
    
//    func fscMonthBtnClick(btn:UIButton){
//        
//
//    }
    
}


class FSMonthBtn: UIButton {
    
    var monthModle : FSCellModel?{
        didSet{
            if monthModle == nil {
                return
            }
            
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.width * 0.5
        layer.masksToBounds = true
    }
    
}

class FSYearButton : UIButton {
    
    var isExpand : Bool = false {
        didSet{
            
            if isExpand {
                
                UIView.animate(withDuration: kAnimateDuration, animations: {
                    
                    self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    }, completion: { (flag) in
//                        self.imageView?.isHidden = true
                })
                
            }else {
                UIView.animate(withDuration: kAnimateDuration, animations: { 
                        self.imageView?.transform = CGAffineTransform.identity
                    }, completion: { (flag) in
                        
                })
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        if titleLabel == nil || imageView == nil {
            return
        }
        titleLabel?.sizeToFit()
        
        if titleLabel != nil &&  !imageView!.isHidden {
            
            titleLabel?.centerX = self.width * 0.45
            titleLabel?.centerY = self.height * 0.5
            imageView!.size = CGSize(width:13 ,height:13)
            imageView!.centerY = titleLabel!.centerY
            imageView!.x = titleLabel!.frame.maxX + 5
        }else {
            titleLabel?.centerX = self.width * 0.5
            titleLabel?.centerY = self.height * 0.5
        }
    }
}



