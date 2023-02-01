//
//  listPagesVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit

class listPagesVC: UIViewController {
    @IBOutlet weak var label_content:UILabel!
    var content:String = ""
    
    static func setupVC(withContent content: String) -> listPagesVC{
        let pagevc = listPagesVC()
        pagevc.content = content
        return pagevc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label_content.text = content
        view.backgroundColor = UIColor.randomColor
        // Do any additional setup after loading the view.
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
