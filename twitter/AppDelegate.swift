//
//  AppDelegate.swift
//  twitter
//
//  Created by Charles Merriam on 10/6/14.
//  Copyright (c) 2014 Charles Merriam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        println("5.")
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token",
            method:"POST",
            requestToken: BDBOAuthToken(queryString: url.query),
            success: { (accessToken:  BDBOAuthToken!) -> Void in
                println("got the access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                println("6.")
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: {  (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        println("8.")
                        
                        println("user: \(response)")
                        var user = User(dictionary: response as NSDictionary)
                        println("user: \(user.name)")
                    },
                    failure:  { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("9.")
                        
                        println("failed in operation")
                })
                
                TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil,
                    success: {  (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        println("10.")
                        
                        // println("home timeline: \(response)")
                    },
                    failure:  { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("11.")
                        
                        println("failed in getting home timeline")
                })
            },
            failure: { (error:  NSError!) -> Void in
                println("error getting fetching token on return")
            })
        println("7.")

        println("--------- Now get user name")
        return true
    }
}

