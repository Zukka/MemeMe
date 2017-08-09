//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 08/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: IBOutlet
    @IBOutlet var myTableView: UITableView!
    
    // MARK: Variable
    var memes: [Meme]!
    var selectedItemList = UIImage()
    
    // MARK: Constant
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        myTableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeViewCell", for: indexPath) as! MemeTableViewCell

        // Configure the cell
        let meme = appDelegate.memes[indexPath.item]
        cell.listCellImageView.image = meme.memedImage
        cell.memeTopText.text! = meme.topString
        cell.memeBottomText.text! = meme.bottomString
        
        return cell
    }
    
    // MARK: - Navigation
    
    // Prepare and open MemeDetailViewController when tap on item list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemList = appDelegate.memes[indexPath.item].memedImage
        self.performSegue(withIdentifier: "segueToMemeDetailFromList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "segueToMemeDetailFromList":
                (segue.destination as! MemeDetailViewController).imageMeme = selectedItemList
            
            default:
                break
        }
    }
}
