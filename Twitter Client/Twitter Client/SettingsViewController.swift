//
//  SettingsViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/26/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let sharedInstance = DataSource.sharedInstance
    
    var imagePickerController: UIImagePickerController!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Somewhat make the view a little prettier
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2 //make it round
        profileImageView.layer.masksToBounds = true
        
        //Load user information into the view
        if let currentUser = sharedInstance.currentUser {
            self.usernameLabel.text = currentUser.username
            self.yourNameLabel.text = currentUser.fullName
            self.profileImageView.image = currentUser.profilePicture
        }
        
        //Setup the image picker for later use
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Setup and add the tap gesture recognizer to the profile image view
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.editButtonTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Handle Button Taps
    @IBAction func editButtonTapped() {
        self.navigationController?.presentViewController(imagePickerController, animated: false, completion: nil)
    }

    @IBAction func logoutButtonTapped() {
        sharedInstance.logUserOut {
            //This is debatable utilizing the appdelegate to dictate application state here; however, in this scenario it worked the best
            guard let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return }
            let loginVC = LoginViewController()
            appDelegate.window?.rootViewController = loginVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    

    //MARK - UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.profileImageView.image = image
        sharedInstance.updateCurrentUserWith(image)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
