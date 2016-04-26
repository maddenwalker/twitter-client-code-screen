//
//  LoginViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

let LoginViewControllerDidGetAccessTokenNotification = "LoginViewControllerDidGetAccessTokenNotification";

class LoginViewController: UIViewController {
    @IBOutlet weak var backgroundFilter: UIView!
    @IBOutlet weak var webViewBackground: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the navigation controller's bar for this one view
        navigationController?.navigationBar.hidden = true

        //Just for fun 🍻
        if let filePath = NSBundle.mainBundle().pathForResource("trov_bg_login", ofType: "gif") {
            let animatedGIFURL = NSURL(fileURLWithPath: filePath)
            let imageWidth = self.view.frame.width * 2 //Scale the image point by pixel
            let htmlString = "<html><body><img src='\(animatedGIFURL)' width='\(imageWidth)'></body></html>"
            webViewBackground.userInteractionEnabled = false
            webViewBackground.scalesPageToFit = true
            webViewBackground.loadHTMLString(htmlString, baseURL: NSURL())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        //We would receive an auth token here that would allow us to pass the variable through the notification center and our app delegate could then see that notification
        NSNotificationCenter.defaultCenter().postNotificationName(LoginViewControllerDidGetAccessTokenNotification, object: nil)
    }
    
    //MARK: - Working with the Status Bar Appearance
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
