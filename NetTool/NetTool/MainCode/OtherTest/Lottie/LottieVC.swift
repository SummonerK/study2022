//
//  LottieVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/1.
//

import UIKit
import Lottie

class LottieVC: UIViewController {
    @IBOutlet weak var bton_next:UIButton!
    @IBOutlet weak var likeButton: LottieAnimationView!
    var isLike = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        
        addLikeSource()
        // Do any additional setup after loading the view.
    }
    
    func addLikeSource() -> Void {
        let imageProvider = BundleImageProvider(bundle: Bundle.main, searchPath: "lottieSource")
        likeButton.imageProvider = imageProvider
        likeButton.loopMode = .playOnce
        likeButton.animation = LottieAnimation.named("disLike", subdirectory: "lottieSource")
    }
    
    func updateLikeStatus() -> Void {
        if self.isLike{
            self.isLike = false
            self.likeButton.animation = LottieAnimation.named("disLike", subdirectory: "lottieSource")
        }else{
            self.isLike = true
            self.likeButton.animation = LottieAnimation.named("like", subdirectory: "lottieSource")
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

extension LottieVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "动画"
        let alertC = UIAlertController.init(title: "Lottie动画", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("Default", .default) {
            self.showLottieDefault()
        }
    }
}

extension LottieVC{
    func showLottieDefault() -> Void {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.likeButton.play(){ _ in
                self.updateLikeStatus()
            }
        }
    }
    
}
