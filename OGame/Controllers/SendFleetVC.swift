//
//  SendFleetVC.swift
//  OGame
//
//  Created by Subvert on 14.01.2022.
//

import UIKit

class SendFleetVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var player: PlayerData?
    var ships: [BuildingWithAmount]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.minimumInteritemSpacing = 8
        flowLayout?.minimumLineSpacing = 8
        flowLayout?.sectionInset = UIEdgeInsets(top: 8,
                                                left: 8,
                                                bottom: 8,
                                                right: 8)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        Task {
            do {
                try await OGSendFleet.sendFleet(playerData: player!,
                                                mission: Mission.spy,
                                                id: player!.planetID,
                                                whereTo: [4, 96, 12],
                                                ships: ships!)
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
}

// MARK: - Delegate & DataSource
extension SendFleetVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionTypeCollectionCell", for: indexPath) as! MissionTypeCollectionCell
        
        cell.collectionViewButton.imageView?.image = UIImage(named: "expeditionAvailable")
        
        return cell
    }
}

// MARK: - Delegate Flow Layout
extension SendFleetVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(itemsPerRow))
        
        return CGSize(width: size, height: size)
    }
    
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return sectionInsets
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return sectionInsets.left
    //    }
}
