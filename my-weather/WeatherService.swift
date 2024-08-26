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
            "numOfRows": "60",
            "pageNo": "1",
            "dataType": "JSON",
            "base_date": getCurrentDate(),
            "base_time": "0500", // TODO: - 현재 시각별로 계산하는 dateFomatter 추가해야함
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, method: .get, parameters: params as Parameters, encoding: URLEncoding.default)
            .responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let response):
                print(response.response.body.items.item)
//                completion(value)
            case .failure(let error):
                print(error)
//                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
}
