//
//  SentMemesTableViewController.swift
//  Meme Me V2
//
//  Created by Adhemar Soria Galvarro on 7/12/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//
import UIKit


class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)
        memes.removeAtIndex(indexPath.row)
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell", forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.memeTextLabel?.text = "\(meme.topTextField!)...\(meme.bottomTextField!)"
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.indexItem = indexPath.item
        
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    
}