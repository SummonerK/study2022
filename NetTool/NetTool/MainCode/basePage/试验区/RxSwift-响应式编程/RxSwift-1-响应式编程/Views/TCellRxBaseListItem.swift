//
//  TCellRxBaseListItem.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit

class TCellRxBaseListItem: UITableViewCell {
    @IBOutlet weak var label_title:UILabel!
    @IBOutlet weak var label_subTitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
