//
//  SettingsViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/26/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let sharedInstance = DataSource.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2 //make it round
        profileImageView.layer.masksToBounds = true
        
        if let currentUser = sharedInstance.currentUser {
            self.usernameLabel.text = currentUser.username
            self.yourNameLabel.text = currentUser.fullName
            self.profileImageView.image = currentUser.profilePicture
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func editButtonTapped() {
        //We need to ask for access to photos persmission here and then allow the user to change the current UIImage to users info
    }

    @IBAction func logoutButtonTapped() {
        sharedInstance.logUserOut {
            //This is debatable utilizing the appdelegate to dictate application state here; however, in this scenario it worked the best
            guard let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
            let loginVC = LoginViewController()
            appDelegate.window?.rootViewController = loginVC
            appDelegate.window?.makeKeyAndVisible()
            appDelegate.addObserverForLoginButtonPress()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
