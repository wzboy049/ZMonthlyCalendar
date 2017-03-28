//
//  FinancialStatementsCell.swift
//  ZBXMobile
//
//  Created by wzboy on 17/3/20.
//  Copyright © 2017年 zbx. All rights reserved.
//

import UIKit

class FinancialStatementsCell: UITableViewCell {
    
    var tipBlock : ( (Int)->() )?
    
    var uploadBlock : ( ()->() )?
    
    var cellModel : FSCellModel?{
        didSet{
            if cellModel == nil {
                return
            }
            
            if cellModel?.month == 1 {
                upLine.isHidden = true
            }else {
                upLine.isHidden = false
            }
            
            if cellModel?.month == 12 {
                downLine.isHidden = true
            }else {
                downLine.isHidden = false
            }
            
            if cellModel!.fileId == nil {
                titleLabel.textColor = UIColor.red
                
                tipView.isHidden = false
                timeLabel.isHidden = true
                
                let tipStr = "去上传"
                
                let attStr = NSMutableAttributedString(string: tipStr)
                attStr.addAttributes([NSUnderlineStyleAttributeName :1], range: NSRange(location: 0, length: attStr.length))
                tipView.titleLabel.attributedText = attStr
                
            }else {
                
                titleLabel.textColor = UIColor.black
                
                
                tipView.isHidden = true
                timeLabel.isHidden = false
                
                titleLabel.text = cellModel?.fileName
                timeLabel.text = cellModel?.date
                
               
            }
            
            yearLabel.text = "\(cellModel!.year)"
            dropView.titleLabel.text = "\(cellModel!.month)"
        }
    }
    
    lazy var currentYear : Int = {
        
        let formate = DateFormatter()
        formate.dateFormat = "yyyy"
        let currentY = Int(formate.string(from: Date()))!
        return currentY
    }()
    
    lazy var upLine : UIImageView = {
        let img = UIImageView(image:UIImage(named:"financialStatements_cell_verLine_up"))
        return img
    }()
    
    lazy var downLine : UIImageView = {
        let img = UIImageView(image:UIImage(named:"financialStatements_cell_verLine_down"))
        return img
    }()
    
    lazy var dropView : FSDropView = {
        
        let img = FSDropView()
        return img
    }()
    
    lazy var yearLabel : UILabel = {
        
        let lbl = UILabel(title: "2017", color: UIColor.lightGray, fontSize: 12)
        return lbl
    }()
    
    lazy var titleLabel : UILabel = {
        let lbl = UILabel(title: "2017年利润表", color: UIColor.black, fontSize: 14)
        return lbl
    }()
    
    lazy var timeLabel : UILabel = {
        let lbl = UILabel(title: "2017.02.11  14:30", color: UIColor.lightGray, fontSize: 12)
        return lbl
    }()

    lazy var tipView : FSTipView = {
        
        let btn = FSTipView()
        return btn
    }()
    
    lazy var uploadBtn : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("上传", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fscSetupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func fscSetupSubview(){
        
        contentView.addSubview(upLine)
        upLine.alignInner_dd(type: .topLeft, referView: contentView, size:CGSize(1,14.5),offset:CGPoint(25,0))
        
        contentView.addSubview(dropView)
        dropView.alignVertical_dd(type: .bottomcenter, referView: upLine, size: CGSize(24,28))
        
        contentView.addSubview(yearLabel)
        yearLabel.alignVertical_dd(type: .bottomcenter, referView: dropView, size: nil)
        
        contentView.addSubview(downLine)
//        downLine.backgroundColor = UIColor.red
        downLine.alignVertical_dd(type: .bottomcenter, referView: yearLabel, size: CGSize(1,13)) //
        
        contentView.addSubview(titleLabel)
        titleLabel.alignInner_dd(type: .topLeft, referView: contentView, size: nil, offset: CGPoint(49,40))
        
        contentView.addSubview(tipView)
        tipView.alignHorizontal_dd(type: .centerRight, referView: titleLabel, size: CGSize(65,20))
        
        contentView.addSubview(uploadBtn)
        uploadBtn.setTitle("上传", for: .normal)
        uploadBtn.setTitleColor(UIColor.blue, for: .normal)
        uploadBtn.addTarget(self, action: #selector(fsUploadBtnClick), for: .touchUpInside)
        uploadBtn.alignInner_dd(type: .topRight, referView: contentView, size: nil, offset: CGPoint(x: -kLeftMargin, y: kLeftMargin))
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(fsHandlerTip))
        tipView.addGestureRecognizer(ges)
        tipView.isHidden = true
        
        contentView.addSubview(timeLabel)
        timeLabel.alignInner_dd(type: .bottomRight, referView: contentView, size: nil, offset: CGPoint(-kLeftMargin,-10))
        
        let line = UIView()
        line.backgroundColor = UIColor.gray
        contentView.addSubview(line)
        line.alignInner_dd(type: .bottomLeft, referView: contentView, size: CGSize(kScreenWidth,1), offset: CGPoint(49,0))
    }
    
    func fsUploadBtnClick(){
        
        print("上传按钮的点击事件")
        
        if uploadBlock != nil {
            uploadBlock!()
        }
        
    }
    
    func fsHandlerTip(){
        if tipBlock != nil && cellModel != nil {
            tipBlock!(cellModel!.month)
        }
    }

}


///水滴形状的图片 + 文字
class FSDropView : UIView{
    
    lazy var titleLabel : UILabel = {
        
        let lbl = UILabel(title: "01", color: UIColor.white, fontSize: 16)
        return lbl
    }()
    
    lazy var imageView : UIImageView = {
        
        let img = UIImageView()
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fsdSeupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fsdSeupSubView(){
        
        addSubview(imageView)
        imageView.image = UIImage(named:"financialStatements_cell_drop")
        imageView.fill_dd(referView: self)
        
        imageView.addSubview(titleLabel)
        titleLabel.alignInner_dd(type: .topcenter, referView: imageView, size: nil, offset: CGPoint(0,5))
    
    }
    
}

class FSTipView : UIView {
    
    lazy var titleLabel : UILabel = {
        let lbl = UILabel(title: "去提醒", color: UIColor.red, fontSize: 14)
        return lbl
    }()
    
    lazy var imageView : UIImageView = {
        
        let img = UIImageView(image:UIImage(named: "financialStatements_cell_tip"))
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fstbSetupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fstbSetupSubview(){
    
        addSubview(titleLabel)
        
        titleLabel.alignInner_dd(type: .centerLeft, referView: self, size: nil)
    
        
        addSubview(imageView)
        imageView.image = UIImage(named: "financialStatements_cell_tip")
        imageView.alignHorizontal_dd(type: .centerRight, referView: titleLabel, size: nil)
        
    }
    
}


