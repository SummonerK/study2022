//
//  TCellChooseCombin.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit

private let image_like_choose_n = UIImage(named: "ib_choose_n")
private let image_like_choose_s = UIImage(named: "ib_choose_s")

class TCellChooseCombin: UITableViewCell {
    
    @IBOutlet weak var imagev_choose:UIImageView!
    @IBOutlet weak var label_title:UILabel!
    
    var modelForItem:modelGoods!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
        modelForItem.removeObserver(self, forKeyPath: "isChoose")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(model:modelGoods) -> Void {
        modelForItem = model
        label_title.text = modelForItem?.des ?? ""
        if (modelForItem?.isChoose ?? false){
            imagev_choose.image = image_like_choose_s
        }else{
            imagev_choose.image = image_like_choose_n
        }
        modelForItem.addObserver(self, forKeyPath: "isChoose", options: [.new, .old], context: nil)
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
