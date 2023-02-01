//
//  ProviderSetting.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/21.
//

import Foundation
import Moya
//import Result

public final class IBNetWorkPlugin: PluginType{
    public func willSend(_ request: RequestType, target: TargetType) {
        print("开始请求了")
    }
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("请求结束了")
    }
}
