//
//  WeatherModel.swift
//  my-weather
//
//  Created by 심관혁 on 9/2/24.
//

import Foundation

struct WeatherModel: Identifiable {
    var id: String {
        return fcstDate+dayOfWeek+fcstTime
    }
    var dayOfWeek: String // 요일
    var fcstDate: String // 날짜
    var fcstTime: String // 시간
    var temperature: String // 기온
    var windSpeedTransverse: String // 풍속(동서)
    var windSpeedVertical: String // 풍속(남북)
    var windDirection: String // 풍향
    var windSpeed: String // 풍속
    var sky: String // 하늘형태
    var pop: String // 강수확률
    var pty: String // 강수형태
    var pcp: String // 1시간 강수량
    var reh: String // 습도
    var sno: String // 1시간 신적설
    var wav: String // 파고
    var temperatureMin: String // 일 최저 기온 - 0600시
    var temperatureMax: String // 일 최고 기온 - 1500시
    var weatherImage: String // 날씨 이미지
}
