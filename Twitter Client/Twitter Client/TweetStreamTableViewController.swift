//
//  TweetStreamTableViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

class TweetStreamTableViewController: UITableViewController {
    
    let dataSource = DataSource.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        //Make sure we show the navigation bar
        navigationController?.navigationBar.hidden = false
        self.title = "Your Awesome Tweet Feed"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 17.0 / 255.0, green: 133.0 / 255.0, blue: 208.0 / 255.0, alpha: 1) //Trov Blue
        self.tableView.tableFooterView = UIView(frame: CGRectZero) //Get rid of the separators between empty cells
        self.tableView.separatorColor = UIColor.lightGrayColor() //Make the separators less intrusive
        
        self.tableView.registerClass(MWTweetTableViewCell.self, forCellReuseIdentifier: "tweetCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tweetItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MWTweetTableViewCell {
        let cell: MWTweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! MWTweetTableViewCell
        cell.setTweetItem(dataSource.tweetItems[indexPath.row])
        return cell
    }
    
    //We need to estimate the height of these cells based on the size of the tweet
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let optimalHeight = MWTweetTableViewCell.heightForTweetItem(dataSource.tweetItems[indexPath.row], andWidth: CGRectGetWidth(self.view.frame))
        return optimalHeight
    }
    
    //MARK: - Handle Button Taps
    
    @IBAction func composeButtonTapped() {
        
        
    }
    

}
