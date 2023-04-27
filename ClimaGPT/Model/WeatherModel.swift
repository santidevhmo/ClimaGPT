//
//  WeatherModel.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 24/02/23.
//

import Foundation

// Object created for easier data access and retrieval in VC
struct WeatherModel {

    var cityName : String
    var temperature : Double
    var temperatureString : String { // Round the temperature to only 2 decimals to display it in VC
       return String(format:"%.1f", temperature)
   }
    
    var conditionID : Int
    var conditionName : String { // Convert the ID to a String to display in VC
        switch conditionID {
        case 200...232:
            return "with thunderstorms"
        case 300...321:
            return "with drizzle"
        case 500...531:
            return "and raining"
        case 600...622:
            return "and snowing"
        case 701...781:
            return "with fog"
        case 800:
            return "with a clear sky"
        case 801...804:
            return "and cloudy"
        default:
            return "with clouds"
        }
    }
    
    var isError : Bool
    
}
