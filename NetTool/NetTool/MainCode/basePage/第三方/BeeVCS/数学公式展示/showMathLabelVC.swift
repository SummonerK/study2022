//
//  showMathLabelVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/4.
//

import UIKit
import iosMath
import YYText



private let LatexString = "a_{ij}^{2} + b^3_{2}=\\\\x^{t} + y' + x''_{12} 一汉字 4 ◯ 3"
//private let LatexString = "a_{ij}^{2} + b^3_{2}=\\\\x^{t} + y' + x''_{12} 汉字 4 ◯ 3"
private let LatexString1 = "\\frak Q(\\lambda,\\hat{\\lambda}) = -\\frac{1}{2} \\mathbb P(O \\mid \\lambda ) \\sum_s \\sum_m \\sum_t \\gamma_m^{(s)} (t) +\\\\ \\quad \\left( \\log(2 \\pi ) + \\log \\left| \\cal C_m^{(s)} \\right| + \\left( o_t - \\hat{\\mu}_m^{(s)} \\right) ^T \\cal C_m^{(s)-1} \\right)"

class showMathLabelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showMathYYLabel()
        
        showMTMathUILabel()
        
//
//        showComputeMathLabel()
        // Do any additional setup after loading the view.
    }
    
    func getMathLatexWithString(with string:String,fontSize:CGFloat) -> NSAttributedString {
        let label = MTMathUILabel()
        label.fontSize = fontSize
        label.latex = string
        
        let size = label.sizeThatFits(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)))
        label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let viewC = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height+5))
        viewC.addSubview(label)
        
        let attrch = NSTextAttachment()
        attrch.bounds = CGRect(x: 0, y: -size.height/2, width: size.width, height: size.height+5)
        attrch.image = viewC.jk.toImage()
        
        let astring = NSAttributedString(attachment: attrch)
        
        return astring
    }

    func showMTMathUILabel() -> Void {
        let label = MTMathUILabel(frame: CGRect(x: 0, y: 100, width: kscreenW, height: 144))
        label.backgroundColor = UIColor.hexStringColor(hexString: "CCCCCC")
        label.latex = LatexString
        label.contentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        view.addSubview(label)
        
        
        let label1 = UILabel()
        label1.backgroundColor = UIColor.hexStringColor(hexString: "CCCCCC")
        label1.numberOfLines = 0
        
        label1.attributedText = getMathLatexWithString(with: LatexString, fontSize: 14)
        
        label1.sizeToFit()
        
        LKPrint(label1.frame)
        
        label1.frame = CGRect(x: 0, y: 300, width: label1.frame.size.width, height: label1.frame.size.height)
        
        view.addSubview(label1)
    }
    
    func showComputeMathLabel() -> Void {
        let label = MTMathUILabel()
        label.latex = LatexString
        label.fontSize = 14
        label.sizeToFit()
        LKPrint(label.bounds.size)
        
        let font = UIFont.systemFont(ofSize: 14)
        let Width = LatexString.jk.widthAccording(width: CGFloat(MAXFLOAT), font: font)
        
        LKLog(Width)
    }
    
    func showMathYYLabel() -> Void {
        
        let label = YYLabel()
        label.numberOfLines = 0
        // 多行时，需要设置此属性才可以自动换行
//        label.preferredMaxLayoutWidth = CGFloat(kscreenW)
        label.textColor = baseTextColor33
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor.hexStringColor(hexString: "CCCCCC")
        
        label.frame = CGRect(x: 0, y: 100, width: kscreenW, height: 144)
        label.attributedText = getMathLatexWithString(with: LatexString, fontSize: 14)
        
//        label.text = "dadsdsds"
        
        view.addSubview(label)
    }

}
