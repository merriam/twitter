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
        TwitterClient().loginWithCompletion() {
            (user: User?, failure:  NSError?) -> Void in
            if user != nil {
                // preform segue
            } else {
                // handle login error
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

