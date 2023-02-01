//
//  CameraContrlView.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/23.
//

import UIKit

protocol LKCameraControlDelegate: NSObject {
    func cameraControlDidTakePhoto()
    func cameraControlDidTakeAlbum()
}

class CameraContrlView: UIView {
    weak open var delegate: LKCameraControlDelegate?
    ///拍照按钮
    var bton_takePhoto:UIButton!
    ///相册按钮
    var bton_takeAlbum:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutSomeUI()
        self.backgroundColor = .black
        self.registFuncs()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registFuncs() -> Void{
        //功能集合
        bton_takePhoto.jk.setHandleClick(controlEvents: .touchUpInside) { [weak self] button in
            guard let self = self else{return}
            if (self.delegate != nil){
                self.delegate?.cameraControlDidTakePhoto()
            }
        }
        bton_takeAlbum.jk.setHandleClick(controlEvents: .touchUpInside) { [weak self] button in
            guard let self = self else{return}
            if (self.delegate != nil){
                self.delegate?.cameraControlDidTakeAlbum()
            }
        }
    }
    
    func layoutSomeUI() -> Void {
        // TODO: - 一些布局设置
        setupTakePhotoBton()
        setupTakeAlbum()
    }
    
    func setupTakePhotoBton() -> Void {
        bton_takePhoto = UIButton()
        bton_takePhoto.setImage(UIImage(named: "camera_take_photo"), for: .normal)
        self.addSubview(bton_takePhoto)
        bton_takePhoto.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 60.0, height: 60.0))
        }
        bton_takePhoto.backgroundColor = .clear
    }
    
    func setupTakeAlbum() -> Void {
        bton_takeAlbum = UIButton()
        bton_takeAlbum.setImage(UIImage(named: "camera_take_album"), for: .normal)
        self.addSubview(bton_takeAlbum)
        bton_takeAlbum.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: 35.0, height: 35.0))
        }
        bton_takeAlbum.backgroundColor = .clear
    }
}
