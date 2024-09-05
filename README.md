# WeatherApp
기상청 공공데이터 단기예보 API를 활용해서 만든 날씨 앱
Alamofire를 사용하여 HTTP 통신 처리
Charts 라이브러리로 그래프 구현


## 목차
- [🚀 개발 기간](#-개발-기간)
- [💻 개발 환경](#-개발-환경)
- [🌤️ 기상청 단기예보 공공데이터 API](#-기상청-단기예보-공공데이터-api)
- [🛜 Alamofire로 HTTP 통신하기](#-alamofire로-http-통신하기)
- [📊Charts 라이브러리 활용하기](#-charts-라이브러리-활용하기)
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


# 🛜 Alamofire로 HTTP 통신하기


# 📊 Charts 라이브러리 활용하기


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
