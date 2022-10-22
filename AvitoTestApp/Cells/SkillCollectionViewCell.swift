//
//  SkillCollectionViewCell.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 18.10.2022.
//

import UIKit

class SkillCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var skillLabel: UILabel!
    
    func roundSetup(radius: CGFloat) {
        self.mainContainer.layer.cornerRadius = radius
    }
    
    func setColourAndText(skill: String) {
        self.mainContainer.backgroundColor = self.getSkillColour(skill: skill)
        self.skillLabel.text = skill
        
    }
    
    private func getSkillColour(skill: String) -> UIColor {
        switch skill {
        case "Swift":
            return UIColor.systemOrange
        case "iOS":
            return UIColor.systemBlue
        case "Kotlin":
            return UIColor.magenta
        case "Android":
            return UIColor.systemGreen
        case "Objective-C":
            return UIColor.systemRed
        case "Photoshop":
            return UIColor.systemIndigo
        case "Java":
            return UIColor.systemPurple
        case "Python":
            return UIColor(red: 1.00, green: 0.83, blue: 0.15, alpha: 0.9)
        case "MovieMaker":
            return UIColor.systemPink
        case "Groovy":
            return UIColor(red: 0.40, green: 0.83, blue: 0.81, alpha: 1.00)
        case "PHP":
            return UIColor.systemBrown
        case "C#":
            return UIColor.link
        default:
            return UIColor.systemPurple
        }
    }

    
}
