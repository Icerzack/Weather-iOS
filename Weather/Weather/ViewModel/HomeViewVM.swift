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
                        image = checkCode(code: String(day.weatherCode))
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
        
        private func checkCode(code: String) -> Image{
            switch code {
            case "1000", "1100":
                return Image("clear_day")
            case "1101", "1102", "1001":
                return Image("cloudy")
            case "2000", "2100":
                return Image("fog")
            case "4000", "4001", "4200", "4201", "6000", "6001", "6200", "6201":
                return Image("rain")
            case "5000", "5001", "5100", "5101", "7000", "7101", "7102":
                return Image("snow")
            case "8000":
                return Image("tstorm")
            default:
                return Image("clear_day")
            }
        }
        
    }
}
