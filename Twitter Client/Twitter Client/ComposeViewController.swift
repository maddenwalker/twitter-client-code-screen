//
//  ComposeViewController.swift
//  Twitter Client
//
//  Created by Ryan Walker on 4/27/16.
//  Copyright © 2016 Ryan Walker. All rights reserved.
//

import UIKit

protocol ComposeViewType {
    var currentUser: User! { get set }
    var profileImageView: UIImageView! { get }
    var composeTitleLabel: UILabel! { get }
    var tweetComposeTextField: UITextView! { get }
    var tweetButton: UIButton! { get }
    var characterCountLabel: UILabel! { get }
    var cancelButton: UIButton! { get }
}

//!!!: Again, I did this all in code to just show versatility
class ComposeViewController: UIViewController, UITextViewDelegate {
    //Required Properties
    var currentUser: User!
    var profileImageView: UIImageView!
    var composeTitleLabel: UILabel!
    var tweetComposeTextField: UITextView!
    var tweetButton: UIButton!
    var characterCountLabel: UILabel!
    var cancelButton: UIButton!
    
    var characterCountLabelText: String!
    var characterCount: Int = 0
    let characterLimit: Int = 140
    
    let sharedInstance = DataSource.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.characterCountLabelText = "\(characterCount) / \(characterLimit)"
        //This would not safely fail in the event that there is no current user, in fact we should perform this check before allowing the user to hit the compose button
        if let currentUser = self.sharedInstance.currentUser {
            self.currentUser = currentUser
        }
        setupViewsInController()
    }
    
    //MARK: - Construction of UI elements

    func setupViewsInController() {
        //Init
        self.profileImageView = UIImageView(frame: CGRectMake(0, 0, 60, 60))
        self.composeTitleLabel = UILabel()
        self.tweetComposeTextField = UITextView()
        self.tweetButton = UIButton(type: .System)
        self.characterCountLabel = UILabel()
        self.cancelButton = UIButton(type: .System)
        
        self.cancelButton.setTitle("X", forState: .Normal)
        self.cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        self.cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 24) //Nice big x that is light
        self.cancelButton.sizeToFit()
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), forControlEvents: .TouchUpInside)
        
        self.tweetButton.setTitle("tweet!", forState: .Normal)
        self.tweetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.tweetButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        self.tweetButton.backgroundColor = trovColorBlue
        self.tweetButton.addTarget(self, action: #selector(self.tweetButtonTapped), forControlEvents: .TouchUpInside)
    
        self.profileImageView.image = currentUser.profilePicture
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
        self.profileImageView.layer.masksToBounds = true
        
        self.tweetComposeTextField.delegate = self
        self.tweetComposeTextField.returnKeyType = .Done
        self.tweetComposeTextField.layer.borderWidth = 0.05
        self.tweetComposeTextField.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.tweetComposeTextField.layer.cornerRadius = 8.0
        self.tweetComposeTextField.layer.masksToBounds = true
        
        self.characterCountLabel.text = self.characterCountLabelText
        self.characterCountLabel.textColor = UIColor.darkGrayColor()
        self.characterCountLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 14)
        
        let viewsArray = [self.profileImageView, self.composeTitleLabel, self.tweetComposeTextField, self.tweetButton, self.characterCountLabel, self.cancelButton]
        
        for view in viewsArray {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        layoutItemsInView()
    }
    
    //MARK: - Handle Button Taps
    
    func cancelButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tweetButtonTapped() {
        if let text = self.tweetComposeTextField.text {
            self.sharedInstance.createTweetWithText(text, withUser: self.currentUser)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: - UITextViewDelegate Methods
    func textViewDidChange(textView: UITextView) {
        self.characterCount = textView.text.characters.count
        self.characterCountLabel.text = "\(characterCount) / \(characterLimit)"
        if self.characterCount > self.characterLimit {
            self.characterCountLabel.textColor = UIColor.redColor()
            self.tweetButton.userInteractionEnabled = false
            self.tweetButton.backgroundColor = UIColor.lightGrayColor()
        } else {
            self.characterCountLabel.textColor = UIColor.darkGrayColor()
            self.tweetButton.userInteractionEnabled = true
            self.tweetButton.backgroundColor = trovColorBlue
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //Create a done button
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - Working with auto layout
    
    func layoutItemsInView() {
        let viewMargins = self.view.layoutMarginsGuide
        //Setup Cancel button
        self.cancelButton.leftAnchor.constraintEqualToAnchor(viewMargins.leftAnchor).active = true
        self.cancelButton.topAnchor.constraintEqualToAnchor(viewMargins.topAnchor, constant: 20).active = true
        self.cancelButton.widthAnchor.constraintEqualToAnchor(self.cancelButton.heightAnchor).active = true
        
        //Setup tweet button
        self.tweetButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        self.tweetButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
        self.tweetButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.tweetButton.heightAnchor.constraintEqualToConstant( self.view.frame.height / 8.0 ).active = true //This is a random selection without a good spec
        
        //Setup profile image view
        self.profileImageView.leftAnchor.constraintEqualToAnchor(viewMargins.leftAnchor, constant: 20.0).active = true
        self.profileImageView.topAnchor.constraintEqualToAnchor(self.cancelButton.bottomAnchor, constant: 20.0).active = true
        self.profileImageView.widthAnchor.constraintEqualToAnchor(self.profileImageView.heightAnchor, constant: 0.0).active = true //Aspect ratio
        self.profileImageView.heightAnchor.constraintEqualToConstant(60).active = true
        
        //Setup text field
        self.tweetComposeTextField.leftAnchor.constraintEqualToAnchor(self.profileImageView.rightAnchor, constant: 8).active = true
        self.tweetComposeTextField.rightAnchor.constraintEqualToAnchor(viewMargins.rightAnchor, constant: 0.0).active = true
        self.tweetComposeTextField.heightAnchor.constraintEqualToConstant(100).active = true
        self.tweetComposeTextField.topAnchor.constraintEqualToAnchor(self.profileImageView.topAnchor, constant: 0.0).active = true
        
        //Setup the characater count feedback
        self.characterCountLabel.centerXAnchor.constraintEqualToAnchor(self.profileImageView.centerXAnchor, constant: 0.0).active = true
        self.characterCountLabel.topAnchor.constraintEqualToAnchor(self.profileImageView.bottomAnchor, constant: 8.0).active = true
        
    }

}
