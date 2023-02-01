//
//  NewImageCropVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/5.
//

import UIKit
import DeviceKit

class NewImageCropVC: UIViewController {
    ///最小裁剪宽度
    let minCropWidth: CGFloat = 75
    ///最小裁剪高度
    let minCropHeight: CGFloat = 75
    
    let maxImageWidth: CGFloat = kscreenW - 110
    let maxImageHeight: CGFloat = kscreenH - Device.current.heightOfStatusBar - Device.current.heightOfBottomBar - 107
    
    let imageCenterX:CGFloat = kscreenW/2
    let imageCenterY:CGFloat = (kscreenH - Device.current.heightOfStatusBar + Device.current.heightOfBottomBar - 107)/2
    
    var openInterface:UIInterfaceOrientation = .portrait
    var imageUrl:String = ""
    
    var view_original_bg:UIView!
    var imageV_original:UIImageView!
    var view_tool:UIView!
    ///subviews
    var bton_mapping:UIButton!
    var bton_cancel:UIButton!
    
    var view_crop:UIView!
    var view_cropCorner:UIView!
    
    static func setupImageCropVC(with interface:UIInterfaceOrientation,imageUrl:String) -> NewImageCropVC{
        let vc = NewImageCropVC()
        vc.openInterface = interface
        vc.imageUrl = imageUrl
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .black
        initImageViewOriginal()
        initViewTool()
        initCropView()
        
        updateView(with: openInterface)
        guard let fromImage = UIImage.init(contentsOfFile: imageUrl) else { return }
        let ratio:CGFloat = fromImage.size.width/fromImage.size.height
        let ratiolocal:CGFloat = maxImageWidth/maxImageHeight
        var currentW:CGFloat = 0
        var currentH:CGFloat = 0
        if ratio >= ratiolocal{
            currentW = maxImageWidth
            currentH = maxImageWidth/ratio
        }else{
            currentH = maxImageHeight
            currentW = maxImageHeight*ratio
        }
        imageV_original.snp.updateConstraints { make in
            make.width.equalTo(currentW)
            make.height.equalTo(currentH)
        }
        view_original_bg.snp.updateConstraints { make in
            make.width.equalTo(currentW+26)
            make.height.equalTo(currentH+26)
        }
        
        imageV_original.image = fromImage
    }
    ///target【w:3,h:4】
    ///image【w:7,h:1】【w:1,h:7】
    ///思路 用image宽除以高，大了用宽，小了用高
    ///
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_crop.center = CGPoint(x: imageV_original.frame.size.width/2, y: imageV_original.frame.size.height/2)
        view_crop.frame.size = CGSize(width: imageV_original.frame.size.width/2, height: imageV_original.frame.size.height/2)
        view_cropCorner.frame = transCropCornerFrame(with: view_crop.frame)
        resetCropMask()
    }
    
    /// 工具栏方法集合
    /// - Returns:
    func registToolFuncs() -> Void {
        bton_mapping.jk.setHandleClick(controlEvents: .touchUpInside) { [weak self] button in
            guard let self = self else{return}
            print("匹配")
            let frame = self.view_crop.frame
            print("view_crop.frame = \(frame)")
            print("self.imageV_original.glt_width = \(self.imageV_original.glt_width)")
            if let image = self.imageV_original.image?.jk.fixOrientation() {
                let scale = image.size.width/self.imageV_original.glt_width
                print("image.size = \(image.size)")
                print("scale = \(scale)")
                let toRect = CGRect(x: frame.origin.x*scale, y: frame.origin.y*scale, width: frame.width*scale, height: frame.height*scale)
                print("toRect = \(toRect)")
                print("image.imageOrientation == \(image.imageOrientation)")
                guard let cropImage = image.cropping(to: toRect) else {
                    print("截取失败")
                    return
                }
                
//                guard let cropImage = image.jk.cropWithCropRect(toRect) else {
//                    print("截取失败")
//                    return
//                }
                
                print("cropImage.size = \(cropImage.size)")
                
//                self.imageV_original.image = cropImage
                
            }
        }
        
        bton_cancel.jk.setHandleClick(controlEvents: .touchUpInside) { [weak self] button in
            guard let self = self else{ return }
            self.dissmissCropVC()
        }
    }
    
    func updateView(with interface:UIInterfaceOrientation) -> Void {
        //90度
        let angle = CGFloat.pi/2
        switch interface{
        case .landscapeLeft:
            print("landscapeLeft")
            bton_mapping.jk.setRotation(angle)
            break
        case .landscapeRight:
            print("landscapeRight")
            bton_mapping.jk.setRotation(-angle)
            break
        case .portraitUpsideDown:
            print("portraitUpsideDown")
            break
        case .portrait:
            print("portrait")
            bton_mapping.jk.setRotation(0)
            break
        case .unknown:
            print("unknown")
            break
        @unknown default:
            print("@unknown")
        }
    }
}

