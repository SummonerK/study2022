//
//  NetApi.swift
//  NetTool
//
//  Created by luoke_ios on 2022/9/30.
//

import Moya

public enum NetApi{
    case getWeatherInfo(city:String)
}
extension NetApi:TargetType{
    public var baseURL: URL {
        return URL(string: "https://go.apipost.cn/")!
    }

    public var path: String {
        switch self {
        case .getWeatherInfo:
            return ""
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getWeatherInfo(let city):
            return ["cityId":city]
        }
    }

    public var task: Task {
        switch self.method {
        case .get:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.queryString)
        default:
            return .requestCompositeParameters(bodyParameters: parameters!, bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }

    public var headers: [String : String]? {
        switch self {
        case .getWeatherInfo:
            return [:]
        }
    }


}
