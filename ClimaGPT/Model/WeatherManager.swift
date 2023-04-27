//
//  WeatherManager.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 23/02/23.
//

import Foundation

// MARK: Protocol for passing values to VC

// ===== 4. Protocol created to pass the values to the VC with delegates =====
protocol WeatherManagerDelegate {
    // == 4.1. Func for the VC to access the WeatherModelObject filled with valus obtained below ==
    func didUpdateWeather(weather: WeatherModel)
    func errorInWeatherFetch()
}

// MARK: WeatherManager: all functions responsible for obtaining and parsing the data

struct WeatherManager {
    
    var delegate : WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2c9648e04481c0529268ba8a8f884696&units=metric"
    
    func fetchWeatherWithCityName(cityName: String) { // (This function is called inside another file, and the parameter is the user input)
        
        let startingURL = "https://api.openweathermap.org/data/2.5/weather"
        var components = URLComponents(string: startingURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: "2c9648e04481c0529268ba8a8f884696"),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        if let url = components?.url { // Converting the user Input to a URL string : no error with lack of network or when input has words >= 2
            let urlString = url.absoluteString
            print(urlString)
            performRequest(urlString: urlString)
        }
                
    }
    
    func performRequest(urlString: String) {
        
        print("URL String = \(urlString)")
        
        // ===== 1. Create a URL ===== (Safely unwrapping it)
        if let url = URL(string: urlString) { // It is of type URL so that it can be later passed to the URLSession task
            
            // ===== 2. Create a URLSession =====
            let session = URLSession(configuration: .default) // The object created in here is like our browser. It is the thing that can perform the networking.
            
            // ===== 3. Give the Session a task =====
            let task = session.dataTask(with: url) { (data, response, error) in // Closure completion handler to retrieve the data, response, and error, and use them as we want
                
                // == Error ==
                if error != nil {
                    print(error!)
                    self.delegate?.errorInWeatherFetch()
                    return
                }
                
                // == Succesful data retrievement ==
                if let safeData = data {
                    print("SafeData = \(safeData)")
                    if let weather = parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                    
                }
                
            }
            
            // ===== 4. Start the URLSessionTasks declared above =====
            // (We declared them, and they won't run until task.resume() is declared)
            task.resume()
            
        } else {
            print("NETWORK ERROR TRIGGERED")
        }
        
    }
    
    // ===== 3.1 Parsing the JSON to Swift types =====
    func parseJSON(weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        // == Data ==
        // (Parsing the JSON with a do, try, and catch is obligatory from Xcode. We get an error if we don't parse it this way)
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // WeatherData = the replicated JSON structure (the struct created in our WeatherData file)
            
            let city = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(cityName: city, temperature: temp, conditionID: id, isError: false)
            
            return weather
            
        // == Error: User didn't type a city name ==
        } catch {
            print("Trigering delegate")
            self.delegate?.errorInWeatherFetch() // Notifiy the VC so that it displays the cell as an error
            print(error)
            return nil
        }
    }
    
}
