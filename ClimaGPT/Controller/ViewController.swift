//
//  ViewController.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 06/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        weatherManager.fetchWeatherWithCityName(cityName: "Monterrey")
        
    }


}

extension ViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.cityName)
        print(weather.temperatureString)
        print(weather.conditionName)
    }
    
}

