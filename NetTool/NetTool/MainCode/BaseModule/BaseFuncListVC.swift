//
//  BaseFuncListVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/11.
//

import UIKit
import RxSwift
import RxCocoa

class BaseFuncListVC: UIViewController {
    var tableV_main:UITableView!
    var viewModel:GCDListModel = GCDListModel()
    var arrayData:Array<GCDModel> = []
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = baseBGColor
        
        initTableView()
        registData()
        setListData()
        // Do any additional setup after loading the view.
    }
    
    func initTableView() -> Void {
        let mainView_Y:CGFloat = self.view.safeInsets.top + 44
        let mainView_H:CGFloat = kscreenH - mainView_Y - self.view.safeInsets.bottom
        let mainView_W:CGFloat = kscreenW
        tableV_main = UITableView.init(frame: CGRect.init(x: 0, y: mainView_Y, width: mainView_W, height:mainView_H))
        view.addSubview(tableV_main)
        setupTableView()
    }
    func setupTableView() -> Void {
        tableV_main.register(TCellNormal.self, forCellReuseIdentifier: "TCellNormal")
        tableV_main.backgroundColor = .white
        tableV_main.showsVerticalScrollIndicator = false
        tableV_main.showsHorizontalScrollIndicator = false
        tableV_main.separatorStyle = .singleLine
        tableV_main.alwaysBounceVertical = true
        tableV_main.bounces = false
        tableV_main.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableV_main.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableV_main.rx.setDelegate(self).disposed(by: bag)
        
        // 监听cell的点击，获取那一行对应的data
        tableV_main.rx.modelSelected(GCDModel.self).subscribe(onNext: {[weak self] data in
//            print("点击了cell，对应的data为：\(data.keyWord)")
            self?.callMethod(withName: data.content)
        }).disposed(by: bag)
    }
    
    func registData() -> Void {
        
//        viewModel.dataPub.subscribe{[weak self] (list:Array<GCDModel>) in
//            self?.arrayData = list
//        }.disposed(by: bag)
        
        viewModel.dataPub.bind(to: self.tableV_main.rx.items) { tableView, indexPathRow, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellNormal")
            cell?.backgroundColor = .white
            cell?.textLabel?.textColor = UIColor.hexStringColor(hexString: "333333")
            cell?.selectionStyle = .none
            cell?.textLabel?.text = data.keyWord
            return cell!
        }.disposed(by: bag)
    }
    
    // MARK: - 定义数据
    func setListData() -> Void {
//        listDataInsert(keyWork: "同步执行串行队列",
//                       content: "func_performQueuesUseSynchronization_serial")
    }
    
    func listDataInsert(keyWork title: String,content selector: String) -> Void {
        viewModel.insertItem(withData: GCDModel(keyWord: title,content: selector))
    }
    
    func callMethod(withName selectorString:String) -> Void {
        let aselector = Selector(selectorString)
//        print(aselector)
        if responds(to: aselector){
            perform(aselector)
        }else{
            assert(false,"该方法不存在,检查确认后调用")
        }
    }
}

extension BaseFuncListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
