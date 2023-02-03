//
//  showBindVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/2.
//

import UIKit
import RxCocoa
import RxSwift

class showBindVC: BaseVC {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var label_text: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelBindFontSize()

        // Do any additional setup after loading the view.
    }
    
    func labelBindFontSize() -> Void {
        let observable = Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance).take(10)
        
        observable.map { value in
            return CGFloat(value+15)
        }
        .bind(to: label_text.rx.fontSize)
        .disposed(by: disposeBag)
        
        observable.map { _ in
            return UIColor.randomColor
        }
        .bind(to: label_text.rx.textColor)
        .disposed(by: disposeBag)
        
    }

}

/*
 方式一：通过对 UI 类进行扩展
 （1）这里我们通过对 UILabel 进行扩展，增加了一个 fontSize 可绑定属性。
 */
extension UILabel{
    public var fontSize: Binder<CGFloat>{
        return Binder(self){ label, fontSize in
            label.font = UIFont.pingfangSC(size: fontSize)
        }
    }
}

/*
 方式二：通过对 Reactive 类进行扩展
 既然使用了 RxSwift，那么更规范的写法应该是对 Reactive 进行扩展。这里同样是给 UILabel 增加了一个 fontSize 可绑定属性。
 （注意：这种方式下，我们绑定属性时要写成 label.rx.fontSize）
 */
extension Reactive where Base: UILabel{
    public var fontSize: Binder<CGFloat>{
        return Binder(self.base){ label, fontSize in
            label.font = UIFont.pingfangSC(size: fontSize)
        }
    }
}
