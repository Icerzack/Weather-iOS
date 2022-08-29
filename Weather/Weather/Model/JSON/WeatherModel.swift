//
//  NetworkService.swift
//  Weather
//
//  Created by Max Kuznetsov on 26.08.2022.
//


import Foundation


// MARK: - WeatherModel
struct WeatherModel: Codable {
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    var timelines: [Timeline]
}

// MARK: - Timeline
struct Timeline: Codable {
    var timestep: String
    var endTime, startTime: String
    var intervals: [Interval]
}

// MARK: - Interval
struct Interval: Codable {
    var startTime: String
    var values: Values
}

// MARK: - Values
struct Values: Codable {
    var temperature: Double
    var weatherCode: Int
}
