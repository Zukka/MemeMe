//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 09/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var memeImageDetail: UIImageView!
    
    //MARK: Variables
    var imageMeme = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImageDetail.image = imageMeme
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
