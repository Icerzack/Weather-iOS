//
//  NetworkService.swift
//  Weather
//
//  Created by Max Kuznetsov on 26.08.2022.
//

let json =
"""
{
  "data": {
    "timelines": [
      {
        "timestep": "1d",
        "endTime": "2022-09-02T10:00:00Z",
        "startTime": "2022-08-26T10:00:00Z",
        "intervals": [
          {
            "startTime": "2022-08-26T10:00:00Z",
            "values": {
              "temperature": 32.46,
              "weatherCode": 1001
            }
          },
          {
            "startTime": "2022-08-27T10:00:00Z",
            "values": {
              "temperature": 24.09,
              "weatherCode": 1100
            }
          },
          {
            "startTime": "2022-08-28T10:00:00Z",
            "values": {
              "temperature": 24.34,
              "weatherCode": 1000
            }
          },
          {
            "startTime": "2022-08-29T10:00:00Z",
            "values": {
              "temperature": 30.43,
              "weatherCode": 1101
            }
          },
          {
            "startTime": "2022-08-30T10:00:00Z",
            "values": {
              "temperature": 30.89,
              "weatherCode": 1001
            }
          },
          {
            "startTime": "2022-08-31T10:00:00Z",
            "values": {
              "temperature": 30.25,
              "weatherCode": 1001
            }
          },
          {
            "startTime": "2022-09-01T10:00:00Z",
            "values": {
              "temperature": 29.6,
              "weatherCode": 4000
            }
          }
        ]
      }
    ]
  }
}
"""


import Foundation

final class NetworkService{
    
    typealias weatherTuple = (date: Date, temperature: Double, weatherCode: Int)
        
    private let url = "https://api.tomorrow.io/v4/timelines?location=42.3478,-71.0466&fields=temperature&fields=weatherCode&units=metric&timesteps=1d&startTime=now&endTime=nowPlus6d&apikey=q6i54ZKproMS2sTCxNTeCGVctpjchsh2"
    
    func performWeatherRequest(completion: @escaping ([weatherTuple]) -> Void){
            URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                guard let data = data else {
                    return
                }
                
                let weather: WeatherModel = try! JSONDecoder().decode(WeatherModel.self, from: json.data(using: .utf8)!)
                let intervals = weather.data.timelines[0].intervals

                var tupleArray: [weatherTuple] = []
                                
                for interval in intervals{
                    let tempTuple: weatherTuple = (ISO8601DateFormatter().date(from: interval.startTime)!, interval.values.temperature,  interval.values.weatherCode)

                    tupleArray.append(tempTuple)
                }
                completion(tupleArray)
                
            }.resume()
    }
    
}
