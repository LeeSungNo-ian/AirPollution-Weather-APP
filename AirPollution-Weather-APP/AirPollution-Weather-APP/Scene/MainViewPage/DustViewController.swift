//
//  DustViewController.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/09.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

import SnapKit

final class DustViewController: UIViewController {
    
    var airPollutonData: [List]!
    
    @ObservedObject var currentLocationModelManager = CurrentLocationModel.shared
    @ObservedObject var networkManager = NetworkManager.shared
    var cancelBag = Set<AnyCancellable>()
    
    var isCheck: Bool = false
    
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetBackGroundColor = .bottomSheetBackGroundColor
        view.barViewColor = .bottomSheetBarViewColor
        
        return view
    }()
    
    private lazy var charImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var airPollutionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .light)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var airPollutionConditionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .semibold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var citynameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        
        return label
    }()
    
    private lazy var airPollutionValueLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        awaitingUIData()
        //        setupNetworkDatas()
        
        self.currentLocationModelManager.$currentLatitude
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self!.networkManager.fectchData(coordinate: [self!.currentLocationModelManager.currentLatitude, self!.currentLocationModelManager.currentLongitude])
            })
            .store(in: &self.cancelBag)
        
        self.networkManager.$airPollutionValueData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                
                self!.airPollutonData = self!.networkManager.airPollutionValueData
                self!.receiveUIData()
            })
            .store(in: &self.cancelBag)
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        DispatchQueue.main.async {
    //            if self.isAuth {
    //
    //            } else {
    //                let sheet = UIAlertController(title: "위치 정보 동의", message: "앱을 사용 편의성을 위해 '앱을 사용하는 동안 허용' 을 설정해주세요", preferredStyle: .alert)
    //
    //                sheet.addAction(UIAlertAction(title: "아니요", style: .destructive, handler: { _ in
    //                    self.viewDidLoad()
    //                }))
    //
    //                sheet.addAction(UIAlertAction(title: "예", style: .default) { _ in
    //                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    //                    self.viewDidLoad()
    //                })
    //
    //                self.present(sheet, animated: true)
    //            }
    //        }
    //    }
}

private extension DustViewController {
    
    func setupLayout() {
        let airPollutionTextStackView = UIStackView(arrangedSubviews: [airPollutionTextLabel, airPollutionConditionTextLabel])
        airPollutionTextStackView.spacing = 2.0
        airPollutionTextStackView.distribution = .fillEqually
        airPollutionTextStackView.alignment = .center
        airPollutionTextStackView.axis = .vertical
        
        [charImageView, airPollutionTextStackView, airPollutionValueLabel].forEach { view.addSubview($0) }
        
        airPollutionTextStackView.snp.makeConstraints {
            $0.top.equalTo(charImageView.snp.top).inset(-80.0)
            $0.centerX.equalToSuperview()
        }
        
        let charImageViewScaleSize: Double = 450.0
        
        charImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(charImageViewScaleSize)
            $0.height.equalTo(charImageViewScaleSize)
        }
        
        airPollutionValueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func awaitingUIData() {
            self.view.backgroundColor = AirPollutionDataStatus.nothing.statusColor
            self.charImageView.image = AirPollutionDataStatus.nothing.characterImageSet
            self.airPollutionTextLabel.text = ""
            self.airPollutionConditionTextLabel.text = "'앱을 사용하는 동안 허용'을 설정해주세요!"
            
            self.view.addSubview(self.bottomSheetView)
            self.bottomSheetView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
    }
    
    func receiveUIData() {
        if !self.airPollutonData.isEmpty {
            let airPollutonValueData = Int(lround(self.airPollutonData[0].components["pm10"] ?? 0))
            self.bottomSheetView.airPollutonValueDataLabel.text = "\(airPollutonValueData)㎍/㎥"
            UILabel().changeTextWeightSpecificRange(label: self.bottomSheetView.airPollutonValueDataLabel, fontSize: 16.0, fontWeight: UIFont.Weight.semibold, range: "㎍/㎥")
            
            self.view.backgroundColor = self.currentAirPollutionStatus(airPollutonValueData).statusColor
            self.setupBlurEffect(self.currentAirPollutionStatus(airPollutonValueData).statusBlurAlpha)
            self.charImageView.image = self.currentAirPollutionStatus(airPollutonValueData).characterImageSet
            self.airPollutionTextLabel.text = "미세먼지"
            self.airPollutionConditionTextLabel.text = self.currentAirPollutionStatus(airPollutonValueData).statusTextLabel
            
            self.view.addSubview(self.bottomSheetView)
            self.bottomSheetView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }

    func currentAirPollutionStatus(_ airPollutionValue: Int) -> AirPollutionDataStatus {
        if airPollutionValue <= 15 {
            return AirPollutionDataStatus.veryGood
        } else if airPollutionValue <= 35 {
            return AirPollutionDataStatus.good
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
}
