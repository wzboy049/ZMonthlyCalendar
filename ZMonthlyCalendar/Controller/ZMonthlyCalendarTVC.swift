//
//  ZMonthlyCalendarTVC.swift
//  Pods
//
//  Created by wzboy on 17/3/28.
//
//

import UIKit

let fsvTopViewHeight : CGFloat = 44.0


class ZMonthlyCalendarTVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    var tableView = UITableView()
    
    
    lazy var yearArray : [Int] = {
        
        var arrM = [Int]()
        for year in self.currentYear - 5 ... self.currentYear + 5 {
            arrM.append(year)
        }
        return arrM
    }()
    
    
    /// 当前年
    lazy var currentYear : Int = {
        let formate = DateFormatter()
        formate.dateFormat = "yyyy"
        let currentY = Int(formate.string(from: Date()))!
        return currentY
    }()
    
    ///当前月
    lazy var currentMonth : Int = {
        
        let formate = DateFormatter()
        formate.dateFormat = "MM"
        let currentM = Int(formate.string(from: Date()))!
        return currentM
    }()
    
    
    var topScrollView = FSTopScrollView()
    
    var currentIndex : Int = 0
    
    var topViewHeight : NSLayoutConstraint?
    
    var tableViewHeight : NSLayoutConstraint?
    
    var isExpand : Bool = false{
        didSet{
            if isExpand {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.topViewHeight?.constant += fcCollectionHeight
                    self.tableViewHeight?.constant -= fcCollectionHeight
                    
                    }, completion: nil)
                
                topScrollView.showMonthView()
                
            }else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.topViewHeight?.constant -= fcCollectionHeight
                    self.tableViewHeight?.constant += fcCollectionHeight
                    
                    }, completion: nil)
                
                topScrollView.hideMonthView()
            }
        }
    }
    
    lazy var modelArray : [[FSCellModel]] = {
        var arrM = [[FSCellModel]]()
        
        for i in self.yearArray {
            
            var tmpArr = [FSCellModel]()
            for j in 1 ... 12 {
                let cellMode = FSCellModel()
                
                cellMode.year = i
                cellMode.month = j
                tmpArr.append(cellMode)
        
               ///假数据 这里应该从网络请求
                
                cellMode.fileName = "2017年利润表"
                cellMode.createTime = "2017.12.17   20:20"
                
                if j == 3 || j == 5 {
                    cellMode.fileId = nil
                }
                
                

                if j == 1 {
                    cellMode.fileUrl = "http://www.tandfonline.com/doi/pdf/10.1080/13102818.2014.923246"
                    cellMode.status = 1
                }else if j == 2 {
                    cellMode.fileUrl = "http://www.jnhrss.gov.cn/module/download/downfile.jsp?classid=0&filename=1703211613455351820.xls"
                    cellMode.status = 1
                
                }else if j == 3  {
                    cellMode.fileUrl = "http://www.jnhrss.gov.cn/module/download/downfile.jsp?classid=0&filename=1703171140259227961.doc"
                    cellMode.status = 2
                }else {
                    cellMode.status = 2
                }
                
                if j > self.currentMonth {
                    cellMode.status = 0
                }
            }
            
            arrM.append(tmpArr)
        }
        
        return arrM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fsSetupUI()
        
        fsPrepareDataSource()
        
        self.currentIndex = self.yearArray.index(of: self.currentYear)!
    }
    
    func fsSetupUI(){
        
        title = "财务报表"
        view.backgroundColor = UIColor.white
        
        fsSetupTableview()
        fsStupTopScrollView()
      
    }
    
    // MARK: - 设置 顶部滚动view
    func fsStupTopScrollView(){
        
        topScrollView = FSTopScrollView(modelArray:self.modelArray)
        topScrollView.backgroundColor = UIColor.white
        
        view.addSubview(topScrollView)
        
        weak var weakSelf = self
        
        topScrollView.yearBlock = {
            year in
            
            if weakSelf == nil {
                return
            }
            
            weakSelf?.currentIndex = weakSelf!.yearArray.index(of: year)!
            
            weakSelf?.tableView.reloadData()
            
            print("点击了年按钮 mod.year = \(year),在这里根据年刷新数据")
        }
        
        topScrollView.expandBlock = {
            
            if weakSelf == nil {
                return
            }
            
            weakSelf?.isExpand = !weakSelf!.isExpand
        }
        
        topScrollView.monthBlock = {
            i in
            //print("点击了\(i), indexPath.item")
            weakSelf?.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: true)
        }
        
        let topCons = topScrollView.alignInner_dd(type: .topLeft, referView: view, size: CGSize(kScreenWidth,fsvTopViewHeight),offset:CGPoint(0,kNaviMaxY))
        topViewHeight = topScrollView.getConstraint_dd(constraintsList: topCons, attribute: .height)
    }
    
    
    func fsSetupTableview(){
        
        
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.register(FinancialStatementsCell.self, forCellReuseIdentifier: String(describing: FinancialStatementsCell.self))
        
        let tableCons = tableView.alignInner_dd(type: .bottomLeft, referView: view, size: CGSize(kScreenWidth,kScreenHeight-fsvTopViewHeight))
        
        tableViewHeight = tableView.getConstraint_dd(constraintsList: tableCons, attribute: .height)
        
        tableView.backgroundColor = UIColor.clear
        
        //        tableView.contentSize = CGSize(kScreenWidth, 67 * CGFloat(self.modelArray.count) * 2)
        
        tableView.reloadData()
    }
    
    
}

extension ZMonthlyCalendarTVC {
    
    
    ///准备数据源
    func fsPrepareDataSource(){
        
        for year in self.yearArray {
            
            fsLoadData(byYear: year)
        }
    }
    
    
    
    func fsLoadData(byYear year : Int) {
    
        //这里根据年来请求数据
        
    }
    
}

extension ZMonthlyCalendarTVC {
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:FinancialStatementsCell.self)) as!  FinancialStatementsCell
        
        let model = modelArray[currentIndex][indexPath.row]
   
        cell.cellModel = model
        
        weak var weakSelf = self
        cell.uploadBlock = {
            weakSelf?.fsHandlerUpLoad()
        }
        
        cell.tipBlock = {
            month in
        
            weakSelf?.fsHandlerUpLoad()
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if modelArray.count > 0 {
            return modelArray[currentIndex].count
        }else{
            return 0
        }
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 67
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var urlStr = modelArray[currentIndex][indexPath.row].fileUrl
        
        
        if urlStr.hasPrefix("http://") || urlStr.hasPrefix("https://"){
            
        }else {
            urlStr = "http://" + urlStr
        }
        
        let url = URL(string: urlStr)!
   
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
        
    }
    
}

// MARK: - ultility
extension ZMonthlyCalendarTVC {
    

    // MARK: - 上传提醒
    func fsHandlerUpLoad(){
        
        print("由于ios系统权限限制，请您在安卓系统或web端上传报表")
       
    }
}



