//
//  reqMHome.swift
//  NetTool
//
//  Created by luoke_ios on 2022/8/15.
//

import Foundation
import ObjectMapper

class homeModel: Mappable {
    
    var organizationsURL: String?
    var receivedEventsURL: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        organizationsURL <- map["organizationsURL"]
        receivedEventsURL <- map["receivedEventsURL"]
    }

}

struct loginModel: Mappable {
    var organizationsURL: String?
    var receivedEventsURL: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        organizationsURL <- map["organizationsURL"]
        receivedEventsURL <- map["receivedEventsURL"]
    }
}
