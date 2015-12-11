//
//  InterfaceController.swift
//  B1Summit2016Watch Extension
//
//  Created by Speidel, Duncan on 11/5/15.
//  Copyright © 2015 Li, Yatsea. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit




struct MyDraft {
    
    static var draft = NSString()
    static var remoteNotice = NSDictionary()
   // static var
    
    
}

var watchSession : WCSession?


class InterfaceController: WKInterfaceController, WCSessionDelegate {
//class InterfaceController: WKInterfaceController {
   
    @IBOutlet var CardNameLabel: WKInterfaceLabel!
    
    @IBOutlet weak var DocTotalLabel:WKInterfaceLabel!
    
    @IBOutlet weak var DiscountPerentageLabel: WKInterfaceLabel!
    //@IBOutlet weak var CreditLimitLabel: WKInterfaceLabel!
    
    
    @IBOutlet weak var CurrentAccountBalanceLabel: WKInterfaceLabel!
    
    @IBOutlet weak var SalesPersonLabel: WKInterfaceLabel!
    


    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject])
    {
        //let action = identifier

        
        
        
        var draftNum = String()
        NSUserDefaults.standardUserDefaults().registerDefaults(remoteNotification as! [String: AnyObject])
        draftNum = remoteNotification.description
        draftNum = draftNum.stringByReplacingOccurrencesOfString("New approval request for sales order draft", withString: "")
        draftNum = draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        draftNum = draftNum.stringByReplacingOccurrencesOfString("[", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("aps:", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("{", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("}", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("=", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString(";", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("alert", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("category", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("myCategory", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("\"", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("body", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString(" ", withString:"")
        draftNum = draftNum.stringByReplacingOccurrencesOfString("]", withString:"")
        draftNum = draftNum.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        MyDraft.draft = draftNum
        //print("In handleActionWithIdentifier MyDrdt.draft =", MyDraft.draft)

        
        
        
        
    }//handleActionWithIdentifier for no action
    

    
    
    
    
    @IBAction func PressApprove(sender: AnyObject) {
 

        
        
        /*
        
        * No way to know elapsed time between when app start and approve button pushed, so a new connection is created to ensure Draft can be processed
        
        *TODO: Add a check for a live connection and use that if it exists
        
        */
        
        
        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies=true //capture session ID
        
        var bodyData = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        
        var stringForHandleAction = String()
        //handleActionWithIdentifier(stringForHandleAction, forRemoteNotification: <#T##[NSObject : AnyObject]#>)
        
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        var approvalLogon = NSString()
        
        
        /*
        
        * After logging on need to build payload body to approve the draft
        
        * Approval will be done in separate function
        
        */
        
        
        //let request = NSMutableURLRequest(URL: NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")!)
        request.HTTPMethod = "POST"
        let postString = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.ExecuteApproval (request)
        }
        task.resume()
        
        
        
    }//func PressApprove(sender: AnyObject)
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
    }

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activateSession()
        }

        
        func awakeWithContext(context: AnyObject?) {
            super.awakeWithContext(context)
            if let vcID = self.valueForKey("_viewControllerID") as? NSString {
                print("Page One:", vcID)
            }
        }
        
        
        
    }//willActivate
    func GetDraftDetails(request:NSMutableURLRequest) {
        
        /*
        
        * Reset variable used above to get the order new URL is:
        
        * http://54.191.40.200:50001/b1s/v1/Drafts(13)?$select=CardName,DocTotal,DiscountPercent" Done via GET
        
        * Need to change the verb to GET
        
        */
        
        var SLurl = NSURL()
        
        if MyDraft.draft.length == 0
            
        {
            
            SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Drafts(112)?$select=CardName,DocTotal,DiscountPercent")!
            //CardNameLabel.setText(MyDraft.draft as String)
        }else
            
        {
            
            SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Drafts(\(MyDraft.draft))?$select=CardName,DocTotal,DiscountPercent")!
            
            
            
        }
        
        
        
        
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl)
        
        request.HTTPMethod = "GET"
        
        var responseSLlogon = NSData()
        
        var orderDetails = NSString()
        
        
        
        /*
        
        * Call SL Drafts and get the order we received notice about
        
        */
        

        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            


            
            
            orderDetails = responseString!
            var CardName = self.GetOrderDetails(orderDetails)
            self.GetBPDetails(request, CardName: CardName)
        }
        task.resume()

        
        
        ///end addition
        
       
        
        
        
    }//Close GetDraftDetails

    func GetOrderDetails(orderDetails: NSString) -> String{
        
        var writeOut=false
        
        var localString = orderDetails as String
        
        var isComma=true
        
        var fieldCount = 0;
        
        var CardName = String()
        
        var DocTotal = String() //field 2
        
        var DiscountPercentage = String()
        
        
        
        
        
        
        
        for item in localString.characters
            
        {
            
            
            
            if (item == "," )
                
            {
                
                //testString = testString + String (item)
                
                writeOut=true
                
                isComma=true
                
                fieldCount++
                
                
                
                
                
                
                
            }//item = comma if
            
            
            
            
            
            if writeOut && !isComma && fieldCount==1
                
            {
                
                
                
                CardName = CardName + String (item)
                
                
                
                
                
            }else if !isComma && fieldCount==2 {
                
                DocTotal = DocTotal + String (item)
                
                
                
            }else if !isComma && fieldCount==3 {
                
                DiscountPercentage = DiscountPercentage + String (item)
                
            }
            
            
            
            isComma=false
            
            
            
        }//for
        
        
        
        
        
        //CardNameLabel.text = String()
        
        //substringToIndex(name.endIndex.predecessor())
        
        
        
        CardName = CardName.stringByReplacingOccurrencesOfString("\"", withString: "")
        CardName = CardName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        CardName = CardName.stringByReplacingOccurrencesOfString("CardName", withString: "Customer")
        CardName = CardName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        
        CardNameLabel.setText((CardName)) 
        DocTotal = DocTotal.stringByReplacingOccurrencesOfString("\"", withString: "")
        
        DocTotal = DocTotal.substringToIndex(DocTotal.endIndex.predecessor())
        
        DocTotal = DocTotal.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        
        DocTotal = DocTotal.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        DocTotal = DocTotal.stringByReplacingOccurrencesOfString("DocTotal", withString: "Amount")
        
        DocTotalLabel.setText(DocTotal)
        
        DiscountPercentage = DiscountPercentage.stringByReplacingOccurrencesOfString("\"", withString: "")
        DiscountPercentage = DiscountPercentage.stringByReplacingOccurrencesOfString("}", withString: "")
        DiscountPercentage = DiscountPercentage.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        //DiscountPercentage = DiscountPercentage.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        DiscountPercentage = DiscountPercentage.stringByReplacingOccurrencesOfString("DiscountPercent", withString: "Special Discount")
        DiscountPerentageLabel.setText(DiscountPercentage)

        
        return CardName
        
        
        
    }//GetOrderDetails
    
    func GetBPDetails(request:NSMutableURLRequest, CardName:String)
        
    {
        
        /*
        
        * Use request object to call SL BP
        
        * Will filter BP to one passed to use from calling function
        
        * Will confirm all parameters before executing call
        
        */
        
        
        
        /*
        
        * Clean up CardName for import now it is something like CardName" : "Parameter Technology" need to remove "CardName", semi-colon and change
        *
        * quotes around companyName into single, not doube, quotes
        *
        * Be careful with this code if your customer's name contains the word customer the remaing fields will not be shown
        *
        */
        
        
        
        var fixedCardName = CardName.stringByReplacingOccurrencesOfString("CardName", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        fixedCardName = CardName.stringByReplacingOccurrencesOfString("Customer", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString(":", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString("\"", withString:"'", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString("  ", withString: "")
        
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        
        //$select=CardName,DocTotal,DiscountPercent,DocNum,SalesPerson/SalesEmployeeName&$expand=SalesPerson
        
        
        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/BusinessPartners?$filter=CardName%20eq%20'\(fixedCardName)'&$select=CurrentAccountBalance,CreditLimit,SalesPerson/SalesEmployeeName&$expand=SalesPerson")
        
        
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod = "GET"
        
        var bpDetails = NSString()
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            data, response, error in
            
            
            
            if error != nil {
                
                print("error=\(error)")
                
                return
                
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
           
            bpDetails = responseString!
            
            self.GetBPInfo(bpDetails)
        }
        task.resume()
            
        
        
        
        
        
    } //GetBPDetails
    
    
    func GetBPInfo(bpDetails: NSString)
        
    {
        
        var writeOut=false
        
        var localString = bpDetails as String
        
        var isComma=true
        
        var fieldCount = 0
        
        var creditLimit = String ()
        
        var currentAccountBalance = String ()
        
        var salesPersonName = String()
        
        var salesPass = 0
        
        
        
        /*
        
        * Remove extra character sequences added by service layer
        
        */
        
        localString = localString.stringByReplacingOccurrencesOfString("\"odata.metadata\" : \"http://54.191.40.200:50001/b1s/v1/$metadata#BusinessPartners\",",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("{",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("}",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("[",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("]",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("{",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("\"value\"",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        localString = localString.stringByReplacingOccurrencesOfString("SalesPerson",withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
    
        
        
        for item in localString.characters
            
        {
            
            if item == "\""
                
            {
                
                writeOut = true
                
            }
            
            if fieldCount == 0
                
            {
                
                fieldCount++
                
            }
            
            if item == ","
                
            {
                
                fieldCount++
                
                isComma = true
                
                writeOut=false
                
            }
            
            
            
            
            
            
            
            if writeOut && !isComma && fieldCount==1
                
            {
                
                //Need to skip first : keep rest, better way to do buit no time to find
                
                if salesPass != 3
                    
                {
                    
                    salesPersonName = salesPersonName + String(item)
                    
                    
                    
                }
                
                salesPass++
                
            }else if !isComma && fieldCount==2
                
            {
                
                creditLimit = creditLimit + String(item)
                
                
                
            }else if !isComma && fieldCount==3
                
            {
                
                currentAccountBalance = currentAccountBalance + String (item)
                
                
                
            }
            
            isComma = false
            
            
            
        }//for
        
        
        
        /*
        
        * Built CreditLimit and AccountBalnce fields now need to show them on device
        
        */
        
        creditLimit = creditLimit.stringByReplacingOccurrencesOfString("\"", withString: "")
        
        creditLimit = creditLimit.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        /* 
         * For spacing I dropped creditLimit if it comes back this is where it gets assigned to the label
        CreditLimit.SetText (creditLimit)
        */
        
        
        



        currentAccountBalance = currentAccountBalance.stringByReplacingOccurrencesOfString("\"", withString: "")
        currentAccountBalance = currentAccountBalance.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        /*
         * This was needed previously but at the moment no data in var so commenting out for now
        currentAccountBalance = currentAccountBalance.substringToIndex(currentAccountBalance.endIndex.predecessor())
        */
        currentAccountBalance = currentAccountBalance.stringByReplacingOccurrencesOfString("CurrentAccountBalance", withString: "Bal: ")
        CurrentAccountBalanceLabel.setText(currentAccountBalance)
        
        salesPersonName = salesPersonName.stringByReplacingOccurrencesOfString("\"", withString: "")
        salesPersonName = salesPersonName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        salesPersonName = salesPersonName.stringByReplacingOccurrencesOfString("SalesEmployeeName", withString: "By: ")
        
        SalesPersonLabel.setText(salesPersonName)
        
        
        
    }//GetBPInfo
    
    func ExecuteApproval(request:NSMutableURLRequest)
        
    {
        
        
        
        
  
  // -Old Logon method depeciated      var bodyData = "{\n\"ApprovalRequest\": { \n\"Code\":15,\n\"ObjectType\":\"112\",\n\"IsDraft\":\"Y\",\n\"ObjectEntry\": 16,\n\"Status\": \"arsApproved\",\n\"Remarks\": \"ppp\",\n\"CurrentStage\": 7,\n\"OriginatorID\": 19,\n\"ApprovalRequestLines\": [\n{\n\"StageCode\": 7,\n\"UserID\": 1,\n\"Status\": \"arsApproved\",\n\"Remarks\": \"null\"\n}\n],\n\"ApprovalRequestDecisions\": [\n{\n\"ApproverUserName\": \"manager\",\n\"ApproverPassword\": \"1234\",\n\"Status\": \"ardApproved\",\n\"Remarks\": \"Approved and go ahead!\"\n}\n]\n}\n}"
        
       let postString = "{\n\"ApprovalRequest\": { \n\"Code\":15,\n\"ObjectType\":\"112\",\n\"IsDraft\":\"Y\",\n\"ObjectEntry\": 16,\n\"Status\": \"arsApproved\",\n\"Remarks\": \"ppp\",\n\"CurrentStage\": 7,\n\"OriginatorID\": 19,\n\"ApprovalRequestLines\": [\n{\n\"StageCode\": 7,\n\"UserID\": 1,\n\"Status\": \"arsApproved\",\n\"Remarks\": \"null\"\n}\n],\n\"ApprovalRequestDecisions\": [\n{\n\"ApproverUserName\": \"manager\",\n\"ApproverPassword\": \"1234\",\n\"Status\": \"ardApproved\",\n\"Remarks\": \"Approved and go ahead!\"\n}\n]\n}\n}"
        
        
      
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/ApprovalRequestsService_UpdateRequest")
        //var bodyData2 = "{\n\t\"ApprovalRequest\": { \n\t\"Code\":15,\n\t\"ObjectType\":\"112\",\n\t\"IsDraft\":\"Y\",\n\t\"ObjectEntry\": 16,\n\t\"Status\": \"arsApproved\",\n\t\"Remarks\": \"ppp\",\n\t\"CurrentStage\": 7,\n\t\"OriginatorID\": 19,\n\t\"ApprovalRequestLines\": [\n\t{\n\t\"StageCode\": 7,\n\t\"UserID\": 1,\n\t\"Status\": \"arsApproved\",\n\t\"Remarks\": \"ppp\"\n}\n],\n\"ApprovalRequestDecisions\": [\n{\n\"ApproverUserName\": \"manager\",\n\"ApproverPassword\": \"1234\",\n\"Status\": \"ardApproved\",\n\"Remarks\": \"Approved and go ahead!\"\n}\n]\n}\n}"
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://54.191.40.200:50001/b1s/v1/ApprovalRequestsService_UpdateRequest")!)
        var approvalStatus = NSData()
        
        var serviceLayerResult = NSString()
        
        //let request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod="POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }

            let responseString = (response)?.copy()
            let httpResponse = response as! NSHTTPURLResponse
            
            if httpResponse.statusCode == 204
                
            {
                
                
                self.showPopup(0)
                
                
                
                
            } else {
                
                
                self.showPopup(1)
                
            }//close if
            

        }
        task.resume()
        
    } //close ExecuteApproval


    

/*
 * Cant't use UIAlertController in WatchKit so adding a pop-up function
 * Actually a little nicer thn what I found for ViewController
 * TODO: Determine if something similar exists for ViewController
 */
    func showPopup(message:Int){
        
        let h0 = { print("ok")}
        
        let action1 = WKAlertAction(title: "Ok", style: .Default, handler:h0)
        let action2 = WKAlertAction(title: "Decline", style: .Destructive) {}
        let action3 = WKAlertAction(title: "Cancel", style: .Cancel) {}
        
        //presentAlertControllerWithTitle("Voila", message: "", preferredStyle: .ActionSheet, actions: [action1, action2,action3])
        if message == 0
        {
            presentAlertControllerWithTitle("Order Approved", message: "", preferredStyle: .ActionSheet, actions: [action1])


        } else if message == 1 {
            presentAlertControllerWithTitle("Order Approval failed", message: "", preferredStyle: .ActionSheet, actions: [action1])
            
        }
        
        
    }//showPopup

   override  init()
    {
        super.init()
        //var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")
        
        
        
        //--Round two ****
        let request = NSMutableURLRequest(URL: NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")!)
        request.HTTPMethod = "POST"
        let postString = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
            
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.GetDraftDetails(request)
        }
        task.resume()
        

    }//init
   
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
       //Works but might not be best idea ever exit(0)
    }
 

}
