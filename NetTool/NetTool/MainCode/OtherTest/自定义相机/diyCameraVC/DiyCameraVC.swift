//
//  DiyCameraVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/23.
//

import UIKit
import DeviceKit

let contentWidth = UIScreen.main.bounds.size.width
let contentHeight = UIScreen.main.bounds.size.height

class DiyCameraVC: UIViewController {
    
    var currentInterface:UIInterfaceOrientation = .portrait
    
    var url: String?
    var manager: WMCameraManger!
    let cameraContentView = UIView()
    var controlView: CameraContrlView!
    var labelCenter: UILabel!
    
    //拍照输出
    let previewImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupNavigationView()
        setupCameraContentView()
        manager = WMCameraManger(superView: cameraContentView)
        setupView()
        registOrientation()
        setupCenterLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.startRunning()
        manager.focusAt(view.center)
    }

}

// MARK: - setup subViews
extension DiyCameraVC{
    ///监控屏幕方向
    func registOrientation() -> Void {
        manager.orientation.startUpdates { [weak self] (orientation) in
            guard let self = self else { return }
            self.currentInterface = orientation
            //90度
            let angle = CGFloat.pi/2
            switch orientation{
            case .landscapeLeft:
                print("landscapeLeft")
                self.labelCenter.jk.setRotation(angle)
                break
            case .landscapeRight:
                print("landscapeRight")
                self.labelCenter.jk.setRotation(-angle)
                break
            case .portraitUpsideDown:
                print("portraitUpsideDown")
                break
            case .portrait:
                print("portrait")
                self.labelCenter.jk.setRotation(0)
                break
            case .unknown:
                print("unknown")
                break
            @unknown default:
                print("@unknown")
            }
        }
    }
    
    func setupNavigationView() -> Void {
        let navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: view.safeInsets.top + 44)
        navigationView.layer.zPosition = 1000
        navigationView.backgroundColor = .black
        view.addSubview(navigationView)
        
        let bton_left = UIButton()
        navigationView.addSubview(bton_left)
        bton_left.setImage(UIImage(named: "camera_cancel"), for: .normal)
        bton_left.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 38, height: 44))
        }
        
        let bton_right = UIButton()
        navigationView.addSubview(bton_right)
        bton_right.setImage(UIImage(named: "camera_shark"), for: .normal)
        bton_right.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 38, height: 44))
        }
        
        bton_left.jk.setHandleClick { [weak self] button in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        bton_right.jk.setHandleClick { [weak self] button in
            guard let self = self else { return }
            self.manager.flashLight { mode in
                if mode == .on{
                    print("打开了闪光灯")
                }
                if mode == .off{
                    print("关闭了闪光灯")
                }
            }
        }

    }
    
    func setupCenterLabel() -> Void {
        labelCenter = UILabel()
        labelCenter.textColor = UIColor.white
        labelCenter.font = UIFont.jk.customFontR(17)
        labelCenter.numberOfLines = 0
        labelCenter.textAlignment = NSTextAlignment.center
        
        cameraContentView.addSubview(labelCenter)
        
        labelCenter.snp.makeConstraints { make in
            make.center.equalToSuperview()
            labelCenter.sizeToFit()
        }
        
        let absoluteString = "平行纸面，文字对齐参考线\n请注意这行文字的方向是否正确"
        var attString = NSAttributedString(string: absoluteString)
        attString = attString.jk.setSpecificTextFont("请注意这行文字的方向是否正确", font: UIFont.jk.customFontR(13))
        labelCenter.attributedText = attString
        labelCenter.jk.setTextLineSpace(6)
    }
    
    func setupCameraContentView() -> Void {
        cameraContentView.backgroundColor = UIColor.black
        let mainView_Y:CGFloat = Device.current.heightOfStatusBar + Device.current.heightOfNaviBar
        let mainView_H:CGFloat = contentHeight - mainView_Y - self.view.safeInsets.bottom - 70
        cameraContentView.frame = CGRect(x: 0, y: mainView_Y, width: contentWidth, height: mainView_H)
        self.view.addSubview(cameraContentView)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black
        cameraContentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(focus(_:))))
        cameraContentView.addGestureRecognizer(UIPinchGestureRecognizer.init(target: self, action: #selector(pinch(_:))))
        
        previewImageView.frame = cameraContentView.bounds
        previewImageView.backgroundColor = UIColor.black
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.isHidden = true
        cameraContentView.addSubview(previewImageView)
        
        let control_H = self.view.safeInsets.bottom + 70
        controlView = CameraContrlView.init(frame: CGRect(x: 0, y: contentHeight-control_H, width: contentWidth, height: control_H))
        controlView.layoutSubviews()
        controlView.delegate = self
//        controlView.videoLength = self.videoMaxLength
//        controlView.inputType = self.inputType
        view.addSubview(controlView)
    }
    
    @objc func focus(_ ges: UITapGestureRecognizer) {
        let focusPoint = ges.location(in: cameraContentView)
        manager.focusAt(focusPoint)
    }
    
    @objc func pinch(_ ges: UIPinchGestureRecognizer) {
        guard ges.numberOfTouches == 2 else { return }
        if ges.state == .began {
            manager.repareForZoom()
        }
        manager.zoom(Double(ges.scale))
    }
}

