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

}
