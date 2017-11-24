//
//  ListViewController.swift
//  coreDataJsonSample
//
//  Created by MAC on 23/11/17.
//  Copyright © 2017 CCS. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var podCastManagedObject: [NSManagedObject] = []
    var podcastList = NSArray()
    var  pdddd = [Podcast].self

    @IBOutlet var listTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib1 = UINib(nibName: "LisTableViewCell", bundle: nil)
        listTable.register(nib1, forCellReuseIdentifier: "listCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Podcast")
        
        do {
            podCastManagedObject = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
           
        }
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
             callService()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    func save() {
         let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Podcast",
                                                in: managedContext!)!
        
        let pod_cast = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        print(podcastList)
        for  pod in  0...(podcastList.count-1) {
            let po = podcastList.object(at: pod) as! NSDictionary
             print(po)
            pod_cast.setValue(po.value(forKey: "category"), forKeyPath: "category")
            pod_cast.setValue(po.value(forKey: "createdOn"), forKeyPath: "createdOn")
//            pod_cast.setValue(po.value(forKey: "duration"), forKeyPath: "duration")
//           pod_cast.setValue(po.value(forKey: "id"), forKeyPath: "id")
           pod_cast.setValue(po.value(forKey: "podcastURL"), forKeyPath: "podcastURL")
          pod_cast.setValue(po.value(forKey: "thumbLarge"), forKeyPath: "thumbLarge")
            pod_cast.setValue(po.value(forKey: "thumbSmall"), forKeyPath: "thumbSmall")
           pod_cast.setValue(po.value(forKey: "title"), forKeyPath: "title")

            do {
                try managedContext?.save()
                (podCastManagedObject).append(pod_cast)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }

        }
        DispatchQueue.main.async {
            self.listTable.reloadData()

        }
        
        
        
      
    }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if podCastManagedObject.count > 0{
            return podCastManagedObject.count
        }
        else{
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
        
        cell = listTable.dequeueReusableCell(withIdentifier: "listCell") as! LisTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let podd = podCastManagedObject[indexPath.row]

        cell!.label1.text = podd.value(forKeyPath: "category") as? String
        cell!.label2.text = podd.value(forKeyPath: "title") as? String

        
       
        
        return cell
    }
    
    func callService(){
        
        let url = URL(string: "https://upload.radiomango.fm/rm/webservices/rest/podcasts?page=1&numberOfResultsPerPage=-1")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let str = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as! NSDictionary
                self.podcastList = str.value(forKey: "podcasts") as! NSArray
                print(self.podcastList)
                self.save()
            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
        
    }
}
