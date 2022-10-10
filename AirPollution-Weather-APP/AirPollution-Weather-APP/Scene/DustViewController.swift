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
    
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetColor = .bottomSheetBackGroundColor
        view.barViewColor = .bottomSheetBarViewColor
        
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        
        return backgroundView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 200.0, weight: .bold)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        guard let currentLatitude = locationManager.location?.coordinate.latitude else { return }
        guard let currentLongitude = locationManager.location?.coordinate.longitude else { return }

        networkManager.airPollutionURL = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(currentLatitude)&lon=\(currentLongitude)&appid="
        
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
        [backgroundView, nameLabel].forEach { view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
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
                    self.nameLabel.text = String(airPollutonValueData)
                    self.nameLabel.textColor = self.currentAirPollutionStatus(airPollutonValueData).statusColor
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
}
