//
//  ApiConfig.swift
//  NetTool
//
//  Created by luoke_ios on 2022/8/15.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya
import ObjectMapper
import simd

let RESULT_CODE = "code"
let RESULT_DATA = "data"
let RESULT_MSG = "message"

public protocol Mapable {
    init?(jsonData:JSON)
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    /// 数据转JSON
    fileprivate func resultToJSON<T: Mappable>(_ jsonData: JSON, ModelType: T.Type) -> T? {
        return T(map: jsonData.rawValue as! Map)
    }
    
    func mapObj<T: Mappable>(_ type: T.Type) -> Single<T>{
        return flatMap{ response -> Single in
            //Moya.Response
            //检查是否是一次成功的响应
            guard ((200...209) ~= response.statusCode) else {
                throw XXError.XHFailureHTTP
            }
            //将data转为JSON
            let json = try JSON.init(data: response.data)
            
            //判断是否有状态码
            if let code = json[RESULT_CODE].string {
                
                //判断返回的状态码是否与成功状态码一致
                if code == XXStatus.XHSuccess.rawValue {
                    //将数据结构中的数据包字段转为JSON传出
                    if let resultModel = self.resultToJSON(json[RESULT_DATA], ModelType: type){
                        return Single.just(resultModel)
                    }else{
                        throw XXError.XHNotMakeObjectError
                    }
                }else {
                    //状态码与成功状态码不一致的时候，返回提示信息
                    throw XXError.XHMsgError(statusCode: json[RESULT_CODE].string, errorMsg: json[RESULT_MSG].string)
                }
                
            }else {
                //报错非对象
                throw XXError.XHNotMakeObjectError
            }
            
        }
    }

}
    
extension Observable{
    
    /// 数据转JSON
    fileprivate func resultToJSON<T: Mapable>(_ jsonData: JSON, ModelType: T.Type) -> T? {
        return T(jsonData: jsonData)
    }
    
    /// 数据是JSON使用这个转
    func mapResponseToObj<T: Mapable>(_ type: T.Type) -> Observable<T?> {
        return map { representor in
            
            //检查是否是Moya.Response
            guard let response = representor as? Moya.Response else {
                throw XXError.XHNoMoyaResponse
            }

            //检查是否是一次成功的响应
            guard ((200...209) ~= response.statusCode) else {
                throw XXError.XHFailureHTTP
            }
            
            //将data转为JSON
            let json = try JSON.init(data: response.data)
            
            //判断是否有状态码
            if let code = json[RESULT_CODE].string {
                
                //判断返回的状态码是否与成功状态码一致
                if code == XXStatus.XHSuccess.rawValue {
                    //将数据结构中的数据包字段转为JSON传出
                    return self.resultToJSON(json[RESULT_DATA], ModelType: type)
                }else {
                    //状态码与成功状态码不一致的时候，返回提示信息
                    throw XXError.XHMsgError(statusCode: json[RESULT_CODE].string, errorMsg: json[RESULT_MSG].string)
                }
                
            }else {
                //报错非对象
                throw XXError.XHNotMakeObjectError
            }
            
        }
        
    }
    
    /// 数据为数组的用这个转
    func mapResponseToArray<T: Mapable>(_ type: T.Type) -> Observable<[T]> {
        return map { response in
            
            guard let response = response as? Moya.Response else {
                throw XXError.XHNoMoyaResponse
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw XXError.XHFailureHTTP
            }
            
            let json = try JSON.init(data: response.data)
            
            if let code = json[RESULT_CODE].string {
                if code == XXStatus.XHSuccess.rawValue {
                    //建立一个模型数组(T为泛型)
                    var objects = [T]()
                    //获取数据包字段中的数据用JSON转为Array类型
                    let objectsArrays = json[RESULT_DATA].array
                    
                    if let array = objectsArrays {
                        //遍历数组
                        for object in array {
                            //将对象转为模型加入数组
                            if let obj = self.resultToJSON(object, ModelType:type) {
                                objects.append(obj)
                            }
                        }
                        return objects
                    } else {
                        throw XXError.XHNoData
                    }
                    
                } else {
                    throw XXError.XHMsgError(statusCode: json[RESULT_CODE].string, errorMsg: json[RESULT_MSG].string)
                }
            } else {
                throw XXError.XHNotMakeObjectError
            }
            
        }
    }
}

enum XXStatus: String{
    case XHSuccess = "100"
}

enum XXError:Error {
    case XHNoMoyaResponse//不是一个Response
    case XHFailureHTTP//失败的网络请求
    case XHNoData//没有数据
    case XHNotMakeObjectError//非对象
    case XHMsgError(statusCode: String?, errorMsg: String?)//其余错误(例如表单验证错误，有错误提示)
}
