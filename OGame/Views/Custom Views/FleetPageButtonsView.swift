//
//  FleetPageButtonsView.swift
//  OGame
//
//  Created by Subvert on 02.02.2022.
//

import UIKit

class FleetPageButtonsView: UIView {
    
    let nextButton = UIButton()
    let resetButton = UIButton()
    
    var nextButtonPressed: (() -> Void)?
    var resetButtonPressed: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        configureResetButton()
        configureNextButton()
    }
    
    func configureResetButton() {
        addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: topAnchor),
            resetButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            resetButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4)
        ])
        
        resetButton.setTitle("RESET", for: .normal)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.setTitleColor(.systemGray, for: .disabled)
        resetButton.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)        
    }
    
    func configureNextButton() {
        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.setTitleColor(.systemGray, for: .disabled)
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        nextButton.isEnabled = false
    }
    
    @objc func nextPressed() {
        nextButtonPressed?()
    }
    
    @objc func resetPressed() {
        resetButtonPressed?()
    }
}
