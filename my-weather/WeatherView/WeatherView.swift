//
//  ContentView.swift
//  my-weather
//
//  Created by 심관혁 on 8/23/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    
    
    var body: some View {
        VStack {
            Text("날씨 정보")
                .font(.largeTitle)
                .padding()
            
            Text(viewModel.temperature)
                .font(.title)
                .padding()
            
            Text(viewModel.description)
                .font(.subheadline)
                .padding()
            
            Button {
                viewModel.fetchWeather(nx: "37", ny: "127")
            } label: {
                Text("날씨 가져오기")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .padding()
    }
}

#Preview {
    WeatherView()
}
