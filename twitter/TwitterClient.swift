//
//  TwitterClient.swift
//  twitter
//
//  Created by Charles Merriam on 10/6/14.
//  Copyright (c) 2014 Charles Merriam. All rights reserved.
//

import UIKit

let twitterConsumerKey = "SfZBopM3Aou7M62rF8h0zRDBm"
let twitterConsumerSecret = "GC3huL7bKzlzgS0d6OqY2tbFN6ResvDsm8kyGpDs8updNRX56f"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL:  twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
        }
        return Static.instance
    }
}
