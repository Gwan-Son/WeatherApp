# WeatherApp
기상청 공공데이터 단기예보 API를 활용해서 만든 날씨 앱
Alamofire를 사용하여 HTTP 통신 처리
Charts 라이브러리로 그래프 구현


## 목차
- [🚀 개발 기간](#-개발-기간)
- [💻 개발 환경](#-개발-환경)
- [🌤️ 기상청 단기예보 공공데이터 API](#-기상청-단기예보-공공데이터-api)
- [🛜 Alamofire로 HTTP 통신하기](#-alamofire로-http-통신하기)
- [📊 Charts 라이브러리 활용하기](#-charts-라이브러리-활용하기)
- [📁 파일 구조](#-파일-구조)

---

# 🚀 개발 기간
24.08.23 ~ 24.09.05 (약 2주)

# 💻 개발 환경
- `XCode 15.4`
- `Swift 5.9.2`

<p align="center" width="100%">
 <img src="https://github.com/user-attachments/assets/9fc04dfe-c006-4beb-a1f3-3a3d8ce31125" width="30%">
 <img src="https://github.com/user-attachments/assets/6287f13f-9438-4ba0-8b19-45810d85057f" width="30%">
 <img src="https://github.com/user-attachments/assets/194c48ec-c47c-4efe-9062-5f369d6d62ea" width="30%">
</p>

# 🌤️ 기상청 단기예보 공공데이터 API
날씨 정보를 받아오기 위해 공공데이터 포털에서 API를 발급받아 사용했습니다. API 키는 사용자가 볼 수 없어야하며, 깃허브 리포지토리에 public으로 올리게 되면 보안이 취약해집니다. 그래서 Xcode에서 Secrets.xcconfig를 생성하여 API 키를 저장하고 Bundle로 사용하였습니다.


```
//WeatherService.swift
let apiKey = Bundle.main.infoDictionary?["APIKey"] as! String
```

단기예보 오픈 API 사용설명서를 보면 Call Back URL과 요청메시지가 명시되어 있습니다. Postman을 사용하여 JSON 파일의 형태를 파악하고, WeatherResponse를 작성하였습니다.

```
//WeatherResponse.swift
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
```


# 🛜 Alamofire로 HTTP 통신하기
HTTP 통신을 활용하는 것은 이전 프로젝트에서도 사용했었습니다. 하지만 기존의 URLSession을 통해 HTTP 통신을 할 때는 과정이 번거로웠고, 코드의 길이가 길어질 수 밖에 없었습니다. 그러던 와중 Alamofire 라이브러리를 사용하면 간단한 코드를 작성하는 것만으로 HTTP 통신을 할 수 있다는 것을 알았습니다. 

Alamofire 라이브러리는 cocoaPods을 통해 설치하였습니다.

단기예보 API url과 필요한 파라미터를 작성하고, AF.request 명령어를 사용하여 데이터를 가져옵니다.

```
//WeatherService.swift
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
```

가져온 데이터는 WeatherViewModel에서 처리합니다. WeatherModel을 생성하여 각각의 카테고리에 맞는 값을 저장하고, 마지막 카테고리값인 "SNO"가 들어오면 배열에 저장합니다. 

날짜 및 시간은 구분하기 쉽게 DateFormatter를 사용하여 변경했습니다. 하늘형태와 강수형태에 따라 날씨 이미지를 처리해주었습니다.


```
//WeatherViewModel.swift
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
    filterTodayWeather()
    self.isLoadingWeather = false
}
```

# 📊 Charts 라이브러리 활용하기
단기예보 API에는 다양한 데이터가 존재합니다. 그 중 연관성이 있는 습도와 강수확률을 표시하였습니다. 차트는 Line과 Area를 사용하였고, Symbol을 추가하여 사용자에게 시각적으로 잘 보일 수 있도록 하였습니다.

WeatherViewModel에서 처리한 [WeatherModel] 배열의 fcstTime 값은 메인화면에서 직관적으로 보일 수 있게 "a h시"(ex.오후 1시)로 사용하였지만 차트에선 xAxis가 잘려보이는 문제가 있어 DateFormatter를 사용하여 "HH시" (ex. 13시)로 수정하였습니다.

```
//WeatherDetailView.swift
Chart {
    ForEach(weathers, id: \.id) {
        LineMark(
            x: .value("x", reverseTimeChange(timeString: $0.fcstTime)),
            y: .value("y", rehpop ? Int($0.reh)! : Int($0.pop)!))
    }
    .interpolationMethod(.cardinal)
    .symbol(by: .value(" ", " "))
    
    ForEach(weathers, id: \.id) {
        AreaMark(
            x: .value("x", reverseTimeChange(timeString: $0.fcstTime)),
            y: .value("y", rehpop ? Int($0.reh)! : Int($0.pop)!))
    }
    .interpolationMethod(.cardinal)
    .foregroundStyle(linearGradient)
    
    }
    .chartLegend(.hidden)
    .chartYAxis { AxisMarks(position: .leading, values: .automatic) }
    .aspectRatio(contentMode: .fit)
    .padding(.horizontal, 30)
```

# 📁 파일 구조
```
.
├── Podfile
├── Podfile.lock
├── Pods
│   ├── Alamofire
│   │   ├── LICENSE
│   │   ├── README.md
│   │   └── Source
│   │       ├── Alamofire.swift
│   │       ├── Core
│   │       │   ├── AFError.swift
│   │       │   ├── DataRequest.swift
│   │       │   ├── DataStreamRequest.swift
│   │       │   ├── DownloadRequest.swift
│   │       │   ├── HTTPHeaders.swift
│   │       │   ├── HTTPMethod.swift
│   │       │   ├── Notifications.swift
│   │       │   ├── ParameterEncoder.swift
│   │       │   ├── ParameterEncoding.swift
│   │       │   ├── Protected.swift
│   │       │   ├── Request.swift
│   │       │   ├── RequestTaskMap.swift
│   │       │   ├── Response.swift
│   │       │   ├── Session.swift
│   │       │   ├── SessionDelegate.swift
│   │       │   ├── URLConvertible+URLRequestConvertible.swift
│   │       │   ├── UploadRequest.swift
│   │       │   └── WebSocketRequest.swift
│   │       ├── Extensions
│   │       │   ├── DispatchQueue+Alamofire.swift
│   │       │   ├── OperationQueue+Alamofire.swift
│   │       │   ├── Result+Alamofire.swift
│   │       │   ├── StringEncoding+Alamofire.swift
│   │       │   ├── URLRequest+Alamofire.swift
│   │       │   └── URLSessionConfiguration+Alamofire.swift
│   │       ├── Features
│   │       │   ├── AlamofireExtended.swift
│   │       │   ├── AuthenticationInterceptor.swift
│   │       │   ├── CachedResponseHandler.swift
│   │       │   ├── Combine.swift
│   │       │   ├── Concurrency.swift
│   │       │   ├── EventMonitor.swift
│   │       │   ├── MultipartFormData.swift
│   │       │   ├── MultipartUpload.swift
│   │       │   ├── NetworkReachabilityManager.swift
│   │       │   ├── RedirectHandler.swift
│   │       │   ├── RequestCompression.swift
│   │       │   ├── RequestInterceptor.swift
│   │       │   ├── ResponseSerialization.swift
│   │       │   ├── RetryPolicy.swift
│   │       │   ├── ServerTrustEvaluation.swift
│   │       │   ├── URLEncodedFormEncoder.swift
│   │       │   └── Validation.swift
│   │       └── PrivacyInfo.xcprivacy
│   ├── Headers
│   ├── Local Podspecs
│   ├── Manifest.lock
│   ├── Pods.xcodeproj
│   │   ├── project.pbxproj
│   │   └── xcuserdata
│   │       └── simgwanhyeok.xcuserdatad
│   │           └── xcschemes
│   │               ├── Alamofire-Alamofire.xcscheme
│   │               ├── Alamofire.xcscheme
│   │               ├── Pods-my-weather-my-weatherUITests.xcscheme
│   │               ├── Pods-my-weather.xcscheme
│   │               ├── Pods-my-weatherTests.xcscheme
│   │               └── xcschememanagement.plist
│   └── Target Support Files
│       ├── Alamofire
│       │   ├── Alamofire-Info.plist
│       │   ├── Alamofire-dummy.m
│       │   ├── Alamofire-prefix.pch
│       │   ├── Alamofire-umbrella.h
│       │   ├── Alamofire.debug.xcconfig
│       │   ├── Alamofire.modulemap
│       │   ├── Alamofire.release.xcconfig
│       │   └── ResourceBundle-Alamofire-Alamofire-Info.plist
│       ├── Pods-my-weather
│       │   ├── Pods-my-weather-Info.plist
│       │   ├── Pods-my-weather-acknowledgements.markdown
│       │   ├── Pods-my-weather-acknowledgements.plist
│       │   ├── Pods-my-weather-dummy.m
│       │   ├── Pods-my-weather-frameworks-Debug-input-files.xcfilelist
│       │   ├── Pods-my-weather-frameworks-Debug-output-files.xcfilelist
│       │   ├── Pods-my-weather-frameworks-Release-input-files.xcfilelist
│       │   ├── Pods-my-weather-frameworks-Release-output-files.xcfilelist
│       │   ├── Pods-my-weather-frameworks.sh
│       │   ├── Pods-my-weather-umbrella.h
│       │   ├── Pods-my-weather.debug.xcconfig
│       │   ├── Pods-my-weather.modulemap
│       │   └── Pods-my-weather.release.xcconfig
│       ├── Pods-my-weather-my-weatherUITests
│       │   ├── Pods-my-weather-my-weatherUITests-Info.plist
│       │   ├── Pods-my-weather-my-weatherUITests-acknowledgements.markdown
│       │   ├── Pods-my-weather-my-weatherUITests-acknowledgements.plist
│       │   ├── Pods-my-weather-my-weatherUITests-dummy.m
│       │   ├── Pods-my-weather-my-weatherUITests-frameworks-Debug-input-files.xcfilelist
│       │   ├── Pods-my-weather-my-weatherUITests-frameworks-Debug-output-files.xcfilelist
│       │   ├── Pods-my-weather-my-weatherUITests-frameworks-Release-input-files.xcfilelist
│       │   ├── Pods-my-weather-my-weatherUITests-frameworks-Release-output-files.xcfilelist
│       │   ├── Pods-my-weather-my-weatherUITests-frameworks.sh
│       │   ├── Pods-my-weather-my-weatherUITests-umbrella.h
│       │   ├── Pods-my-weather-my-weatherUITests.debug.xcconfig
│       │   ├── Pods-my-weather-my-weatherUITests.modulemap
│       │   └── Pods-my-weather-my-weatherUITests.release.xcconfig
│       └── Pods-my-weatherTests
│           ├── Pods-my-weatherTests-Info.plist
│           ├── Pods-my-weatherTests-acknowledgements.markdown
│           ├── Pods-my-weatherTests-acknowledgements.plist
│           ├── Pods-my-weatherTests-dummy.m
│           ├── Pods-my-weatherTests-umbrella.h
│           ├── Pods-my-weatherTests.debug.xcconfig
│           ├── Pods-my-weatherTests.modulemap
│           └── Pods-my-weatherTests.release.xcconfig
├── README.md
├── my-weather
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── Info.plist
│   ├── Manager
│   │   ├── LTCManager.swift
│   │   └── LocationManager.swift
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   │       └── Contents.json
│   ├── Secrets.xcconfig
│   ├── WeatherResponse.swift
│   ├── WeatherService.swift
│   ├── WeatherView
│   │   ├── WeatherDetailView.swift
│   │   ├── WeatherModel.swift
│   │   ├── WeatherView.swift
│   │   └── WeatherViewModel.swift
│   └── my_weatherApp.swift
├── my-weather.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   └── swiftpm
│   │   │       └── configuration
│   │   └── xcuserdata
│   │       └── simgwanhyeok.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   ├── xcshareddata
│   │   └── xcschemes
│   │       └── my-weather.xcscheme
│   └── xcuserdata
│       └── simgwanhyeok.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── my-weather.xcworkspace
│   ├── contents.xcworkspacedata
│   ├── xcshareddata
│   │   ├── IDEWorkspaceChecks.plist
│   │   └── swiftpm
│   │       └── configuration
│   └── xcuserdata
│       └── simgwanhyeok.xcuserdatad
│           └── UserInterfaceState.xcuserstate
├── my-weatherTests
│   └── my_weatherTests.swift
└── my-weatherUITests
    ├── my_weatherUITests.swift
    └── my_weatherUITestsLaunchTests.swift

46 directories, 125 files
```
