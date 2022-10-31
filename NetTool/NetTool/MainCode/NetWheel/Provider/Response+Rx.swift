//
//  Response+Rx.swift
//  chezhu
//
//  Created by panjiulong on 2018/11/19.
//  Copyright © 2018 Allen long. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import Alamofire

let kExpiredTokenCode = 3000

func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
    do{
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dic = json as! Dictionary<String, Any>
        return dic
    }catch _ {
        print("失败")
        return nil
    }
}


public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func filterSuccess(target:MultiTarget,disposeBag:DisposeBag,tokenExpiredClosure:((_ target:MultiTarget,_ disposeBag:DisposeBag)->(Single<Element>))? = nil) -> Single<Element> {
        return flatMap { (response) -> Single<Element> in
            
            guard 200 ... 299 ~= response.statusCode else{
                return Single.just(response)
            }

            guard let dic = dataToDictionary(data: response.data) else{
                return Single.error(NSError(domain: "解析失败", code: 1000, userInfo: nil))
            }
            print("resultDic = \(dic)")
            let model = ResponseCommon<CommonData>.init(JSON: dic)

            //处理过期
            guard model?.code == kExpiredTokenCode else{
                return Single.just(response)
            }

            return tokenExpiredClosure?(target,disposeBag) ?? Single.just(response)
        }
    }
}




