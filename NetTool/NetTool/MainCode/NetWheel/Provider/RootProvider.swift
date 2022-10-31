//
//  RootProvider.swift
//  NetTool
//
//  Created by luoke_ios on 2022/9/30.
//

import Moya
import ObjectMapper
import RxSwift
import Result

let shouldShowLog = true  //是否打印日志

private let defualtProvider = RootProvider(endpointClosure: myEndpointClosure,
                                 requestClosure: requestClosure,
                                 stubClosure: MoyaProvider.neverStub,
                                 callbackQueue: DispatchQueue.main,
                                 plugins: [networkLoggerPlugin],
                                 trackInflights: false)

private let netProvider = RootProvider(callbackQueue: DispatchQueue.main,
                               plugins: [netLogger],
                               trackInflights: false)

enum NetPrividerType {
    case system
    case Normal
}

func Privider(withType netType:NetPrividerType = .system) -> RootProvider {
    switch netType{
    case .Normal:
        return netProvider
    case .system:
        return defualtProvider
    }
}

//func Privider(withType netType:NetPrividerType = .system) -> ( () -> RootProvider) {
//    func systemPrivider () ->RootProvider{
//        return defualtProvider
//    }
//    func normalPrivider () ->RootProvider{
//        return netProvider
//    }
//    var myFunc: () -> RootProvider
//
//    switch netType{
//    case .Normal:
//        myFunc = normalPrivider
//    case .system:
//        myFunc = systemPrivider
//    }
//
//    return myFunc
//}


class RootProvider:MoyaProvider<MultiTarget>{
    let disposeBag:DisposeBag = DisposeBag()
    var needResendTarget: MultiTarget?
}

extension RootProvider{
    func request<T:Mappable,U:TargetType>(target:U) -> Single<T> {
        return self.rx.request(target as! MultiTarget)
            .filterSuccessfulStatusCodes()
            .filterSuccess(target: target as! MultiTarget, disposeBag: disposeBag)
            .mapObj(T.self)
    }
}


// MARK: - 设置请求头
private let myEndpointClosure = { (target: MultiTarget) -> Endpoint in
    //处理URL
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString

    let endpoint = Endpoint(url: url,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers
    )

    do {
        //设置通用header
        var urlRequest = try endpoint.urlRequest()
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
    } catch let error  {
        print(error)
    }
    return endpoint.adding(newHTTPHeaderFields: [ "Content-Type" : "application/json",])

}

// MARK: - 设置请求超时时间
private let requestClosure = { (endpoint: Endpoint, closure: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 12
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}

// MARK: - 调试plugin

//private let networkLoggerPlugin = NetworkLoggerPlugin(configuration:NetworkLoggerPlugin.Configuration(output:reversedPrint, logOptions:.verbose))
private let networkLoggerPlugin = NetworkLoggerPlugin(verbose:true)
private let netLogger = IBNetWorkPlugin()


func reversedPrint(target: TargetType, items: [String]) {
    #if DEBUG
    guard shouldShowLog else { return }
    for item in items {
        print(item, separator: ",", terminator: "\n")
    }
    #endif
}


public final class netWorkLogger: PluginType {

    public func willSend(_ request: RequestType, target: TargetType) {
        print("请求接口 : \(request.request?.url?.absoluteString ?? "")")
    }
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        print("***************************Result*************************")
        print("requestURL:\n \(target.baseURL.absoluteString + target.path)")
        if case .requestParameters(let parameters, _) = target.task {
            print("参数:\n \(parameters)")
        }
        switch result {
        case let .success(response):
            print("***************************----> 请求成功 <----***************************")
            do {
                #if DEBUG
                    let dict = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    print("请求地址:\(target.baseURL.absoluteString + target.path)")
                    print("请求结果:\(dict ?? [:])")
                #endif
            } catch {
                print("----> 解析失败:\(error.localizedDescription) <-----")
            }
        case let .failure(error):
            print("***************************----> 请求失败 <-----***************************")
            print(error.localizedDescription)
            print("***************************End*************************")
        }
        debugPrint()
    }
}
