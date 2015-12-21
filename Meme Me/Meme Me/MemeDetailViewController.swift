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
    var navBar : UINavigationBar!
    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var indexItem : Int!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImageView.image = memes[indexItem].memedImage
        setuUI()
    }
    
    
    func setuUI()
    {
        let  editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")
        navigationItem.rightBarButtonItem = editButton
    }
    
    func editMeme (){
        let memeEditorVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        memeEditorVC.meme = memes[indexItem]
        memeEditorVC.indexItem = indexItem
        navigationController?.presentViewController(memeEditorVC, animated: true, completion:nil)
    }
}
