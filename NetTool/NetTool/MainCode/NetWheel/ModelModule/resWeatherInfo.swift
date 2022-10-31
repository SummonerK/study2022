//
//  File.swift
//  NetTool
//
//  Created by luoke_ios on 2022/9/30.
//

import Foundation
import ObjectMapper

struct resWeatherInfo: Mappable {
    var count: String?
    var info: String?
    var infocode: String?
    var lives = [Lives]()
    var status: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        count    <- map["count"]
        info     <- map["info"]
        infocode <- map["infocode"]
        lives    <- map["lives"]
        status   <- map["status"]
    }
}

struct Lives: Mappable {
    var adcode: String?
    var city: String?
    var humidity: String?
    var province: String?
    var reporttime: String?
    var temperature: String?
    var weather: String?
    var winddirection: String?
    var windpower: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        adcode        <- map["adcode"]
        city          <- map["city"]
        humidity      <- map["humidity"]
        province      <- map["province"]
        reporttime    <- map["reporttime"]
        temperature   <- map["temperature"]
        weather       <- map["weather"]
        winddirection <- map["winddirection"]
        windpower     <- map["windpower"]
    }
}

