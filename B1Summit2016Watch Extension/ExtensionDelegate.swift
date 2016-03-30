//
//  ExtensionDelegate.swift
//  B1Summit2016Watch Extension
//
//  Created by Speidel, Duncan on 11/5/15.
//  Copyright © 2015 Li, Yatsea. All rights reserved.
//

import WatchKit
import UIKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func didReceiveRemoteNotification(_userInfo: [NSObject : AnyObject]){
        /*
         * Used to unbundle the NSDictonary object that we receive from APN
         */
        
        
        if let aps = _userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                    print ("In do stuff area", message)
                    //let draftNum = alert.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")
                    var draftNum = alert.description
                    draftNum = draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    draftNum = draftNum.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")
                    MyDraft.draft=draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    
                }
            } else if let alert = aps["alert"] as? NSString {
                
                
                //let draftNum = alert.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")
                var draftNum = alert.description
                draftNum = draftNum.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")
                draftNum = draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                MyDraft.draft=draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

                //MyDraft.draft=draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                

                
                
                
            }
        }

        print ("MyDraft.draft=",MyDraft.draft)
            
        
    } //DidReceiveRemoteNotification
  

    
}