// MARK: - baseLayoutViews
extension NewImageCropVC{
    
    func dissmissCropVC() -> Void {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func initImageViewOriginal() -> Void {
        imageV_original = UIImageView()
        imageV_original.contentMode = .scaleAspectFit
        view.addSubview(imageV_original)
        imageV_original.snp.makeConstraints { make in
            make.center.equalTo(CGPoint(x: imageCenterX, y: imageCenterY))
            make.width.equalTo(maxImageWidth)
            make.height.equalTo(maxImageHeight)
        }
        view_original_bg = UIView()
        view.addSubview(view_original_bg)
        view_original_bg.backgroundColor = .clear
        view_original_bg.snp.makeConstraints { make in
            make.center.equalTo(CGPoint(x: imageCenterX, y: imageCenterY))
            make.width.equalTo(maxImageWidth)
            make.height.equalTo(maxImageHeight)
        }
    }
    
    private func initViewTool() -> Void {
        let mainView_Y:CGFloat = kscreenH - self.view.safeInsets.bottom - 107
        let mainView_H:CGFloat = 107
        view_tool = UIView()
        view.addSubview(view_tool)
        view_tool.frame = CGRect(x: 0, y: mainView_Y, width: kscreenW, height: mainView_H)
        view_tool.backgroundColor = .clear
        
        /// init SubViews
        initViewMapping()
        initViewCancel()
        
        
        registToolFuncs()
    }
    
    private func initViewMapping() -> Void {
        bton_mapping = UIButton()
        view_tool.addSubview(bton_mapping)
        bton_mapping.setImage(UIImage(named: "camera_mappping"), for: .normal)
        bton_mapping.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 68, height: 42))
        }
    }
    
    private func initViewCancel() -> Void {
        bton_cancel = UIButton()
        view_tool.addSubview(bton_cancel)
        bton_cancel.setImage(UIImage(named: "camera_cancel"), for: .normal)
        bton_cancel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
}

enum CropPosition: Int {
    case topLeft = 100
    case topRight = 101
    case bottomLeft = 102
    case bottomRight = 103
    case top = 104
    case left = 105
    case bottom = 106
    case right = 107
}

let wall_space = 13.5
let wall_space_corner = 8.5

// MARK: - CropMask-框选裁剪
extension NewImageCropVC{
    
