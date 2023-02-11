//
//  RxShowStepperVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/10.
//

import UIKit
import RxSwift
import RxCocoa

class RxShowStepperVC: BaseVC {
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var slider_show: UISlider!
    @IBOutlet weak var stepper_show: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindFuncs()
    }
    
    
    func setupBindFuncs() -> Void {
        slider_show.rx.value.asObservable()
            .subscribe(onNext: { value in
                LKPrint("slider value - \(value)")
            })
            .disposed(by: disposeBag)
        
        stepper_show.rx.value.asObservable()
            .subscribe(onNext: { value in
                LKPrint("stepper value - \(value)")
            })
            .disposed(by: disposeBag)
        
    }

}
