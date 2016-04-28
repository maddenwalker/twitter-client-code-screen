//
//  LoginViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/25/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var backgroundFilter: UIView!
    @IBOutlet weak var webViewBackground: UIWebView!
    @IBOutlet weak var usernameTextField: UITextField!
    let dataSource: DataSource = DataSource.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the navigation controller's bar for this one view
        navigationController?.navigationBar.hidden = true
        usernameTextField.delegate = self

        //Just for fun 🍻
        if let filePath = NSBundle.mainBundle().pathForResource("trov_bg_login", ofType: "gif") {
            let animatedGIFURL = NSURL(fileURLWithPath: filePath)
            let imageWidth = self.view.frame.width * 2 //Scale the image point by pixel
            let htmlString = "<html><body><img src='\(animatedGIFURL)' width='\(imageWidth)'></body></html>"
            webViewBackground.opaque = false
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
        submitLogin()
    }
    
    //MARK: - Working with the Status Bar Appearance
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Login Actions
    func submitLogin() {
        if let username = usernameTextField.text {
            dataSource.logUserIn(withUsername: username)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let navVC = mainStoryboard.instantiateInitialViewController() as? UINavigationController
            appDelegate.window?.rootViewController = navVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
