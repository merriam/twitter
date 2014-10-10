//
//  ViewController.swift
//  twitter
//
//  Created by Charles Merriam on 10/6/14.
//  Copyright (c) 2014 Charles Merriam. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onLogin(sender: AnyObject) {
        println("1.  In onLogin")
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        println("2.")
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oath"), scope: nil,
            success: { (requestToken:BDBOAuthToken!) -> Void in
                println("3.")
                println("Got the request token successfully")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                println("authURL=\(authURL)")
                UIApplication.sharedApplication().openURL(authURL)
                println("4.")

            },
            failure: { (error: NSError!) -> Void in
                println("Failed to get the token.")
            })
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

