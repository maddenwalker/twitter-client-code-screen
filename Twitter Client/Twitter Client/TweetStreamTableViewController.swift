//
//  TweetStreamTableViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

class TweetStreamTableViewController: UITableViewController, DataSourceDelegate {
    
    let dataSource = DataSource.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        //Make sure we show the navigation bar
        navigationController?.navigationBar.hidden = false
        self.title = "Feed"
        self.navigationController?.navigationBar.barTintColor = trovColorBlue
        self.tableView.tableFooterView = UIView(frame: CGRectZero) //Get rid of the separators between empty cells
        self.tableView.separatorColor = UIColor.lightGrayColor() //Make the separators less intrusive
        
        //Add support for fetching new items from JSON array with Refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refreshControlDidFire(_:)), forControlEvents: .ValueChanged)
        
        
        self.tableView.registerClass(MWTweetTableViewCell.self, forCellReuseIdentifier: "tweetCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
        let tweetComposeController = ComposeViewController()
        self.presentViewController(tweetComposeController, animated: true, completion: nil)
    }
    
    //MARK: - Handle table view interactions
    func refreshControlDidFire(sender: UIRefreshControl) {
        dataSource.fetchNewItems { 
            sender.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    //MARK: - DataSourceDelegate Methods
    func tweetItemsDidChange() {
        self.tableView.reloadData()
    }
    

}