extension DiyCameraVC:LKCameraControlDelegate{
    func cameraControlDidTakeAlbum() {
        if UIApplication.jk.isOpenPermission(.album){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
//            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .custom
            present(imagePicker, animated: true)
        }else{
            print("相册权限未打开")
        }
    }
    
    func cameraControlDidTakePhoto() {
        manager.pickImage { [weak self] (imageUrl) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showPreviewImageView(with: imageUrl)
            }
        }
    }
    
    func showPreviewImageView(with imageUrl:String) -> Void {
        print(imageUrl)
//        self.url = imageUrl
//        self.previewImageView.image = UIImage.init(contentsOfFile: imageUrl)
//        self.previewImageView.isHidden = false
        let vc = NewImageCropVC.setupImageCropVC(with: currentInterface, imageUrl: imageUrl)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DiyCameraVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        
        
        // 选择的图片参数
        /*
        print("1 图片选择：\(info)")
        指定用户选择的媒体类型 UIImagePickerControllerMediaType
        原始图片 UIImagePickerControllerOriginalImage
        修改后的图片 UIImagePickerControllerEditedImage
        裁剪尺寸 UIImagePickerControllerCropRect
        媒体的URL UIImagePickerControllerMediaURL
        原件的URL UIImagePickerControllerReferenceURL
        当来数据来源是照相机的时候这个值才有效 UIImagePickerControllerMediaMetadata
        */
        // 退出图片选择控制器
        
        // 获取选择的原图
        guard let image = (info[.originalImage] as? UIImage) else{ return }
        let maxImageWidth: CGFloat = kscreenW - 110
        let maxImageHeight: CGFloat = kscreenH - Device.current.heightOfStatusBar - Device.current.heightOfBottomBar - 107
        let ratio:CGFloat = image.size.width/image.size.height
        let ratiolocal:CGFloat = maxImageWidth/maxImageHeight
        var currentW:CGFloat = 0
        var currentH:CGFloat = 0
        if ratio >= ratiolocal{
            currentW = maxImageWidth
            currentH = maxImageWidth/ratio
        }else{
            currentW = maxImageHeight*ratio
            currentH = maxImageHeight
        }
        if currentH < 75 || currentW < 75 || image.size.width < 75 || image.size.height < 75{
            print("该图片不支持，请选择其他图片")
            MBHud.showInfoWithMessage("该图片不支持，请选择其他图片")
            return
        }
        guard let imageUrl = info[.imageURL] as? NSURL else { return }
        guard let targetUrl = imageUrl.path,!targetUrl.isEmpty else { return }
        self.showPreviewImageView(with: targetUrl)
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("2 放弃图片选择")
        // 退出图片选择控制器
        picker.dismiss(animated: true, completion: nil)
    }
}
