//
//  CCellProblemManagerItem.swift
//  LaiXue
//
//  Created by luoke_ios on 2022/12/14.
//

import UIKit

class CCellProblemManagerItem: UICollectionViewCell {
    @IBOutlet weak var label_title:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.jk.addCorner(conrners: .allCorners, radius: 6)
    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
    
    static func initWithNib() -> CCellProblemManagerItem{
        let nib = UINib(nibName: "CCellProblemManagerItem", bundle: .main)
        let cell = nib.instantiate(withOwner: self, options: nil).first as! CCellProblemManagerItem
        
        return cell
    }
    
}
