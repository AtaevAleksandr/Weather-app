//
//  MainViewController.swift
//  Weather
//
//  Created by Aleksandr Ataev on 24.02.2023.
//

import UIKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        title = "Weather Screen"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    //MARK: Clousers
    private lazy var weatherView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height))
        view.image = UIImage(named: "Cloudy Weather")
        return view
    }()

    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.font = UIFont(name: "Rockwell-Regular", size: 20)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Weather")
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var getWeatherData: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "Get Weather Data"
        button.configuration?.baseBackgroundColor = .systemPurple
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.configuration?.cornerStyle = .large
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: Methods
    private func addSubviews() {
        [weatherView, weatherLabel, weatherImage, getWeatherData].forEach { view.addSubview($0) }
    }

    //MARK: Set Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.heightAnchor.constraint(equalToConstant: 50),

            weatherImage.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 30),
            weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 150),
            weatherImage.heightAnchor.constraint(equalToConstant: 150),

            getWeatherData.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 30),
            getWeatherData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getWeatherData.heightAnchor.constraint(equalToConstant: 50),
            getWeatherData.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func buttonTapped() {
        let urlStrig = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true"
        let url = URL(string: urlStrig)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self.weatherLabel.text = "Current temperature is \(weather.currentWeather.temperature) Cº\nWind speed is \(weather.currentWeather.windspeed) m/s"
                }
            } else {
                print("fail")
            }
        }
        task.resume()
    }

}

