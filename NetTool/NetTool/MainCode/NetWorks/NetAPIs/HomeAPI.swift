//
//  HomeAPI.swift
//  NetTool
//
//  Created by luoke_ios on 2022/8/15.
//

import Foundation
import RxSwift
import Moya

class HomeModel {
    let disposeBag = DisposeBag()
    
    let headerFields: Dictionary<String, String> = [
        "platform": "iOS",
        "sys_ver": String(UIDevice.version())
    ]

    let appendedParams: Dictionary<String, String> = [
        "uid": "123456"
    ]
        
    private let provider = MoyaProvider<HomeApiConfig>()
    
    
    func homeGet() -> Single<homeModel> {
        return provider.rx.request(.github)
            .mapObj(homeModel.self)
    }

}
