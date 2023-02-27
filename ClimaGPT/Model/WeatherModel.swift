//
//  WeatherModel.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 24/02/23.
//

import Foundation

// Object created for easier data access and retrieval in VC
struct WeatherModel {
    
    let cityName : String
    
    let temperature : Double
    var temperatureString : String { // Round the temperature to only 2 decimals to display it in VC
       return String(format:"%.1f", temperature)
   }
    
    let conditionID : Int
    var conditionName : String { // Convert the ID to a String to display in VC
        switch conditionID {
        case 200...232:
            return "Thunderstorm"
        case 300...321:
            return "Drizzle"
        case 500...531:
            return "Rain"
        case 600...622:
            return "Snowing"
        case 701...781:
            return "Fog"
        case 800:
            return "Clear sky"
        case 801...804:
            return "Clouddy"
        default:
            return "cloud"
        }
    }
    
}
