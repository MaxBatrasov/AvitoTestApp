//
//  ViewController.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 18.10.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK: globalVar
    var employeeArray: [People] = []
    var employeeArrayLoaded: [Employee] = []
    
    //MARK: lifeCycleFunc
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oneHourCheck()
        self.sendRequest()
        self.internetObservingStart()
    }
    
    //MARK: flowFuncs
    @objc private func sendRequest() {
        RequestManager.shared.sendRequest { [weak self] object in
            if let employees = object.employees {
                self?.employeeArrayLoaded = employees.sorted(by: { guard let firstName = $0.name, let secondName = $1.name else { return false }
                    return firstName < secondName
                })
            }
            DispatchQueue.main.async {
                self?.deleteDataBasePeople()
                if let array = self?.employeeArrayLoaded {
                    for element in array {
                        self?.savePeople(object: element)
                        let cachedDate = Date()
                        UserDefaults.standard.set(cachedDate, forKey: "cachedDate")
                    }
                }
                self?.mainTableView.reloadData()
                self?.loadObjectPeople()
                print (self?.employeeArray.count as Any)
            }
        }
    }
    
    private func internetObservingStart() {
        if NetworkMonitor.shared.isConnected == false {
            self.internetConnectionLostAlert(firstLaunch: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnectionLostAlert), name: .internetDown, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendRequest), name: .internetIsBack, object: nil)
    }
    
    @objc private func internetConnectionLostAlert(firstLaunch: Bool = false) {
        DispatchQueue.main.async {
            if firstLaunch == false {
                let alert = UIAlertController(title: "Warning", message: "Your internet connection is lost", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let startAlert = UIAlertController(title: "Warning", message: "Your are offline. Please turn internet on", preferredStyle: .alert)
                startAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                    startAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(startAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func savePeople(object: Employee) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "People", in: context) else { return }
        
        let employee = People(entity: entity, insertInto: context)
        employee.name = object.name
        employee.phoneNumber = object.phoneNumber
        employee.skills = object.skills as NSArray?
        
        do {
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
    
    private func loadObjectPeople() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
        
        do {
            employeeArray = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
    
    private func deleteDataBasePeople() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
        
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
    
    private func offlineLoad() {
        if NetworkMonitor.shared.isConnected == false && self.employeeArrayLoaded.count == 0 {
            self.loadObjectPeople()
            for element in self.employeeArray {
                let employee = Employee()
                employee.name = element.name
                employee.phoneNumber = element.phoneNumber
                employee.skills = element.skills as? [String]
                self.employeeArrayLoaded.append(employee)
            }
            self.mainTableView.reloadData()
        }
    }
    
    private func oneHourCheck() {
        let currentDate = Date()
        guard let lastCachedDate = UserDefaults.standard.value(forKey: "cachedDate") as? Date else { return }
        if (currentDate.timeIntervalSince1970 - lastCachedDate.timeIntervalSince1970) > 3600 {
            self.deleteDataBasePeople()
        } else {
            self.offlineLoad()
        }
    }
    
}
