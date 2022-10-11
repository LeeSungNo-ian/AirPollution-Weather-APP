//
//  DustViewController.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/09.
//

import UIKit

import SnapKit
import CoreLocation

final class DustViewController: UIViewController {

    var networkManager = NetworkManager()
    var airPollutonData: [List]!
        
    let locationManager = CLLocationManager()
    
    private lazy var weatherDataContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .bottomSheetBackGroundColor
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetBackGroundColor = .bottomSheetBackGroundColor
        view.barViewColor = .bottomSheetBarViewColor
        view.bottomSheetContentViewColor = .bottomSheetContentBackGroundColor
        
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        
        return backgroundView
    }()
    
    private lazy var citynameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        return label
    }()
    
    private lazy var airPollutionValueLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCityName()
        setupLayout()
        setupNetworkDatas()
        requestGPSPermission()
    }
}

extension DustViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
}

private extension DustViewController {
    
    func setupLayout() {
        [backgroundView, citynameLabel, airPollutionValueLabel].forEach { view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        citynameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(airPollutionValueLabel.snp.top).inset(20.0)
        }
        
        airPollutionValueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupNetworkDatas() {
        networkManager.fetchAirPollutionData { result in
            switch result {
            case Result.success(let airPollutonValueData):
                self.airPollutonData = airPollutonValueData
                
                DispatchQueue.main.async {
                    let airPollutonValueData = lroundl(self.airPollutonData[0].components["pm10"] ?? 0)
                    self.airPollutionValueLabel.text = String(airPollutonValueData)
                    
                    if (airPollutonValueData / 100) >= 1 {
                        self.airPollutionValueLabel.font = .systemFont(ofSize: 200.0, weight: .bold)
                    } else if (airPollutonValueData / 10) >= 1 {
                        self.airPollutionValueLabel.font = .systemFont(ofSize: 250.0, weight: .bold)
                    } else {
                        self.airPollutionValueLabel.font = .systemFont(ofSize: 330.0, weight: .bold)
                    }
                    
                    self.airPollutionValueLabel.textColor = self.currentAirPollutionStatus(airPollutonValueData).statusColor
                    self.setupBlurEffect(self.currentAirPollutionStatus(airPollutonValueData).statusBlurAlpha)
                    
                    self.view.addSubview(self.bottomSheetView)
                    self.bottomSheetView.snp.makeConstraints {
                      $0.edges.equalToSuperview()
                    }
                }
            
            case Result.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func currentAirPollutionStatus(_ airPollutionValue: Int) -> AirPollutionDataStatus {
        if airPollutionValue <= 15 {
            return AirPollutionDataStatus.good
        } else if airPollutionValue <= 35 {
            return AirPollutionDataStatus.soso
        } else if airPollutionValue <= 75 {
            return AirPollutionDataStatus.bad
        } else {
            return AirPollutionDataStatus.veryBad
        }
    }
    
    func setupBlurEffect(_ airPollutionValue: Double) {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = airPollutionValue
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
    }
    
    func requestGPSPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
        case .denied:
            print("GPS: 권한 없음")
        default:
            print("GPS: Default")
        }
    }
    
    func setupCityName() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        guard let currentLatitude = locationManager.location?.coordinate.latitude else { return }
        guard let currentLongitude = locationManager.location?.coordinate.longitude else { return }
        
        networkManager.airPollutionURL = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(currentLatitude)&lon=\(currentLongitude)&appid="
        
        let findLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                sleep(1)
                self.citynameLabel.text = "\(String(address.last?.locality ?? "잘못된 도시 이름이에요.")) 미세먼지 농도는"
                self.citynameLabel.textColor = .white
                UILabel().changeTextWeightSpecificRange(label: self.citynameLabel, fontSize: 20.0, fontWeight: UIFont.Weight.regular, range: "미세먼지 농도는")
                self.bottomSheetView.currentCityName = String(address.last?.locality ?? "잘못된 도시 이름이에요.")
            }
        }
        )
    }
}
