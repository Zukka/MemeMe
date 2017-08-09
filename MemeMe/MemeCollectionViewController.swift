//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 08/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {

    // MARK: IBOutlet
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var myCollectionView: UICollectionView!
    
    // MARK: Variable
    var memes: [Meme]!
    var selectedItemList = UIImage()
    
    // MARK: Constant
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Load Meme on start is not required for MemeMe 2.0 app
        // https://discussions.udacity.com/t/how-to-load-pre-existing-meme-upload-opening-the-app/248993

    }

    override func viewWillAppear(_ animated: Bool) {
        myCollectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueToMemeDetailFromGrid":
            (segue.destination as! MemeDetailViewController).imageMeme = selectedItemList
            
        default:
            break
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        
        let meme = appDelegate.memes[indexPath.item]
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        selectedItemList = appDelegate.memes[indexPath.item].memedImage
        self.performSegue(withIdentifier: "segueToMemeDetailFromGrid", sender: nil)

        return true
    }

}
