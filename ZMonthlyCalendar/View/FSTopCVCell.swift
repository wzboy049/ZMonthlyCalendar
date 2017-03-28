//
//  FSTopCVCell.swift
//  ZBXMobile
//
//  Created by wzboy on 17/3/20.
//  Copyright © 2017年 zbx. All rights reserved.
//

import UIKit

class FSTopCVCell: UICollectionViewCell {
    
    var btn : FSMonthBtn = FSMonthBtn()
    
    var monthModel : FSCellModel? {
        didSet{
            if monthModel == nil {
                return
            }
            
            btn.setTitle("\(monthModel!.month)", for: .normal)

            switch monthModel!.status {
            case 1:
                btn.backgroundColor = UIColor.green
                btn.setTitleColor(UIColor.white, for: .normal)
                break
            case 2:
                btn.backgroundColor = UIColor.red
                btn.setTitleColor(UIColor.white, for: .normal)
                break
            default:
                btn.backgroundColor = UIColor.gray
                btn.setTitleColor(UIColor.darkGray, for: .normal)
                break
            }
            
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        fstSetupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fstSetupSubView(){
        
        btn = FSMonthBtn()
        btn.isUserInteractionEnabled = false
        contentView.addSubview(btn)
        
        btn.fill_dd(referView: contentView)
        
    }
    
}
