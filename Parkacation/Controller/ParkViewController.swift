//
//  ParkViewController.swift
//  Parkacation
//
//  Created by Darin Williams on 7/31/19.
//  Copyright © 2019 dwilliams. All rights reserved.
//

import UIKit
import Firebase

class ParkViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource
{
    
@IBOutlet weak var collectionView: UICollectionView!
    
@IBOutlet weak var flowLayOut: UICollectionViewFlowLayout!
    
var allStates = [USFlags]()
var ref: DatabaseReference!
var storageRef: StorageReference!
    

    

    
fileprivate var _refHandle: DatabaseHandle!
    
var flagData: [DataSnapshot]! = []
let imageCache = NSCache<NSString, UIImage>()
 var placeholderImage = UIImage(named: "tx.png")
    

override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
}

    
    fileprivate func configureDatabase() {
        //MARK CALL FLAG API
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        //Retrieve the data and listen to any changes
        _refHandle = ref?.child("data").observe(.childAdded) { (snapshot: DataSnapshot) in
            // execude code
            
            //convert data to string
            self.flagData.append(snapshot)
            self.collectionView.insertItems(at: [IndexPath(row: self.flagData.count - 1, section: 0)])
            
            //reload table view
        }
    }
    
    fileprivate func configureStorage() {
        storageRef = Storage.storage().reference()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        configureDatabase()
        configureStorage()
        
        
//        self.callFlagApi(url: EndPoints.usflags.url)
        
    }
    
    //Mark Call Parse API to get Photos
    func callFlagApi (url: URL) {
        
        ParkApi.getNationalParks(url: url, completionHandler: self.handleGetFlags(photos:error:))
    }
    
    
    func handleGetFlags(photos:[USFlags]?, error:Error?) {
        
        guard let photos = photos else{
            
            debugPrint("no data")
            return
        }
        
        allStates = photos
    }
    

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   return flagData.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let sfCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StateFlagCollectionViewCell", for: indexPath) as! StateFlagCollectionViewCell
    
    // Configure the cell
    let flagSnapshot  = flagData[indexPath.row]
    let stateFlags = flagSnapshot.value as! [String: String]
     let fullName = stateFlags[AllStates.fullname] ?? "[fullname]"
     let imageLink = stateFlags[AllStates.flagimage] ?? "[flagimage]"
    debugPrint("here is the state \(fullName)")
    debugPrint("here is the image for state \(imageLink)")
    
    if let imageUrl = stateFlags[AllStates.flagimage] {
       
        // image already exists in cache
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            sfCell.photoImage.image = cachedImage
            sfCell.setNeedsLayout()
        } else {
            // download image
            //  gs://parkacation.appspot.com/us_flags
            storageRef.downloadURL(completion: { (data, error) in
                guard error == nil else {
                    print("Error downloading: \(error!)")
                    return
                }
                let messageImage = UIImage.init(data: data!, scale: 50)
                self.imageCache.setObject(messageImage!, forKey: imageUrl as NSString as NSString)
                // check if the cell is still on screen, if so, update cell image
                if sfCell ==  collectionView.cellForItem(at: indexPath) {
                    DispatchQueue.main.async {
                        sfCell.photoImage.image = messageImage
                        sfCell.setNeedsLayout()
                    }
                }
            })
            
//            Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX, completion: { (data, error) in
//                guard error == nil else {
//                    print("Error downloading: \(error!)")
//                    return
//                }
//                let messageImage = UIImage.init(data: data!, scale: 50)
//                self.imageCache.setObject(messageImage!, forKey: imageUrl as NSString as NSString)
//                // check if the cell is still on screen, if so, update cell image
//                if sfCell ==  collectionView.cellForItem(at: indexPath) {
//                    DispatchQueue.main.async {
//                        sfCell.photoImage.image = messageImage
//                        sfCell.setNeedsLayout()
//                    }
//                }
//            })
        }
    } else {
        // otherwise, update cell for regular message
        
        sfCell.photoImage.image  = placeholderImage
    }
    
    return sfCell
}
  


}
