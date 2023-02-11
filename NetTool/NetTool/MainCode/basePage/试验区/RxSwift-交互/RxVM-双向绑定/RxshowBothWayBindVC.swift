//
//  RxshowBothWayBindVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/10.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - 双向绑定

class RxshowBothWayBindVC: BaseVC {
    
    @IBOutlet weak var label_show: UILabel!
    @IBOutlet weak var tf_show: UITextField!
    
    var userVM = UserViewModel()
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindFuncs()
        
    }
    
    
    func setupBindFuncs() -> Void {
        
        //将用户名与textField做双向绑定
        userVM.username.asObservable()
            .bind(to: tf_show.rx.text)
            .disposed(by: disposeBag)
        
        tf_show.rx.text.orEmpty.asObservable()
            .bind(to: userVM.username)
            .disposed(by: disposeBag)
        
        //将用户名与textField做双向绑定
//        _ =  self.tf_show.rx.textInput <->  self.userVM.username
        
        //将用户信息绑定到label上
        userVM.userinfo.bind(to: label_show.rx.text)
            .disposed(by: disposeBag)
        
    }

}


/*
 - 有时候我们需要实现双向绑定。比如将控件的某个属性值与 ViewModel 里的某个 Subject 属性进行双向绑定：
 这样当 ViewModel 里的值发生改变时，可以同步反映到控件上。
 而如果对控件值做修改，ViewModel 那边值同时也会发生变化。
 
 */

struct UserViewModel {
    //用户名
    let username = BehaviorRelay(value: "guest")
     
    //用户信息
    lazy var userinfo = {
        return self.username.asObservable()
            .map{ $0 == "lofi" ? "您是管理员" : "您是普通访客" }
            .share(replay: 1)
    }()
}
