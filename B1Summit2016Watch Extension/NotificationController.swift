//
//  NotificationController.swift
//  B1Summit2016Watch Extension
//
//  Created by Speidel, Duncan on 11/5/15.
//  Copyright © 2016 Speidel, Duncan. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {

    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

  
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        
        //MyDraft.draft = "In didReceiveLocalNotification"
        completionHandler(.Custom)
    }

    
  
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a remote notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
 
/*commenting out to test if code not required switching to function in Interface Controller
        if let remoteaps:NSDictionary = remoteNotification["aps"] as? NSDictionary{
            if let remoteAlert:NSDictionary = remoteaps["alert"] as? NSDictionary{
                handleNotification( remoteAlert );
            }
        }
        
        
End InterfaceController code comment */
        
        let interface = WKUserNotificationInterfaceType.Default
        
        completionHandler(interface)
  
    
    }//Close
 
    func handleNotification( alert : AnyObject? ){
            //self.alertLabel!.setText(remotetitle);
            //self.
        
        //if let alert: AnyObject = alert, let remotebody = alert["body"] as? String{
            let remotebody = alert!["body"] as? String
            let draftNum = remotebody!.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")

            MyDraft.draft = draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            //print ("In handleNotification MyDraft.dradt = ",MyDraft.draft)
            
        
        
    }//close handleNotification
    

    
}
