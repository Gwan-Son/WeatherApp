//
//  WeatherViewModel.swift
//  my-weather
//
//  Created by 심관혁 on 8/25/24.
//

import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var description: String = "--"
    
    private var weatherService = WeatherService()
    private var locationManager = LocationManager.shared
    private var ltcManager = LTCManager.shared
    
    init() {
        let nxny = locationManager.sendLocation()
        let ltc = ltcManager.LTC(latitude: nxny[0], longitude: nxny[1])
        self.fetchWeather(nx: String(ltc.x), ny: String(ltc.y))
    }
    
    func fetchWeather(nx: String, ny: String) {
        weatherService.getWeather(for: nx, ny: ny) { [weak self] weatherResponse in
            guard let self = self else { return }
            guard let items = weatherResponse?.response.body.items.item else { return }
            
            for item in items {
                if item.category == "TMP" {
                    self.temperature = "\(item.fcstValue)°C"
                } else if item.category == "PTY" {
                    self.description = self.parsePTY(value: item.fcstValue)
                }
            }
            print("완료")
        }
    }
    
    private func parsePTY(value: String) -> String {
        switch value {
        case "0":
            return "맑음"
        case "1":
            return "비"
        case "2":
            return "비/눈"
        case "3":
            return "눈"
        case "4":
            return "소나기"
        default:
            return "알 수 없음"
        }
    }
    
    private func parseSKY(value: String) -> String {
        switch value {
        case "1":
            return "맑음"
        case "3":
            return "구름많음"
        case "4":
            return "흐림"
        default:
            return "알 수 없음"
        }
    }
}
