//
//  WeatherData.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 23/02/23.
//

import Foundation

// Name                   = name
// Temperature            = temp
// Weather Condition Code = id

struct WeatherData : Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Decodable {
    let temp : Double
}

struct Weather : Decodable {
    let id : Int
}


