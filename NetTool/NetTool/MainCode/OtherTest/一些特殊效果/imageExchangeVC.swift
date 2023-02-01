//
//  imageExchange.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/22.
//

import UIKit

private let imageNormal = UIImage(named: "panda")
private let imageSJNormal = UIImage(named: "sanjiao")
private let imagePGNormal = UIImage(named: "pigai")

class imageExchangeVC: UIViewController {
    @IBOutlet weak var imageV_target:UIImageView!
    @IBOutlet weak var imageV_result:UIImageView!
    @IBOutlet weak var bton_next:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")

        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        // Do any additional setup after loading the view.
    }

}

extension imageExchangeVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "一些常用布局Demo"
        let alertC = UIAlertController.init(title: "布局", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("黑白像素", .default) {
            self.imageV_target.image = imageNormal
            self.exchangeToWhiteBlack()
        }
        alertC.addAction("红色像素替换", .default) {
            self.imageV_target.image = imagePGNormal
            self.exchangeRedToNone()
        }
        alertC.addAction("像素填充-拉伸", .default) {
            self.imageV_target.image = imageSJNormal
            self.imageLashenLoad()
        }
    }
}

extension imageExchangeVC{
    func exchangeToWhiteBlack() -> Void {
        imageV_result.image = imageNormal?.jk.filter(filterType: .CIPhotoEffectNoir, alpha: nil)
    }
    
    func exchangeRedToNone() -> Void {
        imageV_result.image = imagePGNormal?.imageByRemoveRedBg()
    }
    
    func imageLashenLoad() -> Void {
        let halfHeight = imageSJNormal?.size.height ?? 10.0
        imageV_result.image = imageSJNormal?.jk.strechBubble(edgeInsets: UIEdgeInsets.init(top: halfHeight*0.5, left: 0, bottom: halfHeight*0.5, right: 0))
        imageV_result.sizeToFit()
    }
}
