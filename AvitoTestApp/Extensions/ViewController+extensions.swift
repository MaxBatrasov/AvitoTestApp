//
//  ViewController+extensions.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 18.10.2022.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeArrayLoaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        if let name = self.employeeArrayLoaded[indexPath.row].name {
            if let phoneNumber = self.employeeArrayLoaded[indexPath.row].phoneNumber {
                cell.configure(name: name, phoneNumber: phoneNumber)
            }
        }
        if let skills = self.employeeArrayLoaded[indexPath.row].skills {
            cell.getEmployeeSkillsArray(array: skills )
        }
        cell.prepareView(radius: 10)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
