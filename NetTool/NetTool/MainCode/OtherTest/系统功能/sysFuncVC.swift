//
//  sysFuncVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/9.
//

import UIKit
let IBScreenW = UIScreen.main.bounds.size.width
let IBScreenH = UIScreen.main.bounds.size.height

class sysFuncVC: UIViewController {
    @IBOutlet weak var bton_next:UIButton!
    @IBOutlet weak var imageV_result:UIImageView!

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

extension sysFuncVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "一些测试"
        let alertC = UIAlertController.init(title: "系统功能", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("sysShare", .default) {
            self.sysShareHandle()
        }
        alertC.addAction("生成图片", .default) {
            let image = self.drawViewIntoImageView()
            self.imageV_result.image = image
        }
    }
}

extension sysFuncVC{
    // MARK: - social.framework
    func sysShareHandle() -> Void {
        // image to share
        let image = UIImage(named: "showImage")
//        let image = UIImage(named: )
        // set up activity view controller
        guard let reqImage = image else {
            print("图片不合法")
            return
        }
        let imageToShare = [reqImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.message, UIActivity.ActivityType.postToWeibo]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { _,completed,_,_ in
            printLine()
            if completed{
                print("发送完成")
            }else{
                print("发送失败")
            }
        }
    }
    
    func drawViewIntoImageView() -> UIImage? {
        
        let label_someView = UILabel()
        label_someView.frame = CGRect(x: 0, y: 0, width: IBScreenW-40, height: 40)
        label_someView.text = "view、"
        label_someView.font = UIFont.systemFont(ofSize: 30)
        label_someView.textColor = .blue
        label_someView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0.1)
        let image = UIImage(named: "showImage")
        guard let reqImage = image else {
            print("图片不合法")
            return nil
        }
        let targetSize = CGSize(width: IBScreenW, height: 600)
        let image_bg = UIImage.jk.image(color: UIColor.white, size: targetSize, corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 20)
        UIGraphicsBeginImageContext(targetSize)
        image_bg?.draw(in: CGRect(x: 0, y: 0, width: IBScreenW, height: 600))
//        label_someView.drawText(in: CGRect(x: 20, y: 320, width: IBScreenW-40, height: 40))
        reqImage.draw(in: CGRect(x: 0, y: 20, width: IBScreenW, height: 300))
        label_someView.jk.toImage()?.draw(in: CGRect(x: 20, y: 340, width: IBScreenW-40, height: 40))
        let image_result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image_result
    }
}
