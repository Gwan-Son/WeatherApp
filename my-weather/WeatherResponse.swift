//
//  WeatherResponse.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//  https://app.quicktype.io/ - JSON to swift

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let category: String // SKY: 하늘형태, POP: 강수확률, PTY: 강수형태, REH: 습도, TMP: 1시간 기온, TMN: 일 최저기온, TMX: 일 최고기온, WSD: 풍속
    let baseDate, baseTime, fcstDate: String
    let fcstTime, fcstValue: String
    let nx, ny: Int
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
