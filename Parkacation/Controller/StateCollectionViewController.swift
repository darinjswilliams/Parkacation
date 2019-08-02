//
//  StateCollectionViewController.swift
//  Parkacation
//
//  Created by Darin Williams on 7/28/19.
//  Copyright © 2019 dwilliams. All rights reserved.
//

import UIKit
import Firebase


class StateCollectionViewController: UICollectionViewController {

    
    var allStates = [USFlags]()
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!
    
    var flagData = [String]()

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden
        
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        //Retrieve the data and listen to any changes
        _refHandle = ref?.child("data").observe(.childAdded, with: { (snapshot) in
            // execude code
            self.flagData.append("")
        })
        
        //MARK CALL FLAG API
//        callFlagApi(url: EndPoints.usflags.url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allStates.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return allStates.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sfCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StateFlagCollectionViewCell", for: indexPath) as! StateFlagCollectionViewCell

        // Configure the cell
        sfCell.label.text = allStates[indexPath.row].abbrname
        sfCell.photoImage.image = UIImage(named: allStates[indexPath.row].flagimage)
    
        return sfCell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
