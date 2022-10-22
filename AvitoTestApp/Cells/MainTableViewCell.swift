//
//  MainTableViewCell.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 18.10.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var mainOutlet: UILabel!
    @IBOutlet weak var phoneNumberOutlet: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    
    var employeeSkillsArray: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareView(radius: CGFloat) {
        self.mainContainer.getRounded(cornerRadius: radius)
    }
    
    func configure(name: String, phoneNumber: String) {
        self.mainOutlet.text = name
        self.phoneNumberOutlet.text = phoneNumber
    }
    
    func getEmployeeSkillsArray(array: [String]) {
        self.employeeSkillsArray = array
        self.skillsCollectionView.reloadData()
    }
    
}

