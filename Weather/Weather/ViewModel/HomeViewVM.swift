//
//  HomeViewVM.swift
//  Weather
//
//  Created by Max Kuznetsov on 26.08.2022.
//

import Foundation
import SwiftUI

extension HomeView {
    @MainActor class HomeViewVM: ObservableObject {
        @Published var weatherForecast = [(String, Image, Double)]()
        private var networkService = NetworkService()
        
        private var date: String?
        private var image: Image?
        private var temperature: Double?
        
        @Published var currentTemperature: Double?
        @Published var currentWeatherImage: Image?
        
        func fetchWeather(){
            networkService.performWeatherRequest { [self] forecast in
                for day in forecast {
                    DispatchQueue.main.async { [self] in
                        date = convertFromDate(date: day.date)
                        switch checkCode(code: String(day.weatherCode)){
                        case .clear:
                            image = Image("clear_day")
                        case .cloudy:
                            image = Image("cloudy")
                        case .fog:
                            image = Image("fog")
                        case .rain:
                            image = Image("rain")
                        case .snow:
                            image = Image("snow")
                        case .thunder:
                            image = Image("tstorm")
                        }
                        temperature = day.temperature
                        if day == forecast.first! {
                            currentTemperature = temperature
                            currentWeatherImage = image
                        }
                        self.weatherForecast.append((date!, image!, temperature!))
                    }
                }
            }
        }
        
        private func convertFromDate(date: Date) -> String{
            let dateString = date.description
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
            
            guard let date = formatter.date(from: dateString) else {
                return ""
            }
            
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: date)
            formatter.dateFormat = "MM"
            let month = formatter.string(from: date)
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date)
            
            return "\(day).\(month).\(year)"
        }
        
        private func checkCode(code: String) -> WeatherCodes{
            switch code {
            case "1000", "1100":
                return .clear
            case "1101", "1102", "1001":
                return .cloudy
            case "2000", "2100":
                return .fog
            case "4000", "4001", "4200", "4201", "6000", "6001", "6200", "6201":
                return .rain
            case "5000", "5001", "5100", "5101", "7000", "7101", "7102":
                return .snow
            case "8000":
                return .thunder
            default:
                return .clear
            }
        }
        
    }
}
