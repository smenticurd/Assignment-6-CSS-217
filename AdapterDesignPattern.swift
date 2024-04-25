import Foundation

struct WeatherData {
    let city: String
    let temperature: Double
    let description: String
}

protocol WeatherAPI {
    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void)
}

struct OpenWeatherMapAPI: WeatherAPI {
    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        print("Step 1: Fetching weather data from OpenWeatherMap API for \(city)...")
        // Simulated data retrieval
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let weatherData = WeatherData(city: city, temperature: 20.0, description: "Cloudy")
            print("Step 2: Weather data retrieved successfully.")
            completion(.success(weatherData))
        }
    }
}

struct AccuWeatherAPI: WeatherAPI {
    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        print("Step 3: Fetching weather data from AccuWeather API for \(city)...")
        // Simulated data retrieval
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let weatherData = WeatherData(city: city, temperature: 25.0, description: "Sunny")
            print("Step 4: Weather data retrieved successfully.")
            completion(.success(weatherData))
        }
    }
}

class WeatherAdapter {
    private let weatherAPI: WeatherAPI

    init(weatherAPI: WeatherAPI) {
        self.weatherAPI = weatherAPI
    }

    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        weatherAPI.fetchWeatherData(for: city, completion: completion)
    }
}

let openWeatherMapAPI = OpenWeatherMapAPI()
let accuWeatherAPI = AccuWeatherAPI()

let openWeatherMapAdapter = WeatherAdapter(weatherAPI: openWeatherMapAPI)
let accuWeatherAdapter = WeatherAdapter(weatherAPI: accuWeatherAPI)

openWeatherMapAdapter.fetchWeatherData(for: "New York") { result in
    switch result {
    case .success(let weatherData):
        print("OpenWeatherMap - City: \(weatherData.city), Temperature: \(weatherData.temperature)°C, Description: \(weatherData.description)")
    case .failure(let error):
        print("OpenWeatherMap - Error: \(error)")
    }
}

accuWeatherAdapter.fetchWeatherData(for: "London") { result in
    switch result {
    case .success(let weatherData):
        print("AccuWeather - City: \(weatherData.city), Temperature: \(weatherData.temperature)°C, Description: \(weatherData.description)")
    case .failure(let error):
        print("AccuWeather - Error: \(error)")
    }
}
