//
//  topAreaPageVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit

let offSetTopArea:CGFloat = 100

class topAreaPageVC: UIViewController {
    @IBOutlet weak var viewContent:UIView!
    @IBOutlet weak var tableMain:UITableView!
    
    lazy var viewTopArea:UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: offSetTopArea, width: IBScreenW, height: 50)
        view.backgroundColor = UIColor.randomColor
        return view
    }()
    
    lazy var viewHead:UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: IBScreenW, height: 150)
        view.backgroundColor = UIColor.randomColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpTopArea()
    }
    
    func setUpTopArea() -> Void {
        viewContent.addSubview(viewTopArea)
        viewContent.bringSubviewToFront(viewTopArea)
    }

}

extension topAreaPageVC{
    func setUpTableView() -> Void {
        tableMain.delegate = self
        tableMain.dataSource = self
        tableMain.estimatedRowHeight = 200
        tableMain.backgroundColor = UIColor.clear
        tableMain.register(cell: UITableViewCell.self)
        tableMain.showsVerticalScrollIndicator = false
        tableMain.showsHorizontalScrollIndicator = false
//        tableMain.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 16, right: 0)
        tableMain.tableHeaderView(viewHead)
        
        if #available(iOS 15.0, *) {
            tableMain.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
}

extension topAreaPageVC:UITableViewDelegate,UITableViewDataSource{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll_Y = scrollView.contentOffset.y
        print("Y----\(scroll_Y)")
        if scroll_Y<=offSetTopArea{
            viewTopArea.jk.y = offSetTopArea-scroll_Y
        }else{
            viewTopArea.jk.y = 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusable(cell: UITableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "1、多查特价机票\n关注各个航空公司的打折信息，1块钱的机票不是梦哦～\n2、选择过夜火车\n过夜火车最大的好处是既节省了时间，又将住宿费与车费二合一啦～"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
