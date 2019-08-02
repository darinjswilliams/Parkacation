//
//  File.swift
//  Parkacation
//
//  Created by Darin Williams on 7/30/19.
//  Copyright © 2019 dwilliams. All rights reserved.
//

import Foundation

class ParkApi {

class func getNationalParks(url: URL, completionHandler: @escaping ([USFlags]?, Error?)-> Void){
 
    taskForGETRequest(url: url) { (response, error) in
        guard let response = response else {
            debugPrint("requestforPhotos: Failed")
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
            return
        }
        debugPrint("request for photos: good")
        DispatchQueue.main.async {
            completionHandler(response, error)
        }
    }
}
    
    
    class func taskForGETRequest(url: URL, completionHandler: @escaping ([USFlags]?, Error?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        
        request.addValue("Content-Type", forHTTPHeaderField: "application/json")
        request.httpMethod = AuthenticationUtils.headerGet
        
        print("here is the url \(request)")
        
        
        let downloadTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            // guard there is data
            guard let data = data else {
                // TODO: CompleteHandler can return error
                debugPrint("data is null")
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let response = try? jsonDecoder.decode(AllFlags.self, from: data)
                debugPrint("data from firebase..\(response)")
                DispatchQueue.main.async {
                    completionHandler(response?.results, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
            }
        }
        
        downloadTask.resume()
        
        return downloadTask
    }

}
