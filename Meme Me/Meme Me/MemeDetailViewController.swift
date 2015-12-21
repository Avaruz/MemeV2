//
//  MemeDetailViewController.swift
//  Meme Me V2
//
//  Created by Adhemar Soria Galvarro on 7/12/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var meme: Meme!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImageView.image = meme.memedImage
    }
}
