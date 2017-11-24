//
//  APIService.swift
//  CoreDataJsonSample
//
//  Created by Vidya R on 23/11/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//

import UIKit
enum Result
{
    case ResultValue(NSDictionary)
    
}
class APIService: NSObject
{

    lazy var endPoint: String =
        {
            //return “https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#"
            return "https://api.androidhive.info/contacts/"
    
    }()
//    func getDataWith() -> NSDictionary
//    {
//         let url = URL(string: endPoint)
//        
//        
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            guard error == nil else { return }
//            guard let data = data else { return }
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary{
//                }
//            } catch let error {
//                print(error)
//            }
//            }.resume()
//        OperationQueue.main.addOperation({
//           // return json
//        })
//    }
}
