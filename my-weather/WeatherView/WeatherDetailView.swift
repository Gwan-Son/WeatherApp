//
//  WeatherDetailView.swift
//  my-weather
//
//  Created by 심관혁 on 9/5/24.
//

import SwiftUI
import Charts
import Combine

struct WeatherDetailView: View {
    @Binding var weathers: [WeatherModel]
    @Binding var rehpop: Bool // true - reh false - pop
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0)]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack {
            BackgroundView(topColor: .blue, bottomColor: .yellow)
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 300)
                .padding(.horizontal, 20)
                .foregroundColor(.black)
                .opacity(0.1)
            VStack {
                Text("오늘의 \(rehpop ? "습도" : "강수확률")")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                if #available(iOS 16.0, *) {
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
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}

private func reverseTimeChange(timeString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a h시"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    if let time = dateFormatter.date(from: timeString) {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH시"
        dateFormatter2.locale = Locale(identifier: "ko_KR")
        return dateFormatter2.string(from: time)
    } else {
        return ""
    }
}

#Preview {
    WeatherDetailView(weathers: .constant([WeatherModel(dayOfWeek: "", fcstDate: "", fcstTime: "", temperature: "", windSpeedTransverse: "", windSpeedVertical: "", windDirection: "", windSpeed: "", sky: "", pop: "60", pty: "", pcp: "", reh: "60", sno: "", wav: "", temperatureMin: "", temperatureMax: "", weatherImage: ""),WeatherModel(dayOfWeek: "", fcstDate: "", fcstTime: "", temperature: "", windSpeedTransverse: "", windSpeedVertical: "", windDirection: "", windSpeed: "", sky: "", pop: "60", pty: "", pcp: "", reh: "70", sno: "", wav: "", temperatureMin: "", temperatureMax: "", weatherImage: ""),WeatherModel(dayOfWeek: "", fcstDate: "", fcstTime: "", temperature: "", windSpeedTransverse: "", windSpeedVertical: "", windDirection: "", windSpeed: "", sky: "", pop: "60", pty: "", pcp: "", reh: "60", sno: "", wav: "", temperatureMin: "", temperatureMax: "", weatherImage: ""),WeatherModel(dayOfWeek: "", fcstDate: "", fcstTime: "", temperature: "", windSpeedTransverse: "", windSpeedVertical: "", windDirection: "", windSpeed: "", sky: "", pop: "60", pty: "", pcp: "", reh: "60", sno: "", wav: "", temperatureMin: "", temperatureMax: "", weatherImage: "")]), rehpop: .constant(true))
}
