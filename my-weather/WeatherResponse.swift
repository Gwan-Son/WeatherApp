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
    let baseDate, baseTime, category, fcstDate: String
    let fcstTime, fcstValue: String
    let nx, ny: Int
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
