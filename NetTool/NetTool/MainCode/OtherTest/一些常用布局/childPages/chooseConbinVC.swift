//
//  chooseConbinVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit

class chooseConbinVC: UIViewController {
    @IBOutlet weak var tableMain:UITableView!
    var dataShopCart:modelShopCart? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        setUpTableView()
        initData()
        tableMain.reloadData()
    }
    
    func initData() -> Void {
        let good1 = modelGoods(des: "春有百花秋有月")
        let good2 = modelGoods(des: "夏有凉风冬有雪")
        let good3 = modelGoods(des: "若无烦事挂心头")
        let good4 = modelGoods(des: "便是人间好时节")
        
        let modelSection = modelSectionByDay()
        modelSection.dayDes = "今日"
        modelSection.isChoose = false
        modelSection.list = [good1,good2,good3,good4]
        
        let good11 = modelGoods(des: "腾讯")
        let good21 = modelGoods(des: "阿里")
        let good31 = modelGoods(des: "子节")
        let good41 = modelGoods(des: "百度")
        
        let modelSection1 = modelSectionByDay()
        modelSection1.dayDes = "昨日"
        modelSection1.isChoose = false
        modelSection1.list = [good11,good21,good31,good41]
        
        let modelCart = modelShopCart()
        modelCart.list = [modelSection,modelSection1,modelSection,modelSection1,modelSection,modelSection1]
        
        dataShopCart = modelCart
    }

}

class modelShopCart{
    var list:[modelSectionByDay]?
}

class modelSectionByDay:NSObject{
    var dayDes:String?
    @objc dynamic var isChoose:Bool = false
    var list:[modelGoods]?
}

class modelGoods:NSObject{
    var des:String?
    @objc dynamic var isChoose:Bool = false
    init(des: String? = nil, isChoose: Bool = false) {
        self.des = des
        self.isChoose = isChoose
    }
}

extension chooseConbinVC{
    func setUpTableView() -> Void {
        tableMain.delegate = self
        tableMain.dataSource = self
        tableMain.estimatedRowHeight = 200
        tableMain.backgroundColor = UIColor.clear
        tableMain.register(cell: UITableViewCell.self)
        tableMain.register(nibCell: TCellChooseCombin.self)
        tableMain.register(nibHeaderOrFooter: viewChooseHead.self)
        tableMain.showsVerticalScrollIndicator = false
        tableMain.showsHorizontalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableMain.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
}

extension chooseConbinVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataShopCart?.list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let modelbyDay = dataShopCart?.list?[section]{
            return modelbyDay.list?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TCellChooseCombin = tableView.dequeueReusable(cell: TCellChooseCombin.self, for: indexPath)
        cell.selectionStyle = .none
        if let modelbyDay = dataShopCart?.list?[indexPath.section],let list = modelbyDay.list{
//            cell.label_title.text = list[indexPath.row].des
            cell.setModel(model: list[indexPath.row])
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 自定义视图，重用方法
        guard let headerView:viewChooseHead = tableView.dequeueReusable(headerOrFooter: viewChooseHead.self) else{
            return UIView()
        }
        if let modelbyDay = dataShopCart?.list?[section]{
            headerView.setModel(model: modelbyDay)
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let modelbyDay = dataShopCart?.list?[indexPath.section],let list = modelbyDay.list{
//            cell.label_title.text = list[indexPath.row].des
//            cell.setModel(model: list[indexPath.row])
            let model = list[indexPath.row]
            model.isChoose = !model.isChoose
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        favoriteEdit.shared.addObserver(cell, forKeyPath: "isEdit", options: [.new, .old], context: nil)
//    }
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        favoriteEdit.shared.removeObserver(cell, forKeyPath: "isEdit")
//    }
}
