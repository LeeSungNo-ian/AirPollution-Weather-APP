//
//  DustViewController.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/09.
//

import UIKit
import SnapKit

final class DustViewController: UIViewController {

    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        
        return backgroundView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = .systemFont(ofSize: 200.0, weight: .bold)
        label.textColor = .systemBlue
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
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
}
