//
//  SentMemeCollectionViewController.swift
//  Meme Me
//
//  Created by Adhemar Soria Galvarro on 7/12/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//


import UIKit

private let reuseIdentifier = "SentMemeCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space : CGFloat = 3.0
        let itemWidth = (view.frame.size.width - (2 * space)) / space
        let itemHeight = (view.frame.size.height - (2 * space)) / space
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.item]
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = memes[indexPath.item]
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
