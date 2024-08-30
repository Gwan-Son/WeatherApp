//
//  WeatherViewModel.swift
//  my-weather
//
//  Created by 심관혁 on 8/25/24.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var description: String = "sun.max.fill"
    var skyCode: Int = 0
    var ptyCode: Int = 0
    
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
                    self.ptyCode = self.parsePTY(value: item.fcstValue)
                } else if item.category == "SKY" {
                    self.skyCode = self.parseSKY(value: item.fcstValue)
                }
            }

            DispatchQueue.main.async {
                self.description = self.setWeatherImage(skycode: self.skyCode, ptyCode: self.ptyCode)
            }
        }
    }
    
    private func parsePTY(value: String) -> Int {
        switch value {
        case "0":
            return 0
        case "1":
            return 1
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        default:
            return -1
        }
    }
    
    private func parseSKY(value: String) -> Int {
        switch value {
        case "1":
            return 1
        case "3":
            return 3
        case "4":
            return 4
        default:
            return -1
        }
    }
    
    private func setWeatherImage(skycode: Int, ptyCode: Int) -> String {
        if ptyCode == 0 {
            switch skycode {
            case 1:
                return "sun.max.fill"
            case 3:
                return "smoke.fill"
            case 4:
                return "cloud.fill"
            default:
                return "sun.max.fill"
            }
        } else if ptyCode == 1 {
            switch skycode {
            case 1:
                return "sun.rain.fill"
            case 3:
                return "cloud.rain.fill"
            case 4:
                return "cloud.sun.rain.fill"
            default:
                return "cloud.sun.fill"
            }
        } else if ptyCode == 2 {
            switch skycode {
            case 1:
                return "sun.rain.fill"
            case 3:
                return "cloud.sleet.fill"
            case 4:
                return "cloud.sleet.fill"
            default:
                return "sun.rain.fill"
            }
        } else if ptyCode == 3 {
            switch skycode {
            case 1:
                return "sun.snow.fill"
            case 3:
                return "cloud.snow.fill"
            case 4:
                return "cloud.snow.fill"
            default:
                return "cloud.snow.fill"
            }
        } else {
            switch skycode {
            case 1:
                return "sun.rain.fill"
            case 3:
                return "cloud.drizzle.fill"
            case 4:
                return "cloud.drizzle.fill"
            default:
                return "cloud.drizzle.fill"
            }
        }
    }
}
