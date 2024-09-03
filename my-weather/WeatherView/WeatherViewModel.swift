//
//  WeatherViewModel.swift
//  my-weather
//
//  Created by 심관혁 on 8/25/24.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weathers: [WeatherModel] = []
    @Published var minTemperature: String = "-°"
    @Published var maxTemperature: String = "-°"
    @Published var isLoadingWeather: Bool = false
    var weather: WeatherModel = WeatherModel(
        dayOfWeek: "",
        fcstDate: "",
        fcstTime: "",
        temperature: "",
        windSpeedTransverse: "",
        windSpeedVertical: "",
        windDirection: "",
        windSpeed: "",
        sky: "",
        pop: "",
        pty: "",
        pcp: "",
        reh: "",
        sno: "",
        wav: "",
        temperatureMin: "",
        temperatureMax: "",
        weatherImage: ""
    )
    
    private var weatherService = WeatherService()
    private var locationManager = LocationManager.shared
    private var ltcManager = LTCManager.shared
    
    init() {
        let nxny = locationManager.sendLocation()
        let ltc = ltcManager.LTC(latitude: nxny[0], longitude: nxny[1])
        self.fetchWeather(nx: String(ltc.x), ny: String(ltc.y))
        self.getMinMaxTemperature(nx: String(ltc.x), ny: String(ltc.y))
    }
    
    func getMinMaxTemperature(nx: String, ny: String) {
        weatherService.getMinMaxTemperature(for: nx, ny: ny) { [weak self] weatherResponse in
            guard let self = self else { return }
            guard let items = weatherResponse?.response.body.items.item.filter({$0.category == "TMN" || $0.category == "TMX"}) else { return }
            let currentDate = getCurrentDate()
            for item in items {
                if item.category == "TMN" && item.fcstDate == currentDate { // 최저기온
                    let temp = Int(Double(item.fcstValue)!)
                    self.minTemperature = "\(String(describing: temp))°"
                }
                if item.category == "TMX" && item.fcstDate == currentDate { // 최고기온
                    let temp = Int(Double(item.fcstValue)!)
                    self.maxTemperature = "\(String(describing: temp))°"
                }
            }
        }
    }
    
    func fetchWeather(nx: String, ny: String) {
        isLoadingWeather = true
        weatherService.getWeather(for: nx, ny: ny) { [weak self] weatherResponse in
            guard let self = self else { return }
            guard let items = weatherResponse?.response.body.items.item else { return }
            let currentTime = getCurrentTime()
            for item in items {
                if currentTime > item.fcstTime && item.fcstDate == getCurrentDate() { continue }
                
                setWeather(weather: &weather, category: item.category, value: item.fcstValue)
                if item.category == "TMP" { // 날씨의 첫번째 카테고리
                    weather.fcstTime = timeChange(timeString: item.fcstTime)
                    weather.fcstDate = dateChange(dateString: item.fcstDate)
                    weather.dayOfWeek = dateOfWeek(dateString: item.fcstDate)
                } else if item.category == "SNO" { // 날씨의 마지막 카테고리
                    weather.weatherImage = setWeatherImage(skycode: weather.sky, ptyCode: weather.pty)
                    weathers.append(weather)
                    initWeather(weather: &weather)
                }
            }
            self.isLoadingWeather = false
        }
    }
    
    private func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH00"
        return dateFormatter.string(from: Date())
    }
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
    
    private func dateChange(dateString: String) -> String {
        // date = "20240902"
        // dateChange(date: "20240902") = 09/02
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateString) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MM/dd"
            dateFormatter2.locale = Locale(identifier: "ko_KR")
            return dateFormatter2.string(from: date)
        } else {
            return ""
        }
    }
    
    private func dateOfWeek(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        // 문자열을 날짜로 변환
        if let date = dateFormatter.date(from: dateString) {
            // 요일 추출 포맷 설정
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            dayFormatter.locale = Locale(identifier: "ko_KR")
            
            // 요일 반환
            return dayFormatter.string(from: date)
        } else {
            // 잘못된 날짜 형식일 경우 "" 반환
            return ""
        }
    }
    
    private func timeChange(timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let time = dateFormatter.date(from: timeString) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "a h시"
            dateFormatter2.locale = Locale(identifier: "ko_KR")
            return dateFormatter2.string(from: time)
        } else {
            return ""
        }
    }
    
    private func setWeatherImage(skycode: String, ptyCode: String) -> String {
        if ptyCode == "0" {
            switch skycode {
            case "1":
                return "sun.max.fill"
            case "3":
                return "smoke.fill"
            case "4":
                return "cloud.fill"
            default:
                return "sun.max.fill"
            }
        } else if ptyCode == "1" {
            switch skycode {
            case "1":
                return "sun.rain.fill"
            case "3":
                return "cloud.rain.fill"
            case "4":
                return "cloud.sun.rain.fill"
            default:
                return "cloud.sun.fill"
            }
        } else if ptyCode == "2" {
            switch skycode {
            case "1":
                return "sun.rain.fill"
            case "3":
                return "cloud.sleet.fill"
            case "4":
                return "cloud.sleet.fill"
            default:
                return "sun.rain.fill"
            }
        } else if ptyCode == "3" {
            switch skycode {
            case "1":
                return "sun.snow.fill"
            case "3":
                return "cloud.snow.fill"
            case "4":
                return "cloud.snow.fill"
            default:
                return "cloud.snow.fill"
            }
        } else {
            switch skycode {
            case "1":
                return "sun.rain.fill"
            case "3":
                return "cloud.drizzle.fill"
            case "4":
                return "cloud.drizzle.fill"
            default:
                return "cloud.drizzle.fill"
            }
        }
    }
    
    private func initWeather(weather: inout WeatherModel) { // weatherModel 초기화
        weather.dayOfWeek = "" // 요일
        weather.fcstDate = "" // 날짜
        weather.fcstTime = "" // 시간
        weather.temperature = "" // 기온
        weather.windSpeedTransverse = "" // 풍속(동서)
        weather.windSpeedVertical = "" // 풍속(남북)
        weather.windDirection = "" // 풍향
        weather.windSpeed = "" // 풍속
        weather.sky = "" // 하늘형태
        weather.pop = "" // 강수확률
        weather.pty = "" // 강수형태
        weather.pcp = "" // 1시간 강수량
        weather.reh = "" // 습도
        weather.sno = "" // 1시간 신적설
        weather.wav = "" // 파고
        weather.temperatureMin = "" // 일 최저 기온 - 0600시
        weather.temperatureMax = "" // 일 최고 기온 - 1500시
        weather.weatherImage = "" // 날씨 이미지
    }
    
    private func setWeather(weather: inout WeatherModel, category: String, value: String) {
        switch category {
        case "POP":
            weather.pop = value
        case "PTY":
            weather.pty = value
        case "PCP":
            weather.pcp = value
        case "REH":
            print("REH: \(value)")
            weather.reh = value
        case "SNO":
            weather.sno = value
        case "SKY":
            weather.sky = value
        case "TMP":
            weather.temperature = "\(value)°"
        case "TMN":
            weather.temperatureMin = "\(value)°"
        case "TMX":
            weather.temperatureMax = "\(value)°"
        case "UUU":
            weather.windSpeedTransverse = value
        case "VVV":
            weather.windSpeedVertical = value
        case "WAV":
            weather.wav = value
        case "VEC":
            weather.windDirection = value
        case "WSD":
            weather.windSpeed = value
        default:
            break
        }
    }
}
