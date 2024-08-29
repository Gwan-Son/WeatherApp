//
//  LTCManager.swift
//  my-weather
//
//  Created by 심관혁 on 8/28/24.
//

import Foundation

class LTCManager {
    static let NX = 149
    static let NY = 253
    
    static let shared = LTCManager()

    var lon: Float = 0.0
    var lat: Float = 0.0
    var x: Float = 0.0
    var y: Float = 0.0
    
    init() {
        
    }
    func LTC(latitude: String, longitude: String) -> LatXLngY {
        let RE = 6371.00877
        let GRID = 5.0
        let SLAT1 = 30.0
        let SLAT2 = 60.0
        let OLON = 126.0
        let OLAT = 38.0
        let XO: Double = 43
        let YO: Double = 136
        
        let DEGRAD = Double.pi / 180.0
        
        let re = RE / GRID
        let slat1 = SLAT1 * DEGRAD
        let slat2 = SLAT2 * DEGRAD
        let olon = OLON * DEGRAD
        let olat = OLAT * DEGRAD
        
        let lat_X = Double(latitude) ?? 0.0
        let lng_Y = Double(longitude) ?? 0.0
        
        var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        var ro = tan(Double.pi * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        var rs = LatXLngY(x: 0, y: 0)
        var ra = tan(Double.pi * 0.25 + (lat_X) * DEGRAD * 0.5)

        ra = re * sf / pow(ra, sn)
        var theta = lng_Y * DEGRAD - olon
        if theta > Double.pi {
            theta -= 2.0 * Double.pi
        }
        if theta < -Double.pi {
            theta += 2.0 * Double.pi
        }
        
        theta *= sn
        rs.x = Int(floor(ra * sin(theta) + XO + 0.5))
        rs.y = Int(floor(ro - ra * cos(theta) + YO + 0.5))
        
        return rs
    }
    
}

struct LatXLngY {
    public var x: Int
    public var y: Int
}
