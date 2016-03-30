//
//  AppDelegate.swift
//  B1Summit2016
//
//  Created by SAP on 9/30/15.
//  Copyright © 2016 Speidel, Duncan. All rights reserved.
// Watch version

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var vc = ViewController.self
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let types: UIUserNotificationType = UIUserNotificationType.Badge
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData )
    {
        
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        MyDraft.deviceToken = deviceTokenString
        print( deviceTokenString )
        //self.RegisterPhone()
        
        /*
         * Tried to do the steps below in a separate function but couldn't find a way to extend class appDelegate, will revisit this in the future
         * when I have more time
        */
        
        //Register Phone with HANA
        
        
        //https://54.191.40.200:4300/B1APN/B1APN.xsjs?token=4b3230c2c417611326d7f3211b5c415de76f810d44899983c05007ec93ee1bed
        
        
        
        
        
        var B1APNXSJS = NSURL()
        
        //Switching to plain text to avoid issues with self signed certificate
        MyDraft.deviceToken =  MyDraft.deviceToken.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        B1APNXSJS = NSURL(string: "http://54.191.40.200:8000/B1APN/B1APN.xsjs?token=\(MyDraft.deviceToken)")!
        
        let xsjsRequest:NSMutableURLRequest = NSMutableURLRequest(URL:B1APNXSJS)
        
        
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(xsjsRequest) {
            
            data, response, error in
            
            
            
            if error != nil {
                
                print("error=\(error)")
                
                return
                
            }       
            
            
            
            
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
        }
        
        task.resume()
        
    }//didRegisterForRemoteNotifications
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        
        print( error.localizedDescription )
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler:(UIBackgroundFetchResult) -> Void)
    {
        /*
        * Used to unbundle the NSDictonary object that we receive from APN
        */
        

        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                    print ("In do stuff area")
                }
            } else if let alert = aps["alert"] as? NSString {
                
                let draftNum = alert.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")
                
                MyDraft.draft=draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                //We have received an order number from APN lets logon to service layer and get the details
                
                
                vc.initialize()
                //self.window?.rootViewController
                
                vc.initialize()
                //vc.init().LogonServiceLayer()
                
                //vc.init()
                //.CardNameLabel)
                
                
                
            }
        }
        
        
        completionHandler (.NoData) //Need this to close handler or iOS complains
        
    }//End didReceiveRemoteNotification
    
  //func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData )
    //func application (application: UIApplication, RegiserPhone)
    //class AppDelegate{
    
    func  RegiserPhone()
    {
        //https://54.191.40.200:4300/B1APN/B1APN.xsjs?token=4b3230c2c417611326d7f3211b5c415de76f810d44899983c05007ec93ee1bed
        
        
        var B1APNXSJS = NSURL()
        B1APNXSJS = NSURL(string: "https://54.191.40.200:4300/B1APN/B1APN.xsjs?token=\(MyDraft.deviceToken)")!
        let xsjsRequest:NSMutableURLRequest = NSMutableURLRequest(URL:B1APNXSJS)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(xsjsRequest) {
            data, response, error in

            if error != nil {
            print("error=\(error)")
            return
            }       


            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        }
        task.resume()





    }//close RegisterPhone


}//Close class

