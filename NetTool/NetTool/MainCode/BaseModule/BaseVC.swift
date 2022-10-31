//
//  BaseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/24.
//

import UIKit
import SnapKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        setNavigationView()
    }
    
    func setNavigationView() -> Void {
        let view = UIView()
        view.frame = CGRectMake(0, 0, 60, 44)
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.hexStringColor(hexString: "333333")
        view.addSubview(label)
        label.frame = CGRectMake(0, 0, 60, 44)
//        label.snp.makeConstraints { (make) in
//            make.margins.equalToSuperview()
//        }
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "返回"
        
        
        let setBtnItem: UIBarButtonItem = UIBarButtonItem.init(customView: view)
        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = 8
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem](arrayLiteral: negativeSpacer, setBtnItem)
        
//        let setBtnItem: UIBarButtonItem = UIBarButtonItem.init(customView: self.setBtn)
//        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = 20
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem](arrayLiteral: negativeSpacer, setBtnItem)
        
        view.jk.addActionClosure { tap, aview, num in
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
