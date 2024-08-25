//
//  WeatherService.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import Alamofire

class WeatherService {
    let apiKey = "ZLXSIs%2F6T3udLlgXrsOuMCfzqlqzkVMXnahTmkqvxPbjuT0HwGt7HcSGY8JCdI%2F4vpkpu6RhdUHnRuwNWusjiA%3D%3D"
    
    func getWeather(for nx: String, ny: String, completion: @escaping (WeatherResponse?) -> Void) {
        let url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        
        let params = [
            "serviceKey": apiKey,
            "pageNo": "1",
            "numOfRows": "1000",
            "dataType": "JSON",
            "base_date": getCurrentDate(),
            "base_time": "0500",
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, parameters: params).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
}
