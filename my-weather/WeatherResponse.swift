//
//  WeatherResponse.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import Foundation

struct WeatherResponse: Codable {
    let response: ResponseBody
}

struct ResponseBody: Codable {
    let body: ResponseBodyItems
}

struct ResponseBodyItems: Codable {
    let items: ResponseItems
}

struct ResponseItems: Codable {
    let item: [WeatherItem]
}

struct WeatherItem: Codable {
    let category: String // PTY(강수형태), T3H(3시간 기온)
    let fcstValue: String // 예보 값
    let fcstTime: String // 예보 시각
}