    func transCropCornerFrame(with frame:CGRect) -> CGRect {
        let forFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width + wall_space*2, height: frame.size.height + wall_space*2)
        return forFrame
    }
    
    func initCropView() -> Void {
//        let frame = CGRect(x: -5, y: -5, width: minCropWidth, height: minCropHeight)
        let frame = CGRect(x: 0, y: 0, width: minCropWidth, height: minCropHeight)
        view_crop = UIView(frame: frame)
        view_crop.isUserInteractionEnabled = true
//        view_crop.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(translation(_:))))
//        initCropViewOtherGesture()
        view_crop.backgroundColor = UIColor.clear
        
        imageV_original.isUserInteractionEnabled = true
        view_original_bg.addSubview(view_crop)
        
        //裁剪边界的contentView
        view_cropCorner = UIView(frame: transCropCornerFrame(with: frame))
        view_cropCorner.backgroundColor = .clear
        initCropViewOtherGesture()
        view_cropCorner.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(translation(_:))))
        view_original_bg.addSubview(view_cropCorner)
    }
    
    func resetCropMask() -> Void {
        //选框区域
        let clearRect = view_crop.frame
        //背景渲染区域
        let path = UIBezierPath(rect: imageV_original.bounds)
        let clearPath = UIBezierPath(rect: clearRect)
        path.append(clearPath)

        let layer = CAShapeLayer()
        layer.frame = imageV_original.bounds
        layer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillRule = .evenOdd
        layer.path = path.cgPath
        for item in imageV_original.layer.sublayers ?? [] {
            if item is CAShapeLayer {
                item.removeFromSuperlayer()
            }
        }
        imageV_original.layer.addSublayer(layer)
    }
    
    @objc func translation(_ pan: UIPanGestureRecognizer) {
        var point = pan.location(in: imageV_original)
        if point.x < -wall_space {point.x = -wall_space}
        if point.x > imageV_original.frame.width {point.x = imageV_original.frame.width}
        if point.y < -wall_space {point.y = -wall_space}
        if point.y > imageV_original.frame.height {point.y = imageV_original.frame.height}
        
        if pan.state == .changed {
            var frame = view_crop.frame
            let minX: CGFloat = 0
            let minY: CGFloat = 0
            let maxX = imageV_original.frame.width-frame.width
            let maxY = imageV_original.frame.height-frame.height
            var x = point.x-frame.width/2
            if x < minX {
                x = minX
            }
            if x > maxX {
                x = maxX
            }
            var y = point.y-frame.height/2
            if y < minY {
                y = minY
            }
            if y > maxY {
                y = maxY
            }
            frame.origin.x = x
            frame.origin.y = y
            view_crop.frame = frame
            view_cropCorner.frame = transCropCornerFrame(with: frame)
            resetCropMask()
        }
    }
    
    
    /// 边界添加手势
    /// - Returns:
    func initCropViewOtherGesture() -> Void {
        let frame = view_crop.frame
        let leftTopImage = UIImageView(image: UIImage(named: "cc_top_left"))
        leftTopImage.frame = CGRect(x: wall_space_corner, y: wall_space_corner, width: 25, height: 25)
        leftTopImage.autoresizingMask = [.flexibleBottomMargin,.flexibleRightMargin]
        leftTopImage.tag = CropPosition.topLeft.rawValue
        leftTopImage.isUserInteractionEnabled = true
        leftTopImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(leftTopImage)
        
        let rightTopImage = UIImageView(image: UIImage(named: "cc_top_right"))
        rightTopImage.frame = CGRect(x: frame.maxX-wall_space_corner+1, y: wall_space_corner, width: 25, height: 25)
        rightTopImage.autoresizingMask = [.flexibleBottomMargin,.flexibleLeftMargin]
        rightTopImage.tag = CropPosition.topRight.rawValue
        rightTopImage.isUserInteractionEnabled = true
        rightTopImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(rightTopImage)

        let topImage = UIImageView(image: UIImage(named: "cc_top"))
        topImage.frame = CGRect(x:24.5 + wall_space, y: 0, width: frame.width-25*2, height: 25)
        topImage.contentMode = .scaleAspectFit
        topImage.autoresizingMask = [.flexibleWidth,.flexibleBottomMargin]
        topImage.tag = CropPosition.top.rawValue
        topImage.isUserInteractionEnabled = true
        topImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(topImage)
        
        let leftImage = UIImageView(image: UIImage(named: "cc_left"))
        leftImage.frame = CGRect(x:0, y: 24.5 + wall_space, width: frame.width-25*2, height: 25)
        leftImage.contentMode = .scaleAspectFit
        leftImage.autoresizingMask = [.flexibleHeight,.flexibleRightMargin]
        leftImage.tag = CropPosition.left.rawValue
        leftImage.isUserInteractionEnabled = true
        leftImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(leftImage)
        
        let rightImage = UIImageView(image: UIImage(named: "cc_right"))
        rightImage.frame = CGRect(x:frame.maxX+1, y: 24.5 + wall_space, width: frame.width-25*2, height: 25)
        rightImage.contentMode = .scaleAspectFit
        rightImage.autoresizingMask = [.flexibleHeight,.flexibleLeftMargin]
        rightImage.tag = CropPosition.right.rawValue
        rightImage.isUserInteractionEnabled = true
        rightImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(rightImage)
        
        let bottomLeftImage = UIImageView(image: UIImage(named: "cc_bottom_left"))
        bottomLeftImage.frame = CGRect(x: wall_space_corner, y: frame.maxY-wall_space_corner+1, width: 25, height: 25)
        bottomLeftImage.autoresizingMask = [.flexibleTopMargin,.flexibleRightMargin]
        bottomLeftImage.tag = CropPosition.bottomLeft.rawValue
        bottomLeftImage.isUserInteractionEnabled = true
        bottomLeftImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(bottomLeftImage)
        
        let bottomRightImage = UIImageView(image: UIImage(named: "cc_bottom_right"))
        bottomRightImage.frame = CGRect(x: frame.maxX-wall_space_corner+1, y: frame.maxY-wall_space_corner+1, width: 25, height: 25)
        bottomRightImage.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin]
        bottomRightImage.tag = CropPosition.bottomRight.rawValue
        bottomRightImage.isUserInteractionEnabled = true
        bottomRightImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(bottomRightImage)

        let bottomImage = UIImageView(image: UIImage(named: "cc_bottom"))
        bottomImage.frame = CGRect(x: 24.5 + wall_space, y: frame.maxY+1, width: frame.width-25*2, height: 25)
        bottomImage.contentMode = .scaleAspectFit
        bottomImage.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        bottomImage.tag = CropPosition.bottom.rawValue
        bottomImage.isUserInteractionEnabled = true
        bottomImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePan(_:))))
        view_cropCorner.addSubview(bottomImage)
    }
    
    @objc func movePan(_ pan: UIPanGestureRecognizer) -> Void {
        guard let panView = pan.view else { return }
        var point = pan.location(in: self.imageV_original)
        if point.x < 0 {point.x = 0}
        if point.x > imageV_original.frame.width {point.x = imageV_original.frame.width}
        if point.y < 0 {point.y = 0}
        if point.y > imageV_original.frame.height {point.y = imageV_original.frame.height}
        
        if pan.state == .changed {
            if panView.tag == CropPosition.topLeft.rawValue {
                var frame = view_crop.frame
                let minX: CGFloat = 0
                let minY: CGFloat = 0
                let maxX = frame.maxX-minCropWidth
                let maxY = frame.maxY-minCropHeight
                var x = point.x
                if x < minX {
                    x = minX
                }
                if x > maxX {
                    x = maxX
                }
                var y = point.y
                if y < minY {
                    y = minY
                }
                if y > maxY {
                    y = maxY
                }
                frame = CGRect(x: x, y: y, width: (frame.origin.x-x)+frame.width, height: (frame.origin.y-y)+frame.height)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.topRight.rawValue {
                var frame = view_crop.frame
                let minX: CGFloat = frame.minX+minCropWidth
                let minY: CGFloat = 0
                let maxX = imageV_original.frame.width
                let maxY = frame.maxY-minCropHeight
                var x = point.x
                if x < minX {
                    x = minX
                }
                if x > maxX {
                    x = maxX
                }
                var y = point.y
                if y < minY {
                    y = minY
                }
                if y > maxY {
                    y = maxY
                }
                frame = CGRect(x: frame.origin.x, y: y, width: x-frame.origin.x, height: (frame.origin.y-y)+frame.height)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.top.rawValue {
                var frame = view_crop.frame
                let minY: CGFloat = 0.0
                let maxY = frame.maxY-minCropHeight
                var y = point.y
                if y < minY {
                    y = minY
                }
                if y > maxY {
                    y = maxY
                }
                frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: (frame.origin.y-y)+frame.height)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.left.rawValue {
                var frame = view_crop.frame
                let minX: CGFloat = 0.0
                let maxX = frame.maxX-minCropWidth
                var x = point.x
                if x < minX {
                    x = minX
                }
                if x > maxX {
                    x = maxX
                }
                frame = CGRect(x: x, y: frame.origin.y, width: (frame.origin.x-x)+frame.width, height: frame.height)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.right.rawValue {
                var frame = view_crop.frame
                let minX: CGFloat = frame.minX+minCropWidth
                let maxX = imageV_original.frame.width
                var x = point.x
                if x < minX {
                    x = minX
                }
                if x > maxX {
                    x = maxX
                }
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: x-frame.origin.x, height: frame.height)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.bottomLeft.rawValue {
                var frame = view_crop.frame
                let minX: CGFloat = 0.0
                let minY: CGFloat = frame.minY+minCropHeight
                let maxX = frame.maxX-minCropWidth
                let maxY = imageV_original.frame.height
                var x = point.x
                if x < minX {
                    x = minX
                }
                if x > maxX {
                    x = maxX
                }
                var y = point.y
                if y < minY {
                    y = minY
                }
                if y > maxY {
                    y = maxY
                }
                frame = CGRect(x: x, y: frame.origin.y, width: (frame.origin.x-x)+frame.width, height: y-frame.origin.y)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.bottomRight.rawValue {
                var frame = view_crop.frame
                let minX: CGFloat = frame.minX+minCropWidth
                let minY: CGFloat = frame.minY+minCropHeight
                let maxX = imageV_original.frame.width
                let maxY = imageV_original.frame.height
                var x = point.x
                if x < minX {
                    x = minX
                }
                if x > maxX {
                    x = maxX
                }
                var y = point.y
                if y < minY {
                    y = minY
                }
                if y > maxY {
                    y = maxY
                }
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: x-frame.origin.x, height: y-frame.origin.y)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
            else if panView.tag == CropPosition.bottom.rawValue {
                var frame = view_crop.frame
                let minY: CGFloat = frame.minY+minCropHeight
                let maxY = imageV_original.frame.height
                var y = point.y
                if y < minY {
                    y = minY
                }
                if y > maxY {
                    y = maxY
                }
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: y-frame.origin.y)
                view_crop.frame = frame
                view_cropCorner.frame = transCropCornerFrame(with: frame)
                resetCropMask()
            }
        }
        
    }
}
