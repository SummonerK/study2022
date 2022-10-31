//
//  HomePageVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/24.
//


import UIKit
import RxSwift
import RxCocoa
import JKSwiftExtension
import SwiftyJSON

let gaodeKey = "8a5259c56a2d3bf889a9a099511b1a2a"

class HomePageVC: BaseVC {
    @IBOutlet weak var tableV_main:UITableView!
    var viewModel:HomeListModel = HomeListModel()
    let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let obbgColor = Observable.just(UIColor.hexStringColor(hexString: "f1f1f1"))
        obbgColor.bind(to:self.view.rx.backgroundColor).disposed(by: bag)
//        let naviC = self.navigationController
//        let willdispose = naviC?.rx.willShow
//                    .subscribe(onNext: { showEvent in
//                        let (viewController, animated) = showEvent
//                        print("页面willShow")
//                        print("\(viewController.className)")
//                        print("\(String(describing: naviC?.viewControllers.count))")
//                    }).disposed(by: bag)
        
        initTableView()
        registData()
        setLsitData()
    }
    @IBAction func gotoWeather(_ sender: Any) {
//        testNaviRx()
    }
    
    func testNaviRx() -> Void {
        let weatherVc = weatherGetVC()
        let naviC = self.navigationController
//        let willdispose = naviC?.rx.willShow
//                    .subscribe(onNext: { showEvent in
//                        let (viewController, animated) = showEvent
//                        print("页面willShow")
//                        print("\(viewController.className)")
//                        print("\(String(describing: naviC?.viewControllers.count))")
//                    })
        
        
//        let diddispose = naviC?.rx.didShow
//            .subscribe(onNext: { showEvent in
//                let (viewController, animated) = showEvent
//                print("页面didShow")
//                print("\(viewController.className)")
//                print("\(String(describing: naviC?.viewControllers.count))")
//            })
        
//        willdispose?.dispose()
        naviC?.pushViewController(weatherVc, animated: true)
    }
    
    func initTableView() -> Void {
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
            cell?.selectionStyle = .none
            cell?.textLabel?.text = data.keyWord
            return cell!
        }.disposed(by: bag)
    }
    
    func setLsitData() -> Void {
        listDataInsert(keyWork: "swift GCD|Operation", content: TestGCDVC())
        listDataInsert(keyWork: "面向协议编程", content: OOProtocolVC())
    }
    
    func listDataInsert(keyWork title: String,content vc: UIViewController) -> Void {
        viewModel.insertItem(withData: itemModel(keyWord: title, content: vc))
    }
}

extension HomePageVC:UITableViewDelegate{
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


