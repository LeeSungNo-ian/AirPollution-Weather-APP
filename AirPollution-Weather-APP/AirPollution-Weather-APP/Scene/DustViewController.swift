//
//  DustViewController.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/09.
//

import UIKit
import SnapKit

final class DustViewController: UIViewController {

    var networkManager = NetworkManager()
    var airPollutonData: Co = Co(v: 0.0)

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
        setupLayout()
        setupNetworkDatas()
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
                    let airPollutonValueData = lroundl(self.airPollutonData.v)
                    self.nameLabel.text = String(airPollutonValueData)
                    self.nameLabel.textColor = self.currentAirPollutionStatus(airPollutonValueData).statusColor
                }
            
            case Result.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func currentAirPollutionStatus(_ airPollutionValue: Int) -> AirPollutionDataStatus {
        if airPollutionValue <= 30 {
            return AirPollutionDataStatus.good
        } else if airPollutionValue <= 50 {
            return AirPollutionDataStatus.soso
        } else if airPollutionValue <= 100 {
            return AirPollutionDataStatus.bad
        } else {
            return AirPollutionDataStatus.veryBad
        }
    }
}
