//
//  MainTableViewCell+extensions.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 20.10.2022.
//

import Foundation
import UIKit

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.employeeSkillsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as? SkillCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.roundSetup(radius: 10)
        cell.setColourAndText(skill: self.employeeSkillsArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelStringSize = self.employeeSkillsArray[indexPath.item].size(withAttributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)
            ])
            return CGSize(width: labelStringSize.width + 10, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
