//
//  SettingsVC.swift
//  OGame
//
//  Created by Subvert on 4/7/22.
//

import UIKit

final class SettingsVC: BaseViewController {

    // MARK: Properties
    var player: PlayerData
    var myView: SettingsView { return view as! SettingsView }
    
    // MARK: View Lifecycle
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.settings
        myView.setTopStackView(characterClass: player.characterClass, officers: player.officers)
        myView.configureLabels(player: player)
    }
    
    init(player: PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
