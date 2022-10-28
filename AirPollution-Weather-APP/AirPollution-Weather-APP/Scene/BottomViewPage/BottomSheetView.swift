//
//  BottomSheetView.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

import SnapKit
import WebKit

final class BottomSheetView: PassThroughView {
    
    var airPollutonData: [List]!
    
    @ObservedObject var currentLocationModelManager = CurrentLocationModel.shared
    var cancelBag = Set<AnyCancellable>()
    
    var currentLocateWebViewURLString: String = "https://waqi.info/#/c/0/0/11z"
    
    var currentLocateWebViewURL: URL = URL(string:"http://t1.daumcdn.net/thumb/R600x0/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fqna%2Fimage%2F4b035cdf8372d67108f7e8d339660479dfb41bbd")!
    
    var mode: BottomSheetMode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            self.updateConstraint(offset: BottomSheetConstraint.bottomSheetYPosition(self.mode))
        }
    }
    
    var bottomSheetBackGroundColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetBackGroundColor }
    }
    
    var barViewColor: UIColor? {
        didSet { self.barView.backgroundColor = self.barViewColor }
    }
    
    // MARK: UI
    let bottomSheetView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var airPollutionDataContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .bottomSheetBackGroundColor
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var airPollutonValueDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    lazy var citynameLabel: UILabel = {
        let label = UILabel()
        label.text = "임의의 값을 나타냅니다."
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        fetchCurrentLotationData()
        fetchMapKitData()
    }
}

private extension BottomSheetView {
    
    private func updateConstraint(offset: Double) {
        self.bottomSheetView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(offset)
        }
    }
    
    func fetchCurrentLotationData() {
        self.currentLocationModelManager.$currentLocationCity
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                
                self!.citynameLabel.text = "\(self!.currentLocationModelManager.currentLocationCity) 주변의 미세먼지 농도"
                self!.currentLocateWebViewURLString = "https://waqi.info/#/c/\(self!.currentLocationModelManager.currentLatitude)/\(self!.currentLocationModelManager.currentLongitude)/11z"
            })
            .store(in: &self.cancelBag)
    }
    
    func fetchMapKitData() {
        let request: URLRequest = URLRequest(url: currentLocateWebViewURL)
        webView.load(request as URLRequest)
    }
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: self).y
        let minY = self.bottomSheetView.frame.minY
        let offset = translationY + minY
        
        if BottomSheetConstraint.bottomSheetYPosition(.full)...BottomSheetConstraint.bottomSheetYPosition(.tip) ~= offset {
            self.updateConstraint(offset: offset)
            recognizer.setTranslation(.zero, in: self)
        }
        
        UIView.animate(
            withDuration: 0,
            delay: 0,
            options: .curveEaseOut,
            animations: self.layoutIfNeeded,
            completion: nil
        )
        
        guard recognizer.state == .ended else { return }
        
        UIView.animate(
            withDuration: BottomSheetConstraint.duration,
            delay: 0,
            options: .allowUserInteraction,
            animations: {
                // velocity를 이용하여 위로 스와이프인지, 아래로 스와이프인지 확인
                self.mode = recognizer.velocity(in: self).y >= 0 ? BottomSheetMode.tip : .full
            },
            completion: nil
        )
    }
}

private extension BottomSheetView {
    
    func setupLayout() {
        self.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGesture)
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = BottomSheetConstraint.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        
        self.addSubview(self.bottomSheetView)
        self.addSubview(self.airPollutionDataContentView)
        
        self.airPollutionDataContentView.addSubview(airPollutonValueDataLabel)
        
        self.bottomSheetView.addSubview(self.barView)
        self.bottomSheetView.addSubview(self.citynameLabel)
        self.bottomSheetView.addSubview(self.webView)
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(BottomSheetConstraint.bottomSheetYPosition(.tip))
        }
        
        self.airPollutionDataContentView.snp.makeConstraints {
            $0.bottom.equalTo(barView.snp.top).offset(-20.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(50.0)
            $0.width.equalTo(80.0)
        }
        
        self.airPollutonValueDataLabel.snp.makeConstraints {
            $0.center.equalTo(airPollutionDataContentView.snp.center)
        }
        
        self.barView.layer.cornerRadius = 2.5
        self.barView.clipsToBounds = true
        
        self.barView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(BottomSheetConstraint.barViewTopSpacing)
            $0.size.equalTo(BottomSheetConstraint.barViewSize)
        }
        
        self.citynameLabel.snp.makeConstraints {
            $0.top.equalTo(barView.snp.bottom).offset(18.0)
            $0.leading.equalToSuperview().offset(24.0)
        }
        
        self.webView.snp.makeConstraints {
            $0.top.equalTo(citynameLabel.snp.bottom).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(400.0)
            $0.height.equalTo(700.0)
        }
    }
}
