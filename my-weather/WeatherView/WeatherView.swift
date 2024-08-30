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
                CityTextView(cityName: "서울특별시 도봉구")
                WeatherStatusView(imageName: viewModel.description, temperature: viewModel.temperature)
                
                
                HStack(spacing: 20) {
                    WeatherDayView(dayOfWeek: "TUE", imageName: "cloud.sun.fill", temperature: 38)
                    WeatherDayView(dayOfWeek: "WED", imageName: "sun.max.fill", temperature: 42)
                    WeatherDayView(dayOfWeek: "THU", imageName: "cloud.sun.bolt.fill", temperature: 32)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "cloud.rain.fill", temperature: 30)
                    WeatherDayView(dayOfWeek: "SAT", imageName: "cloud.hail.fill", temperature: 28)
                }
                
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
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperature)°")
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
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text(temperature)
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}
