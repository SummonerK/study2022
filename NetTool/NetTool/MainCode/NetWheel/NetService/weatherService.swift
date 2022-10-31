//
//  weatherService.swift
//  NetTool
//
//  Created by luoke_ios on 2022/9/30.
//

import RxSwift
import Moya
import ObjectMapper

struct weatherService{
    let disposeBag:DisposeBag = DisposeBag()

    func getExampleInfo(city:String) -> Single<ResponseCommon<resWeatherInfo>> {
        let target = MultiTarget(NetApi.getWeatherInfo(city: city))
//        let provider = Privider(withType: .system)
        let provider = Privider(withType: .system)
        return provider.request(target: target)
    }
}


