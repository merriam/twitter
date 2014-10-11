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
    
    var loginCompletion: ((user:User?, error: NSError?) -> Void)?
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL:  twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user:User?, error: NSError?) -> Void) -> Void {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oath"), scope: nil,
            success: { (requestToken:BDBOAuthToken!) -> Void in
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL)
            },
            failure: { (error: NSError!) -> Void in
                println("Failed to get the token.")
                self.loginCompletion?(user: nil, error: error)
        })
        
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method:"POST",
            requestToken: BDBOAuthToken(queryString: url.query),
            success: { (accessToken:  BDBOAuthToken!) -> Void in
                self.requestSerializer.saveAccessToken(accessToken)
                self.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: {  (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        
                        var user = User(dictionary: response as NSDictionary)
                        println("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure:  { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("9.")
                        
                        println("failed in operation")
                        self.loginCompletion?(user: nil, error: error)
                })
                
                TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil,
                    success: {  (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        println("10.")
                        
                        // println("home timeline: \(response)")
                        var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                        
                        for tweet in tweets {
                            println("text: \(tweet.text), created: \(tweet.createdAt)")
                        }
                    },
                    failure:  { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("11.")
                        
                        println("failed in getting home timeline")
                })
            },
            failure: { (error:  NSError!) -> Void in
                println("error getting fetching token on return")
                self.loginCompletion?(user: nil, error: error)
        })

    }
}
