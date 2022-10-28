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
    
//    var currentCityName: String = ""
    
//    var currentCityName: String = "" {
//        didSet {
//            citynameLabel.text = currentCityName != "" ? "\(currentCityName) 주변의 미세먼지 농도" : "도시를 찾는 중 입니다!"
//        }
//    }
    
//    self.networkManager.$airPollutionValueData
//        .receive(on: DispatchQueue.main)
//        .sink(receiveValue: { [weak self] _ in
//
//            self!.airPollutonData = self!.networkManager.airPollutionValueData
//            self!.setupNetworkDatas()
//            self?.isCheck = true
//        })
//        .store(in: &self.cancelBag)
//
    
    var currentLocateWebViewURLString: String = "https://waqi.info/#/c/0/0/11z" {
        didSet {
            currentLocateWebViewURL = URL(string: currentLocateWebViewURLString)!
            let request: URLRequest = URLRequest(url: currentLocateWebViewURL)
            webView.load(request as URLRequest)
        }
    }
    
    var currentLocateWebViewURL: URL = URL(string:"http://t1.daumcdn.net/thumb/R600x0/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fqna%2Fimage%2F4b035cdf8372d67108f7e8d339660479dfb41bbd")!
    
    enum Mode {
        case tip
        case full
    }
    
    private enum Const {
        static let duration = 0.5
        static let cornerRadius = 12.0
        static let barViewTopSpacing = 5.0
        static let barViewSize = CGSize(width: UIScreen.main.bounds.width * 0.09, height: 5.0)
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
            case .tip:
                return 0.9 // 값이 클수록 BottomSheet의 길이가 줄어든다
            case .full:
                return 0.2 // 값이 커질 수록 뷰는 밑으로 내려간다
            }
        }
        
        static let bottomSheetYPosition: (Mode) -> Double = { mode in
            Self.bottomSheetRatio(mode) * UIScreen.main.bounds.height
        }
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
        label.text = "sjkfljlsjfl"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    // MARK: Properties
    var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            self.updateConstraint(offset: Const.bottomSheetYPosition(self.mode))
        }
    }
    
    var bottomSheetBackGroundColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetBackGroundColor }
    }
    
    var barViewColor: UIColor? {
        didSet { self.barView.backgroundColor = self.barViewColor }
    }

    // MARK: Initializer
    @available(*, unavailable)
    
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                print("👍")
        self.currentLocationModelManager.$currentLocationCity
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                
                self!.citynameLabel.text = self!.currentLocationModelManager.currentLocationCity
                self!.currentLocateWebViewURLString = "https://waqi.info/#/c/\(self!.currentLocationModelManager.currentLatitude)/\(self!.currentLocationModelManager.currentLongitude)/11z"
                print("👍")
            })
            .store(in: &self.cancelBag)
        
        self.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGesture)
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = Const.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        
        self.addSubview(self.bottomSheetView)
        self.addSubview(self.airPollutionDataContentView)
        
        self.airPollutionDataContentView.addSubview(airPollutonValueDataLabel)
        
        self.bottomSheetView.addSubview(self.barView)
        self.bottomSheetView.addSubview(self.citynameLabel)
        self.bottomSheetView.addSubview(self.webView)
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Const.bottomSheetYPosition(.tip))
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
            $0.top.equalToSuperview().inset(Const.barViewTopSpacing)
            $0.size.equalTo(Const.barViewSize)
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

        let request: URLRequest = URLRequest(url: currentLocateWebViewURL)
        webView.load(request as URLRequest)
    }
    
    // MARK: Methods
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: self).y
        let minY = self.bottomSheetView.frame.minY
        let offset = translationY + minY
        
        if Const.bottomSheetYPosition(.full)...Const.bottomSheetYPosition(.tip) ~= offset {
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
            withDuration: Const.duration,
            delay: 0,
            options: .allowUserInteraction,
            animations: {
                // velocity를 이용하여 위로 스와이프인지, 아래로 스와이프인지 확인
                self.mode = recognizer.velocity(in: self).y >= 0 ? Mode.tip : .full
            },
            completion: nil
        )
    }
    
    private func updateConstraint(offset: Double) {
        self.bottomSheetView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(offset)
        }
    }
}
