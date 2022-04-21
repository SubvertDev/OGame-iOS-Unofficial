//
//  FleetPageButtonsView.swift
//  OGame
//
//  Created by Subvert on 02.02.2022.
//

import UIKit

protocol IFleetPageButtonsView {
    func nextButtonTapped()
    func resetButtonTapped()
}

final class FleetPageButtonsView: UIView {
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.setTitleColor(.systemGray, for: .disabled)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.isEnabled = false
        return nextButton
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("RESET", for: .normal)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.setTitleColor(.systemGray, for: .disabled)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return resetButton
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .opaqueSeparator
        return view
    }()
    
    var delegate: IFleetPageButtonsView?
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(resetButton)
        addSubview(nextButton)
        addSubview(separatorView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: topAnchor),
            resetButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            resetButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4),
            
            nextButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: topAnchor),
            
            separatorView.topAnchor.constraint(equalTo: nextButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    @objc private func nextButtonTapped() {
        delegate?.nextButtonTapped()
    }
    
    @objc private func resetButtonTapped() {
        delegate?.resetButtonTapped()
    }
}
