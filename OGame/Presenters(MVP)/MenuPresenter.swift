//
//  MenuPresenter.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import Foundation
import UIKit

protocol MenuPresenterDelegate {
    init(view: MenuViewDelegate)
    func configureSegueVC(segue: UIStoryboardSegue)
}

final class MenuPresenter {
    unowned let view: MenuViewDelegate
    
    init(view: MenuViewDelegate) {
        self.view = view
    }
}
