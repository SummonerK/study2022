//
//  RxShowUIActivityIndicatorViewVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/10.
//

import UIKit
import RxCocoa
import RxSwift

class RxShowUIActivityIndicatorViewVC: BaseVC {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var switch_show: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindFuncs()

        // Do any additional setup after loading the view.
    }
    
    func setupBindFuncs() -> Void {
        
        switch_show.rx.isOn.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        switch_show.rx.isOn.asObservable()
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
    }


}
