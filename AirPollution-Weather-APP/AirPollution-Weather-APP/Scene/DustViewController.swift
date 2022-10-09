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
        label.textColor = .systemBlue
        
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
            case Result.success(let airPollutonData):
                self.airPollutonData = airPollutonData
                print("데이터를 제대로 받았음")
                
                DispatchQueue.main.async {
                    self.nameLabel.text = String(self.airPollutonData.v)
                    print(lroundl(airPollutonData.v))
                }
            
            case Result.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
