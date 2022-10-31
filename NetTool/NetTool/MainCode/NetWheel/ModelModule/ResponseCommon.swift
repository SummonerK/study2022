//
//  ResponseCommon.swift
//  NetTool
//
//  Created by luoke_ios on 2022/9/30.
//

import ObjectMapper
struct ResponseCommon<T:Mappable>:Mappable,Error{
    var code : Int = 0               //状态码
    var message: String = ""         //消息
    var resp:T?                      //数据

    init?(map: Map) {}

    init(code:Int = 0,message:String,resp:T?) {
        self.code = code
        self.message = message
        self.resp = resp
    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["msg"]
        resp <- map["resp"]
    }
}

struct CommonData:Mappable {
    init?(map: Map) {}
    mutating func mapping(map: Map) {
    }
}
