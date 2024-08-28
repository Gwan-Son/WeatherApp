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
    var map = lamc_params(
        Re: 6371.00877,
        grid: 5.0,
        slat1: 30.0,
        slat2: 60.0,
        olon: 126.0,
        olat: 38.0,
        xo: 210.0 / 5.0,
        yo: 675.0 / 5.0,
        first: 0
    )
    
    init() {
        
    }
    
    func LTC(longitude: String, latitude: String) -> [String] {
        lon = Float(longitude) ?? 0.0
        lat = Float(latitude) ?? 0.0
        mapConv(lon: &lon, lat: &lat, x: &x, y: &y, map: &map)
        return [x.description, y.description]
    }
    
    // 좌표 변환
    func mapConv(lon: inout Float, lat: inout Float, x: inout Float, y: inout Float, map: inout lamc_params) {
        var lon1: Float = 0.0
        var lat1: Float = 0.0
        var x1: Float = 0.0
        var y1: Float = 0.0
        
        lon1 = lon
        lat1 = lat
        lamcproj(lon: &lon1, lat: &lat1, x: &x1, y: &y1, map: &map)
        x = Float(Int(x1 + 1.5))
        y = Float(Int(y1 + 1.5))
    }
    
    func lamcproj(lon: inout Float, lat: inout Float, x: inout Float, y: inout Float, map: inout lamc_params) {
        struct StaticVars {
            static var PI: Double = 0.0
            static var DEGRAD: Double = 0.0
            static var RADDEG: Double = 0.0
            static var re: Double = 0.0
            static var olon: Double = 0.0
            static var olat: Double = 0.0
            static var sn: Double = 0.0
            static var sf: Double = 0.0
            static var ro: Double = 0.0
        }
        
        var slat1: Double
        var slat2: Double
        var ra: Double
        var theta: Double
        
        if map.first == 0 {
            StaticVars.PI = Double.pi
            StaticVars.DEGRAD = StaticVars.PI / 180.0
            StaticVars.RADDEG = 180.0 / StaticVars.PI
            
            StaticVars.re = Double(map.Re / map.grid)
            slat1 = Double(map.slat1) * StaticVars.DEGRAD
            slat2 = Double(map.slat2) * StaticVars.DEGRAD
            StaticVars.olon = Double(map.olon) * StaticVars.DEGRAD
            StaticVars.olat = Double(map.olat) * StaticVars.DEGRAD
            
            StaticVars.sn = tan(StaticVars.PI * 0.25 + slat2 * 0.5) / tan(StaticVars.PI * 0.25 + slat1 * 0.5)
            StaticVars.sn = log(cos(slat1) / cos(slat2)) / log(StaticVars.sn)
            StaticVars.sf = tan(StaticVars.PI * 0.25 + slat1 * 0.5)
            StaticVars.sf = pow(StaticVars.sf, StaticVars.sn) * cos(slat1) / StaticVars.sn
            StaticVars.ro = tan(StaticVars.PI * 0.25 + StaticVars.olat * 0.5)
            StaticVars.ro = StaticVars.re * StaticVars.sf / pow(StaticVars.ro, StaticVars.sn)
            
            map.first = 1
        }
        
        ra = tan(StaticVars.PI * 0.25 + Double(lat) * StaticVars.DEGRAD * 0.5)
        ra = StaticVars.re * StaticVars.sf / pow(ra, StaticVars.sn)
        theta = Double(lon) * StaticVars.DEGRAD - StaticVars.olon
        if theta > StaticVars.PI { theta -= 2.0 * StaticVars.PI }
        if theta < -StaticVars.PI { theta += 2.0 * StaticVars.PI }
        theta *= StaticVars.sn
        x = Float(ra * sin(theta)) + map.xo
        y = Float(StaticVars.ro - ra * cos(theta)) + map.yo
    }
    
}

struct lamc_params {
    var Re: Float // 사용할 지구반경 [km]
    var grid: Float // 격자간격 [km]
    var slat1: Float //표준위도 [degree]
    var slat2: Float // 표준위도 [degree]
    var olon: Float // 기준점의 경도 [degree]
    var olat: Float // 기준점의 위도 [degree]
    var xo: Float // 기준점의 X좌표 [격자거리]
    var yo: Float // 기준점의 Y좌표 [격자거리]
    var first: Int // 시작여부 (0 = 시작)
}
