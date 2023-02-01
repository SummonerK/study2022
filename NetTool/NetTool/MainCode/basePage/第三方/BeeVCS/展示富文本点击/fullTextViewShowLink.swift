//
//  fullTextViewShowLink.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/9.
//

import UIKit
import YYText

let showAgreementText = "欢迎您信任并使用XXAPP！\n 我们非常重视您的个人信息及隐私保护，为了更好地保障您的个人权益，在您使用XXAPP服务前，请务必认真阅读《XX用户协议》《XX隐私协议》《XX儿童用户隐私协议》的全部条款，以便您了解我们如何向您提供服务、保障您的合法权益，如何收集、使用、存储、共享您的相关个人信息，如何管理您的相关个人信息，以及我们对您提供的相关信息的保护方式等。我们会严格在您的授权范围内，按照上述协议约定的方式收集、使用、存储、共享您的账户信息、日志信息、 IMEI 等设备信息等。您点击“同意“视为您已阅读并同意上述协议的全部内容。如您确认，请点击“同意”开始接受我们的服务。"
let AgreementColor = UIColor.hexStringColor(hexString: "7D78FF")

extension CGFloat{
    /// 转换%
    /// - Parameter value:
    /// - Returns:
    func progressTrans() -> String {
        let toValue = self*100
        let printNum:NSNumber = toValue.jk.number
        return String(format: "%@%%",printNum.jk.numberFormatter() ?? "0")
    }
}


class fullTextViewShowLink: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textV_main:UITextView!
    var label_full:YYLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringColor(hexString: "F5F5F5")
        
        showFullYYLabel()
        
        computeSomeValue(88)
        computeSomeValue(888)
        computeSomeValue(8888)
        computeSomeValue(88880)
        
        testCeilCount(value: 1)
        testCeilCount(value: 2)
        testCeilCount(value: 3)
        testCeilCount(value: 4)
        
        

        // Do any additional setup after loading the view.
    }
    
    func testCeilCount(value:Int) -> Void {
        let lineNum = Double(value)/2
        let fixNum = ceil(lineNum)
        let totalTaskCount:Int = Int(ceil(lineNum))
        
        LKPrint("计算包数---\(totalTaskCount)")
    }
    
    func computeSomeValue(_ targetHeight:CGFloat) -> Void {
//        let printHeight = targetHeight*384/(kscreenW - 24)
        let printString = computePrintHeight(with: targetHeight)
        
        let width = printString.jk.rectWidth(font: UIFont.pingfangSC(size: 13), size: CGSize(width: CGFloat(MAXFLOAT), height: 35))
        
        LKPrint("\(printString)")
        LKPrint("字串长度 适配宽度 --- \(width)")
    }
    
    func showFullYYLabel()->Void{
        textV_main.isHidden = true
        label_full = YYLabel(frame: CGRect.init(x: 62, y: 100, width: kscreenW-124, height: 420))
        label_full.backgroundColor = .clear
        label_full.textAlignment = .center
        label_full.numberOfLines = 0
        label_full.textVerticalAlignment = .center
        view.addSubview(label_full)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .left
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                     .foregroundColor: UIColor.black,
                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let baseString = NSMutableAttributedString(string: showAgreementText, attributes:attrs as [NSAttributedString.Key : Any])
        
        let ranges = showAgreementText.jk.nsRange(of: "《XX用户协议》")
        for item in ranges{
            baseString.yy_setTextHighlight(item, color: AgreementColor, backgroundColor: .clear, userInfo: nil) { _, _, _, _ in
                LKPrint("《XX用户协议》")
            }
        }
        
        let ranges1 = showAgreementText.jk.nsRange(of: "《XX隐私协议》")
        for item in ranges1{
            baseString.yy_setTextHighlight(item, color: AgreementColor, backgroundColor: .clear, userInfo: nil) { _, _, _, _ in
                LKPrint("《XX隐私协议》")
            }
        }
        
        let ranges2 = showAgreementText.jk.nsRange(of: "《XX儿童用户隐私协议》")
        for item in ranges2{
            baseString.yy_setTextHighlight(item, color: AgreementColor, backgroundColor: .clear, userInfo: nil) { _, _, _, _ in
                LKPrint("《XX儿童用户隐私协议》")
            }
        }
        
        label_full.attributedText = baseString
    }
    
    func showTextView(){
        textV_main.delegate = self
        
        textV_main.jk.appendLinkString(string: "欢迎您信任并使用XXAPP！ 我们非常重视您的个人信息及隐私保护，为了更好地保障您的个人权益，在您使用XXAPP服务前，请务必认真阅读", font: UIFont.systemFont(ofSize: 15))
        
        textV_main.jk.appendLinkString(string: "《XX用户协议》《XX隐私协议》《XX儿童用户隐私协议》", font: UIFont.systemFont(ofSize: 15),withURLString: "www.baidu.com")
    }
    
    //链接点击响应方法
    private func  textView(textView:  UITextView , shouldInteractWithURL  URL :  NSURL ,
         inRange characterRange:  NSRange ) ->  Bool  {
         
        LKPrint("\(String(describing: URL.scheme))")
         
         return  true
     }
    
    func computePrintHeight(with pixelValue:CGFloat) -> String {
        let printH:CGFloat = CGFloat(pixelValue)/80
        let printNum:NSNumber = printH.jk.number
        let toString = String(format: "纸长：%@cm",printNum.jk.numberFormatter() ?? "0")
        return toString
    }
    
    

}

//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _yyLabel = [[YYLabel alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 40)];
//    _yyLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//    _yyLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_yyLabel];
//    [self protocolIsSelect:NO];
//}
//
//- (void)protocolIsSelect:(BOOL)isSelect{
//    //设置整段字符串的颜色
//    UIColor *color = self.isSelect ? [UIColor blackColor] : [UIColor lightGrayColor];
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12], NSForegroundColorAttributeName: color};
//
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"  注册即表示同意《用户协议》和《隐私政策》" attributes:attributes];
//    //设置高亮色和点击事件
//    [text yy_setTextHighlightRange:[[text string] rangeOfString:@"《用户协议》"] color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        NSLog(@"点击了《用户协议》");
//    }];
//    //设置高亮色和点击事件
//    [text yy_setTextHighlightRange:[[text string] rangeOfString:@"《隐私政策》"] color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        NSLog(@"点击了《隐私政策》");
//
//    }];
//    //添加图片
//    UIImage *image = [UIImage imageNamed:self.isSelect == NO ? @"unSelectIcon" : @"selectIcon"];
//    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont fontWithName:@"PingFangSC-Regular"  size:12] alignment:(YYTextVerticalAlignment)YYTextVerticalAlignmentCenter];
//    //将图片放在最前面
//    [text insertAttributedString:attachment atIndex:0];
//    //添加图片的点击事件
//    [text yy_setTextHighlightRange:[[text string] rangeOfString:[attachment string]] color:[UIColor clearColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        __weak typeof(self) weakSelf = self;
//        weakSelf.isSelect = !weakSelf.isSelect;
//        [weakSelf protocolIsSelect:self.isSelect];
//    }];
//    _yyLabel.attributedText = text;
//    //居中显示一定要放在这里，放在viewDidLoad不起作用
//    _yyLabel.textAlignment = NSTextAlignmentCenter;
//
//}
