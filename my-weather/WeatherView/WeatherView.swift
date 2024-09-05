//
//  ContentView.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import SwiftUI
import Combine

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var locationManager = LocationManager.shared
    @State private var showContent = false
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ZStack {
            if showContent {
                ZStack {
                    BackgroundView(topColor: .blue, bottomColor: .yellow)
                    VStack {
                        CityTextView(cityName: locationManager.locationName)
                        WeatherStatusView(imageName: viewModel.weathers.first?.weatherImage ?? "sun.max.fill" , temperature: viewModel.weathers.first?.temperature ?? "-°", minTemp: viewModel.minTemperature, maxTemp: viewModel.maxTemperature)
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .padding(.horizontal, 20)
                                .frame(height: 150)
                                .foregroundColor(.black)
                                .opacity(0.2)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.weathers) { weather in
                                        
                                        WeatherDayView(time: weather.fcstTime, imageName: weather.weatherImage, temperature: weather.temperature)
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        HStack(spacing: 10) {
                            Button {
                                viewModel.isRehPop = true
                                viewModel.isShowingDetail.toggle()
                            } label: {
                                WeatherSubView(description: "습도", percent: viewModel.weathers.first?.reh ?? "--", leftOrRight: true)
                            }
                            .sheet(isPresented: $viewModel.isShowingDetail, content: {
                                WeatherDetailView(weathers: $viewModel.todayWeahters, rehpop: $viewModel.isRehPop)
                            })

                            Button {
                                viewModel.isRehPop = false
                                viewModel.isShowingDetail.toggle()
                            } label: {
                                WeatherSubView(description: "강수확률", percent: viewModel.weathers.first?.pop ?? "--", leftOrRight: false)
                            }
                            .sheet(isPresented: $viewModel.isShowingDetail, content: {
                                WeatherDetailView(weathers: $viewModel.todayWeahters, rehpop: $viewModel.isRehPop)
                            })
                        }
                        
                        Spacer()
                    }
                }
                .transition(.opacity)
            }
            else {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .task {
            await locationManager.checkUserDeviceLocationServiceAuthorization()
            bindLoadingState()
        }
    }
    
    private func bindLoadingState() {
        viewModel.$isLoadingWeather
            .dropFirst()
            .removeDuplicates()
            .filter{ !$0 }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    showContent = true
                }
            }
            .store(in: &cancellables)
    }
}

#Preview {
    WeatherView()
}

struct WeatherDayView: View {
    
    var time: String
    var imageName: String
    var temperature: String
    
    var body: some View {
        VStack {
            Text(time)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(temperature)
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    var topColor: Color
    var bottomColor: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct WeatherStatusView: View {
    var imageName: String
    var temperature: String
    var minTemp: String
    var maxTemp: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
            
            Text(temperature)
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                Text("최고:\(maxTemp)")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                Text("최저:\(minTemp)")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 40)
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            BackgroundView(topColor: .blue, bottomColor: .yellow)
            VStack(alignment: .center, spacing: 10) {
                ProgressView()
                Text("날씨를 가져오는 중입니다...")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct WeatherSubView: View {
    var description: String
    var percent: String
    var leftOrRight: Bool // t - left
    var imageName: String {
        switch description {
        case "습도":
            return "humidity.fill"
        case "강수확률":
            return "drop.fill"
        default:
            return "drop.fill"
        }
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .padding(leftOrRight ? .leading : .trailing, 20)
                .frame(height: 150)
                .foregroundColor(.black)
                .opacity(0.2)
            
            VStack() {
                Spacer()
                HStack() {
                    Image(systemName: imageName)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                    Text("\(description)")
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(.top, -40)
                .padding(.leading, 10)
                
                Text("\(percent)%")
                    .font(.system(size: 32))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(leftOrRight ? .leading : .trailing, leftOrRight ? 20 : 10)
        }
    }
}
