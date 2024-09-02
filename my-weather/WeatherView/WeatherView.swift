//
//  ContentView.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @State var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            BackgroundView(topColor: .blue, bottomColor: .purple)
            VStack {
                CityTextView(cityName: locationManager.locationName)
                WeatherStatusView(imageName: viewModel.weathers.first?.weatherImage ?? "sun.max.fill" , temperature: viewModel.weathers.first?.temperature ?? "-°", minTemp: viewModel.minTemperature, maxTemp: viewModel.maxTemperature)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.weathers) { weather in
                            
                            WeatherDayView(time: weather.fcstTime, imageName: weather.weatherImage, temperature: weather.temperature)
                        }
//                        WeatherDayView(time: "오후 1시", imageName: "cloud.fill", temperature: "25°C")
//                        WeatherDayView(time: "오후 2시", imageName: "cloud.fill", temperature: "25°C")
//                        WeatherDayView(time: "오후 3시", imageName: "cloud.fill", temperature: "25°C")
//                        WeatherDayView(time: "오후 4시", imageName: "cloud.fill", temperature: "25°C")
//                        WeatherDayView(time: "오후 5시", imageName: "cloud.fill", temperature: "25°C")
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .task {
            await locationManager.checkUserDeviceLocationServiceAuthorization()
        }
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
