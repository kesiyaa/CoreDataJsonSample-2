//
//  PhotoViewController.swift
//  CoreDataJsonSample
//
//  Created by Vidya R on 23/11/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//

import UIKit
import CoreData

class PhotoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableViewControl: UITableView!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var PhnLabel: UILabel!
    
    var personInformation = NSArray()
    lazy var endPoint: String =
        {
           
            return "https://api.androidhive.info/contacts/"
            
    }()
    @IBOutlet weak var viewsamle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceCall()
      //  tableViewControl.delegate = self
        
        
    }
    func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func serviceCall()
    {
         let url = URL(string: endPoint)
         
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    self.personInformation = jsonObj!.value(forKey: "contacts") as! NSArray

                    
                    OperationQueue.main.addOperation({
                        
                        self.saveValuesToCoreData()
                    })
                }
            }).resume()
        
            
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveValuesToCoreData()
    {
        print(personInformation)
        
        
        let viewContexObject = getContext()
        let personData = NSKeyedArchiver.archivedData(withRootObject: personInformation)
        
        //if let PhotoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: viewContexObject) as? Photo{
        let PhotoEntity =  NSEntityDescription.entity(forEntityName: "Photo",
                                                      in:viewContexObject)
            
        let device = NSManagedObject(entity: PhotoEntity!,
                                     insertInto: viewContexObject)
        
        
            device.setValue(personData, forKey: "photoInfo")
        
            do {
                try viewContexObject.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        
    fetchFromCoreData()
    }
    func fetchFromCoreData()
    {
        let viewContexObject = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let results =
                try viewContexObject.fetch(fetchRequest) as NSArray
            
            if results.count != 0 {
                
                for result  in results {
                    
                    let dataObject = (result as AnyObject).value(forKey: "photoInfo") as! NSData
                    
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: dataObject as Data)
                    let arrayObject = unarchiveObject
                    personInformation = arrayObject as! NSArray
                }
                print(personInformation)
                tableViewControl.reloadData()
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(personInformation.count)
        if  personInformation.count > 0{
             return personInformation.count
        }
        else {
       return 0
        }
    }
   
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        var cell:LisTableViewCell!
        
        cell = tableViewControl.dequeueReusableCell(withIdentifier: "listCell") as! LisTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        cell!.label1.text = "rt"
        cell!.label2.text = "rthy"
        
        
        
        
        return cell
    }
    

}
