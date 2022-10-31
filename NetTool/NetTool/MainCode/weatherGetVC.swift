//
//  weatherGetVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/9/30.
//

import UIKit
import RxSwift

class weatherGetVC: UIViewController {
    @IBOutlet weak var bton_submit:UIButton!
    @IBOutlet weak var tv_result:UITextView!
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bton_submit.jk.addActionClosure { tap, aview, num in
            self.getWeather()
        }
        // Do any additional setup after loading the view.
    }


    func getWeather() -> Void {
        weatherService().getExampleInfo(city: "0").subscribe(onSuccess: { (model) in
            print(model)
            print("cg")
        }) { (error) in
            print("err")
        }.disposed(by: disposebag)
    }

}
