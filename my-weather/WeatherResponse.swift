//
//  WeatherResponse.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}
