//
//  SVGShowVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/6.
//

import UIKit
import SwiftSVG

class SVGShowVC: UIViewController {
    @IBOutlet weak var imageV_svg:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        
        testSvgShow()
//        testSvgShow2()
//        testSvgShow3()
    }
    
    
    func testSvgShow() -> Void {
        let view_rose = UIView(SVGNamed: "cowboyHat")
        view.addSubview(view_rose)
        view_rose.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 130, height: 130))
        }
        view_rose.backgroundColor = .randomColor
    }
    
    func testSvgShow2() -> Void {
        let view_rose = UIView(SVGNamed: "deleteSvg")
        view.addSubview(view_rose)
        view_rose.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 130, height: 130))
        }
        view_rose.backgroundColor = .randomColor
    }
    
    func testSvgShow3() -> Void {
        let view_rose = UIView(SVGNamed: "compass_rose")
        view.addSubview(view_rose)
        view_rose.snp.makeConstraints { make in
            make.top.equalTo(350)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 130, height: 130))
        }
        view_rose.backgroundColor = .randomColor
    }

}
