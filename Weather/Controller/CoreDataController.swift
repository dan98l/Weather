//
//  CoreDataController.swift
//  Weather
//
//  Created by Daniil G on 01.10.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataController: NSObject {
    func saveMyCity(name: String, temp: Int, latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            guard let entity = NSEntityDescription.entity(forEntityName: "MyCity", in: context) else { return }
            let cityObject = MyCity(entity: entity, insertInto: context)
            cityObject.name = name
            cityObject.temp = Int16(temp)
            cityObject.latitude = latitude
            cityObject.longitude = longitude
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveCityLocation(name: String, temp: Int, latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            guard let entity = NSEntityDescription.entity(forEntityName: "CityLocation", in: context) else { return }
            let cityObject = CityLocation(entity: entity, insertInto: context)
            cityObject.name = name
            cityObject.temp = Int16(temp)
            cityObject.latitude = latitude
            cityObject.longitude = longitude
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getMyCity (completion: @escaping ([MyCity]) -> () ) {
        DispatchQueue.main.async {
            var city: [MyCity] = []
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"MyCity")

            do {
                city = try context.fetch(fetchRequest) as! [MyCity]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            completion(city)
        }
    }
    
    func getCityLocation (completion: @escaping ([CityLocation]) -> () ) {
         DispatchQueue.main.async {
               var city: [CityLocation] = []
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext

               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"CityLocation")

               do {
                   city = try context.fetch(fetchRequest) as! [CityLocation]
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
               completion(city)
        }
    }
    
    func updateTempInCity(newTemp: Int, name: String){
           DispatchQueue.main.async {
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyCity")
               
               fetchRequest.predicate = NSPredicate(format:"name == %@", name)
               do {
                   guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else {return}
                if results.count != 0 {
                    results[0].setValue(newTemp, forKey: "temp")
                    try context.save()
                }
               }
               catch let error as NSError {
                   print("Could not Fetch \(error), \(error.userInfo)")
               }
        }
    }
}
