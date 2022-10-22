//
//  RequestManager.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 18.10.2022.
//

import Foundation

class RequestManager {
    static var shared = RequestManager()
    
    var cache = NSCache<NSString, Company>()
    var dateCached = NSCache<NSString, NSDate>()
    
    private init() {}
    
    func sendRequest(completion: @escaping(Company) -> ()) {
        guard let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") else {
            return
        }
        
        if self.oneHourCheck() {
            if let cached = cache.object(forKey: url.absoluteString as NSString) {
                completion(cached)
            }
        } else {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil, let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            
                            let companyObject = Company()
                            var employeesArray: [Employee] = []
                            
                            guard let company = json["company"] as? [String: Any] else {
                                return
                            }
                            
                            guard let name = company["name"] as? String else {
                                return
                            }
                            
                            guard let employees = company["employees"] as? [Any] else {
                                return
                            }
                            
                            for object in employees {
                                let employeObject = Employee()
                                guard let employee = object as? [String: Any] else {
                                    return
                                }
                                guard let name = employee["name"] as? String else {
                                    return
                                }
                                guard let phoneNumber = employee["phone_number"] as? String else {
                                    return
                                }
                                guard let skills = employee["skills"] as? [String] else {
                                    return
                                }
                                employeObject.name = name
                                employeObject.phoneNumber = phoneNumber
                                employeObject.skills = skills
                                employeesArray.append(employeObject)
                            }
                            
                            companyObject.name = name
                            companyObject.employees = employeesArray
                            
                            let cachedDate = Date()
                            self.cache.setObject(companyObject, forKey: url.absoluteString as NSString)
                            self.dateCached.setObject(cachedDate as NSDate, forKey: "cachedRequestDate")
                            completion(companyObject)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func oneHourCheck() -> Bool {
        let currentDate = Date()
        guard let cachedDate = dateCached.object(forKey: "cachedRequestDate" as NSString) else { return false }
        if currentDate.timeIntervalSince1970 - cachedDate.timeIntervalSince1970 < 3600 {
            return true
        } else {
            return false
        }
    }
    
}
