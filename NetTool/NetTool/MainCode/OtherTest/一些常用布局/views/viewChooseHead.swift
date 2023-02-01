//
//  viewChooseHead.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit

private let image_like_choose_n = UIImage(named: "ib_choose_n")
private let image_like_choose_s = UIImage(named: "ib_choose_s")

class viewChooseHead: UITableViewHeaderFooterView {
    @IBOutlet weak var viewContent:UIView!
    @IBOutlet weak var label_title:UILabel!
    @IBOutlet weak var imagev_choose:UIImageView!
    private var modelForDay:modelSectionByDay!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
        modelForDay.removeObserver(self, forKeyPath: "isChoose")
    }
    
    override func awakeFromNib() {
        self.layoutSomeUI()
//        self.tintColor = .randomColor
//        if #available(iOS 14.0, *) {
//            self.backgroundConfiguration = UIBackgroundConfiguration.clear()
//        } else {
//            // Fallback on earlier versions
//        }
//        viewContent.backgroundColor = .randomColor
    }
    
    func layoutSomeUI() -> Void {
        // TODO: - 一些布局设置
        viewContent.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else { return }
            self.modelForDay.isChoose = !self.modelForDay.isChoose
        }
    }
    
    func setModel(model:modelSectionByDay) -> Void {
        modelForDay = model
        label_title.text = modelForDay?.dayDes ?? ""
        if (modelForDay?.isChoose ?? false){
            imagev_choose.image = image_like_choose_s
        }else{
            imagev_choose.image = image_like_choose_n
        }
        modelForDay.addObserver(self, forKeyPath: "isChoose", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isChoose" {
            if let newValue = change?[NSKeyValueChangeKey.newKey]{
                guard let newV = newValue as? Bool else { return }
                print(String(format: "%@", (newV ? "选中" : "弃选")))
                if (newV){
                    imagev_choose.image = image_like_choose_s
                }else{
                    imagev_choose.image = image_like_choose_n
                }
            }
        }
    }

}
