//
//  WeatherService.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import Alamofire

class WeatherService {
    let apiKey = Bundle.main.infoDictionary?["APIKey"] as! String
    
    func getWeather(for nx: String, ny: String, completion: @escaping (WeatherResponse?) -> Void) {
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        
        let params: [String: String] = [
            "serviceKey": apiKey,
            "numOfRows": "1000",
            "pageNo": "1",
            "dataType": "JSON",
            "base_date": getCurrentDate(),
            "base_time": getCurrentTime(),
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, method: .get, parameters: params as Parameters, encoding: URLEncoding.default)
            .responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMinMaxTemperature(for nx: String, ny: String, completion: @escaping (WeatherResponse?) -> Void) {
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        
        let params: [String: String] = [
            "serviceKey": apiKey,
            "numOfRows": "158",
            "pageNo": "1",
            "dataType": "JSON",
            "base_date": getCurrentDate(),
            "base_time": "0200",
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, method: .get, parameters: params as Parameters, encoding: URLEncoding.default)
            .responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
    
    // 단기예보는 0200,0500,0800,1100,1400,1700,2000,2300(1일 8회)
    private func getCurrentTime() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        let currentTime = timeFormatter.string(from: Date())
        switch Int(currentTime)! {
        case 23:
            return "2300"
        case 20..<23:
            return "2000"
        case 17..<20:
            return "1700"
        case 14..<17:
            return "1400"
        case 11..<14:
            return "1100"
        case 8..<11:
            return "0800"
        case 5..<8:
            return "0500"
        default:
            return "0200"
        }
    }
}
