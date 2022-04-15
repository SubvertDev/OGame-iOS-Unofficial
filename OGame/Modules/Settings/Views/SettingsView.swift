//
//  SettingsView.swift
//  OGame
//
//  Created by Subvert on 4/7/22.
//

import UIKit

final class SettingsView: UIView {
    
    private let hireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Classes.noClass
        return imageView
    }()
    
    private let commanderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Officers.Off.commander
        return imageView
    }()
    
    private let admiralImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Officers.Off.admiral
        return imageView
    }()
    
    private let engineerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Officers.Off.engineer
        return imageView
    }()
    
    private let geologistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Officers.Off.geologist
        return imageView
    }()
    
    private let technocratImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Officers.Off.technocrat
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let universeLabel: UILabel = {
       let label = UILabel()
        label.text = "Universe: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let planetsAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Planets amount: "
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let moonsAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Moons amount: "
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let serverEconomySpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Economy speed: x"
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let serverFleetSpeedPeacefulLabel: UILabel = {
        let label = UILabel()
        label.text = "Peaceful fleet speed: x"
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let serverFleetSpeedWarLabel: UILabel = {
        let label = UILabel()
        label.text = "War fleet speed: x"
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let serverFleetSpeedHoldingLabel: UILabel = {
        let label = UILabel()
        label.text = "Holdng fleet speed: x"
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let serverVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "Server version: "
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    let footerView: FooterView = {
       let view = FooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func setTopStackView(characterClass: CharacterClass, officers: Officers) {
        switch characterClass {
        case .noClass:
            classImageView.image = Images.Classes.noClass
        case .collector:
            classImageView.image = Images.Classes.collector
        case .admiral:
            classImageView.image = Images.Classes.admiral
        case .discoverer:
            classImageView.image = Images.Classes.discoverer
        }
        
        if officers.commander { commanderImageView.image = Images.Officers.On.commander }
        if officers.admiral { admiralImageView.image = Images.Officers.On.admiral }
        if officers.engineer { engineerImageView.image = Images.Officers.On.engineer }
        if officers.geologist { geologistImageView.image = Images.Officers.On.geologist }
        if officers.technocrat { technocratImageView.image = Images.Officers.On.technocrat }
    }
    
    func configureLabels(player: PlayerData) {
        universeLabel.text! += "\(player.universe)"
        planetsAmountLabel.text! += "\(player.planetIDs.count)"
        moonsAmountLabel.text! += "\(player.moonIDs.compactMap{$0 > 0 ? $0 : nil}.count)"
        serverFleetSpeedPeacefulLabel.text! += "\(player.universeInfo.speed.peacefulFleet)"
        serverFleetSpeedWarLabel.text! += "\(player.universeInfo.speed.warFleet)"
        serverFleetSpeedHoldingLabel.text! += "\(player.universeInfo.speed.holdingFleet)"
        serverEconomySpeedLabel.text! += "\(player.universeInfo.speed.universe)"
        serverVersionLabel.text! += "\(player.universeInfo.version)"
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(hireStackView)
        hireStackView.addArrangedSubview(classImageView)
        hireStackView.addArrangedSubview(commanderImageView)
        hireStackView.addArrangedSubview(admiralImageView)
        hireStackView.addArrangedSubview(engineerImageView)
        hireStackView.addArrangedSubview(geologistImageView)
        hireStackView.addArrangedSubview(technocratImageView)
        
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(universeLabel)
        infoStackView.addArrangedSubview(planetsAmountLabel)
        infoStackView.addArrangedSubview(moonsAmountLabel)
        infoStackView.addArrangedSubview(serverFleetSpeedPeacefulLabel)
        infoStackView.addArrangedSubview(serverFleetSpeedWarLabel)
        infoStackView.addArrangedSubview(serverFleetSpeedHoldingLabel)
        infoStackView.addArrangedSubview(serverEconomySpeedLabel)
        infoStackView.addArrangedSubview(serverVersionLabel)
        
        addSubview(footerView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            hireStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            hireStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            hireStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            classImageView.heightAnchor.constraint(equalTo: classImageView.widthAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: hireStackView.bottomAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
