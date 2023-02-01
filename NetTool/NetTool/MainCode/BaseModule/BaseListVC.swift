//
//  BaseListVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/11.
//

import UIKit
import RxSwift
import RxCocoa
import JKSwiftExtension
import SwiftyJSON

class BaseListVC: BaseVC {
    var tableV_main:UITableView!
    var viewModel:HomeListModel = HomeListModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = baseBGColor
        
        initTableView()
        registData()
        setListData()
    }
    
    func setListData() -> Void {
//        listDataInsert(keyWork: "LXBlueTooth 蓝牙", content: LXBlueToothVC())
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
        tableV_main.backgroundColor = UIColor(hexString: "f3e1f1")
        tableV_main.bounces = false
        if #available(iOS 15.0, *) {
            tableV_main.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableV_main.rx.setDelegate(self).disposed(by: bag)
        // 监听cell的点击，获取那一行对应的data
        tableV_main.rx.modelSelected(itemModel.self).subscribe(onNext: { data in
            print("点击了cell，对应的data为：\(data.keyWord)")
            guard let toVC = data.content else {
                print("发生了错误")
                return
            }
            toVC.title = data.keyWord
            self.navigationController?.pushViewController(toVC, animated: true)
        }).disposed(by: bag)
    }
    
    func registData() -> Void {
        viewModel.dataPub.bind(to: tableV_main.rx.items) { tableView, indexPathRow, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellNormal")
            cell?.backgroundColor = .white
            cell?.textLabel?.textColor = UIColor.hexStringColor(hexString: "333333")
            cell?.selectionStyle = .none
            cell?.textLabel?.text = data.keyWord
            return cell!
        }.disposed(by: bag)
    }
    
    
    func listDataInsert(keyWork title: String,content vc: UIViewController) -> Void {
        viewModel.insertItem(withData: itemModel(keyWord: title, content: vc))
    }
}

extension BaseListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.randomColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.randomColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

struct itemModel {
    var keyWord:String = ""
    var content:UIViewController? = nil
}

class HomeListModel{
    private var arrayData:Array<itemModel> = []
    var dataPub:PublishSubject = PublishSubject<Array<itemModel>>()
    
    func insertItem(withData item:itemModel) -> Void {
        arrayData.append(item)
        dataPub.onNext(arrayData)
    }
    
}
