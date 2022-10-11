//
//  BottomSheetView.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import UIKit
import SnapKit

final class BottomSheetView: PassThroughView {

    var currentCityName: String = "" {
        didSet {
            citynameLabel.text = "현재 \(currentCityName)의 온도"
        }
    }
    
    enum Mode {
        case tip
        case full
    }
    
    private enum Const {
        static let duration = 0.5
        static let cornerRadius = 12.0
        static let barViewTopSpacing = 5.0
        static let barViewSize = CGSize(width: UIScreen.main.bounds.width * 0.08, height: 5.0)
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
            case .tip:
                return 0.7 // 위에서 부터의 값 (밑으로 갈수록 값이 커짐)
            case .full:
                return 0.07
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
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private let inputCityNametextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "   도시를 입력해주세요"
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.textColor = .lightGray
        textField.backgroundColor = .textFieldBackGroundColor
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 6
        
        return textField
    }()
    
    lazy var citynameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var bottomContentView: UIView = {
        let view = UIView()

        return view
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
    
    var bottomSheetContentViewColor: UIColor? {
        didSet { self.bottomContentView.backgroundColor = self.bottomSheetContentViewColor }
    }
    
    // MARK: Initializer
    @available(*, unavailable)
    
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputCityNametextField.delegate = self
        
        self.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGesture)
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = Const.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        
        self.addSubview(self.bottomSheetView)
        self.bottomSheetView.addSubview(self.barView)
        self.bottomSheetView.addSubview(self.bottomContentView)
        self.bottomSheetView.addSubview(self.citynameLabel)
        self.bottomSheetView.addSubview(self.inputCityNametextField)
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Const.bottomSheetYPosition(.tip))
        }
        
        self.barView.layer.cornerRadius = 2.5
        self.barView.clipsToBounds = true
        
        self.barView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(Const.barViewTopSpacing)
            $0.size.equalTo(Const.barViewSize)
        }
        
        self.inputCityNametextField.snp.makeConstraints {
            $0.top.equalTo(barView.snp.bottom).offset(30.0)
            $0.leading.equalTo(bottomSheetView.snp.leading).inset(16.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).inset(16.0)
            $0.height.equalTo(30)
        }
        
        self.citynameLabel.snp.makeConstraints {
            $0.top.equalTo(inputCityNametextField.snp.bottom).offset(30.0)
            $0.leading.equalTo(inputCityNametextField)
        }
        
        self.bottomContentView.layer.cornerRadius = 10
        self.bottomContentView.clipsToBounds = true
        self.bottomContentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(citynameLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(citynameLabel)
            $0.trailing.equalTo(inputCityNametextField)
            $0.height.equalTo(200)
        }
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

extension BottomSheetView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.mode = Mode.full
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
