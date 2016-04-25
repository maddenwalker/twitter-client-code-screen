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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
