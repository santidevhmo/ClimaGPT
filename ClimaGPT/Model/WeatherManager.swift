//
//  WeatherManager.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 23/02/23.
//

import Foundation

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2c9648e04481c0529268ba8a8f884696&units=metric"
    
    func fetchWeather(cityName: String) { // (This function is called inside another file, and the parameter is the user input)
        let urlString = "\(weatherURL)&q=\(cityName)"
    }
    
    func performRequest(urlString: String) {
        
        // ===== 1. Create a URL ===== (Safely unwrapping it)
        if let url = URL(string: urlString) { // It is of type URL so that it can be later passed to the URLSession task
            
            // ===== 2. Create a URLSession =====
            let session = URLSession(configuration: .default) // The object created in here is like our browser. It is the thing that can perform the networking.
            
            // ===== 3. Give the Session a task =====
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    // dataString is only used to print the code before creating the completion handler that will parse it. It is not used again after this
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                }
                
            }
            
            // ===== 4. Start the URLSessionTasks declared above =====
            // (We declared them, and they won't run until task.resume() is declared)
            task.resume()
            
        }
        
    }
    
    // ===== 3.1 Custom completion handler to retrieve the data, response, and error, and use them as we want =====
    // (Default completion handler doesn't let us use these params)
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        
        // == Error ==
        if error != nil {
            print(error!)
        }
        // == Succesful data retrievement ==
        if let safeData = data {
            parseJSON(weatherData: safeData)
            
        }
    }
    
    // ===== 3.1.1 Parsing the JSON to Swift types =====
    func parseJSON(weatherData: Data) {
        
        let decoder = JSONDecoder()
        
        // == Data ==
        // (Parsing the JSON with a do, try, and catch is obligatory from Xcode. We get an error if we don't parse it this way)
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // WeatherData = the replicated JSON structure (the struct created in our WeatherData file)
            print("CityName = \(decodedData.name)")
            print("Temperature = \(decodedData.main.temp)")
            print("Condition ID = \(decodedData.weather[0].id)")
            
        // == Error ==
        } catch {
            print(error)
        }
    }
    
}
