//

//  ViewController.swift

//  ServiceLayer

//

//  Created by Speidel, Duncan on 10/6/15.

//  Copyright © 2015 Speidel, Duncan. All rights reserved.

// Watch version



import UIKit
import WatchKit
import Foundation
import WatchConnectivity


@available(iOS 9.0, *)
var watchSession : WCSession?


struct MyDraft {
    
    static var draft = NSString()
    static var deviceToken = String()
    
}






class ViewController: UIViewController, WCSessionDelegate {
   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* 
         * Setup wath communication channels
        */
        
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
        //var watchSession : WCSession?
        
        /*
        
        *Now logon called from AppDelegate after a APN is received
        
        */

        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies=true //trying to capture session ID
        
        var bodyData = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        var responseSLlogon = NSData()
        
        var sessionID=NSString()
        
        
        
        
        
        
        
        
        
        
        
        //responseSLlogon = nil
        
        
        
        
        
        //request.HTTPBody = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            
            {
                (response, data, error) in
                
                
                
                responseSLlogon = data!
                
                sessionID  = NSString(data: responseSLlogon, encoding: NSUTF8StringEncoding)!
                
                if MyDraft.draft.length == 0
                    
                {
                    
                    SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Drafts(112)?$select=CardName,DocTotal,DiscountPercent")
                    
                    //print ("Using draft = 13")
                    
                }else{
                    
                    SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Drafts(\(MyDraft.draft))?$select=CardName,DocTotal,DiscountPercent")
                    
                    //print("Using value of myDrafts.draft", MyDraft.draft)
                    
                }
                

                
                self.DeviceTokenText.text = MyDraft.deviceToken.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                self.DeviceTokenText.text = self.DeviceTokenText.text
                self.DeviceTokenText.hidden = false
                
                
                let requestObj = NSURLRequest(URL: SLurl!)
                
                //self.ServiceLayerWebView.loadRequest(requestObj);
                
                //var elementCount = self.ServiceLayerWebView.
                
                self.GetDraftDetails(request)
                
                
                
                
                
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    func LogonServiceLayer(){
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        
        * Working on adding web content
        
        * 54.191.40.200 is the elastic IP address used for the HANA server
        
        */
        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies=true //trying to capture session ID
        
        var bodyData = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        var responseSLlogon = NSData()
        
        var sessionID=NSString()
        
        
        
        
        
        
        
        
        
        
        
        //responseSLlogon = nil
        
        
        
        
        
        //request.HTTPBody = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            
            {
                
                (response, data, error) in
                
                
                
                responseSLlogon = data!
                
                sessionID  = NSString(data: responseSLlogon, encoding: NSUTF8StringEncoding)!
                
                //                 v1/BusinessPartners?$filter=CardName%20eq%20'\(fixedCardName)'&
                
                
                
                //Works but hard codedSLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Drafts(12)?$select=CardName,DocTotal,DiscountPercent")
                
                
                
                SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Drafts(\(MyDraft.draft))?$select=CardName,DocTotal,DiscountPercent")
               
                let requestObj = NSURLRequest(URL: SLurl!)
                
                //self.ServiceLayerWebView.loadRequest(requestObj);
                
                //var elementCount = self.ServiceLayerWebView.
                
                self.GetDraftDetails(request)
                
                
                
                
                
        }
        
        
        
    }//Close SL logon func
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    
    
    
    
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
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            
            {
                
                (response, data, error) in
                
                responseSLlogon = data!
                
                
                
                orderDetails  = NSString(data: responseSLlogon, encoding: NSUTF8StringEncoding)!
                
                let requestObj = NSURLRequest(URL: SLurl)
                
                //self.ServiceLayerWebView.loadRequest(requestObj);
                
                
                
                var CardName = self.GetOrderDetails(orderDetails)
                
                self.GetBPDetails(request, CardName: CardName)
                
                
                
                
                
                
                
        }//Close NSURLConnection
        
        
        
        
        
    }//Close GetDraftDetails
    
    func GetBPDetails(request:NSMutableURLRequest, CardName:String)
        
    {
        
        /*
        
        * Use request object to call SL BP
        
        * Will filter BP to one passed to use from calling function
        
        * Will confirm all parameters before executing call
        
        */
        
        
        
        /*
        
        * Clean up CardName for import now it is something like CardName" : "Parameter Technology" need to remove "CardName", semi-colon and change
        
        * quotes around companyName into single, not doube, quotes
        
        */
        
        
        
        var fixedCardName = CardName.stringByReplacingOccurrencesOfString("CardName", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString(":", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString("\"", withString:"'", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString("  ", withString: "")
        
        fixedCardName = fixedCardName.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        //$select=CardName,DocTotal,DiscountPercent,DocNum,SalesPerson/SalesEmployeeName&$expand=SalesPerson
        
        print("fixedCardName=", fixedCardName)
        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/BusinessPartners?$filter=CardName%20eq%20'\(fixedCardName)'&$select=CurrentAccountBalance,CreditLimit,SalesPerson/SalesEmployeeName&$expand=SalesPerson")
        
        
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod = "GET"
        
        var bpDetails = NSString()
        
        var responseSLlogon = NSData()
        
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            
            {
                (response, data, error) in
                
                bpDetails = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                
                self.GetBPInfo(bpDetails)
                
                
                
        }
        
        
        
        
        
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
        
        if creditLimit.rangeOfString("0.0") != nil
        {
            //Turn 0.0 into just 0
            creditLimit = creditLimit.substringToIndex(creditLimit.endIndex.predecessor())
            CreditLimitLabel.text = creditLimit.stringByReplacingOccurrencesOfString(".", withString: "")
        }else{
            
            CreditLimitLabel.text = creditLimit
        }
        CreditLimitLabel.hidden=false
        
        
    
        currentAccountBalance = currentAccountBalance.stringByReplacingOccurrencesOfString("\"", withString: "")

        currentAccountBalance = currentAccountBalance.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //Make output pretty
        if currentAccountBalance.rangeOfString("0.0") != nil
        {
            //remove .0 from display
            currentAccountBalance = currentAccountBalance.substringToIndex(currentAccountBalance.endIndex.predecessor())
            //remove . from display
            CurrentAccountBalanceLabel.text = currentAccountBalance.stringByReplacingOccurrencesOfString(".", withString: "")
        }else{
            CurrentAccountBalanceLabel.text = currentAccountBalance.substringToIndex(currentAccountBalance.endIndex.predecessor())
    
        }
            CurrentAccountBalanceLabel.hidden = false
        
        salesPersonName = salesPersonName.stringByReplacingOccurrencesOfString("\"", withString: "")
        
        salesPersonName = salesPersonName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        salesPersonName = salesPersonName.stringByReplacingOccurrencesOfString("SalesEmployeeName", withString: "Sales Employee")
        
        SalesPersonLabel.text = salesPersonName
        
        SalesPersonLabel.hidden=false
        
        
        
        
        
    }//GetBPInfo
    
    
    
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
        
        CardNameLabel.text = CardName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        CardNameLabel.text = CardNameLabel.text?.stringByReplacingOccurrencesOfString("CardName", withString: "Customer")
        
        CardName = CardName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        
        
        DocTotal = DocTotal.stringByReplacingOccurrencesOfString("\"", withString: "")
        DocTotal = DocTotal.substringToIndex(DocTotal.endIndex.predecessor())
        DocTotal = DocTotal.stringByReplacingOccurrencesOfString(".0", withString: "")
        
        //DocTotal = DocTotal.substringToIndex(DocTotal.endIndex.predecessor())
        
        DocTotalLabel.text = DocTotal.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        DocTotalLabel.text = DocTotalLabel.text?.stringByReplacingOccurrencesOfString("DocTotal", withString: "Amount")
        
        DiscountPercentage = DiscountPercentage.stringByReplacingOccurrencesOfString("\"", withString: "")
        DiscountPercentage = DiscountPercentage.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if DiscountPercentage.rangeOfString("0.0") != nil
        {
           //turn 0.0 inot 0           
            DiscountPerentageLabel.text = DiscountPercentage.stringByReplacingOccurrencesOfString(".0", withString: "")
           
        }else{
            DiscountPerentageLabel.text = DiscountPercentage
        }
        
        
        
        //Not needed? DiscountPerentageLabel.text = DiscountPercentage.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        DiscountPerentageLabel.text = DiscountPerentageLabel.text?.stringByReplacingOccurrencesOfString("DiscountPercent", withString: "Special Discount")
        
        
        CardNameLabel.hidden=false
        
        DocTotalLabel.hidden=false
        
        DiscountPerentageLabel.hidden=false
        
        return CardName
        
        
        
    }
    
    
    
    func DislayCodeFromSL(sessionID: NSString){
        
        
        
        var funcOption = NSStringCompareOptions()
        
        var containsSessionID = sessionID.rangeOfString("SessionId", options:funcOption )
        
        var localString = sessionID as String
        
        var testString = String()
        
        var writeOut = Bool ()
        
        writeOut=false
        
        var isComma=true
        
        
        
        
        
        for item in localString.characters
            
        {
            
            
            
            if (item == "," )
                
            {
                
                //testString = testString + String (item)
                
                writeOut=true
                
                isComma=true
                
                
                
                
                
                
                
                
                
                
                
            }//item = comma if
            
            
            
            
            
            if writeOut && !isComma
                
            {
                
                
                
                //CardName = CardName + String (item)
                
                testString = testString + String (item)
                
                
                
                
                
            }//writeOut abd is Comma if
            
            
            
            isComma=false
            
            
            
        }//for
        
        
        
    }//close func
    
    

    
    
    @IBOutlet weak var CardNameLabel: UILabel!

    @IBOutlet weak var DocTotalLabel: UILabel!
    
    @IBOutlet weak var DiscountPerentageLabel: UILabel!
    @IBOutlet weak var CreditLimitLabel: UILabel!
    
 
    @IBOutlet weak var CurrentAccountBalanceLabel: UILabel!
    
    @IBOutlet weak var SalesPersonLabel: UILabel!
    
    
    //@IBOutlet weak var DeviceToken: UILabel!
    
    
    @IBOutlet weak var DeviceTokenText: UITextField!
    
    @IBAction func messageChanged(sender: AnyObject) {
        if let message : String = CardNameLabel.text {
            do {
                try watchSession?.updateApplicationContext(
                    ["message" : message]
                )
            } catch let error as NSError {
                NSLog("Updating the context failed: " + error.localizedDescription)
                print("In messenge else of sift controller")
            }
        }
    }
    
    
    @IBAction func PressApprove(sender: AnyObject) {
        
    
        
        /*
        
        * Would like to use existing connection but no way to know time between when user connected and when user approves the order'
        
        * Will establish a connection then approve the order
        
        * Will use SL object /b1s/v1/ApprovalRequests('18')
        
        * Need to change code to also grab Draft # when getting Draft
        
        * Should be ok, draft number should be received when call comes from .Net
        
        */
        
        
        
        
        
        /*
        
        * No way to know elapsed time between when app start and approve button pushed, so a new connection is created to ensure Draft can be processed
        
        *TODO: Add a check for a live connection and use that if it exists
        
        */
        
        
        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/Login")
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod = "POST"
        
        request.HTTPShouldHandleCookies=true //capture session ID
        
        var bodyData = "{\"UserName\":\"manager\", \"Password\":\"1234\", \"CompanyDB\":\"SBODEMOUS\"}"
        
        
        
        
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        var approvalLogon = NSString()
        
        var responseSLlogon = NSData()
        
        /*
        
        * After logging on need to build payload body to approve the draft
        
        * Approval will be done in separate function
        
        */
        
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            
            {
                
                (response, data, error) in
                
                approvalLogon  = NSString(data: responseSLlogon, encoding: NSUTF8StringEncoding)!
                
                
                
                let requestObj = NSURLRequest(URL: SLurl!)
                
                self.ExecuteApproval (request)
                
                
                
                
                
        }
        
        
        
        
        
    }//func PressApprove(sender: AnyObject)
    
    
    
    func ExecuteApproval(request:NSMutableURLRequest)
        
    {
        
        
        
        
        
        var bodyData = "{\n\"ApprovalRequest\": { \n\"Code\":15,\n\"ObjectType\":\"112\",\n\"IsDraft\":\"Y\",\n\"ObjectEntry\": 16,\n\"Status\": \"arsApproved\",\n\"Remarks\": \"ppp\",\n\"CurrentStage\": 7,\n\"OriginatorID\": 19,\n\"ApprovalRequestLines\": [\n{\n\"StageCode\": 7,\n\"UserID\": 1,\n\"Status\": \"arsApproved\",\n\"Remarks\": \"null\"\n}\n],\n\"ApprovalRequestDecisions\": [\n{\n\"ApproverUserName\": \"manager\",\n\"ApproverPassword\": \"1234\",\n\"Status\": \"ardApproved\",\n\"Remarks\": \"Approved and go ahead!\"\n}\n]\n}\n}"
        
        
        
        
        
        
        
        
        
        var SLurl = NSURL(string: "http://54.191.40.200:50001/b1s/v1/ApprovalRequestsService_UpdateRequest")
        
        
        
        
        
        //var bodyData2 = "{\n\t\"ApprovalRequest\": { \n\t\"Code\":15,\n\t\"ObjectType\":\"112\",\n\t\"IsDraft\":\"Y\",\n\t\"ObjectEntry\": 16,\n\t\"Status\": \"arsApproved\",\n\t\"Remarks\": \"ppp\",\n\t\"CurrentStage\": 7,\n\t\"OriginatorID\": 19,\n\t\"ApprovalRequestLines\": [\n\t{\n\t\"StageCode\": 7,\n\t\"UserID\": 1,\n\t\"Status\": \"arsApproved\",\n\t\"Remarks\": \"ppp\"\n}\n],\n\"ApprovalRequestDecisions\": [\n{\n\"ApproverUserName\": \"manager\",\n\"ApproverPassword\": \"1234\",\n\"Status\": \"ardApproved\",\n\"Remarks\": \"Approved and go ahead!\"\n}\n]\n}\n}"
        
        
        
        
        
        
        
        var approvalStatus = NSData()
        
        var serviceLayerResult = NSString()
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:SLurl!)
        
        request.HTTPMethod="POST"
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            
            {
                
                (response, data, error) in
                
                
                
                approvalStatus = data!
                
                serviceLayerResult = NSString(data: approvalStatus, encoding: NSUTF8StringEncoding)!
                
                /*
                
                * Service Layer call to approve the order has a return code of 204 when successful
                
                * This HTTP access API call does not grab 204 messages so we check if the string containing the result has a size of 0
                
                * if the size is 0 we had success and can gracefully exit
                
                */
                
                if serviceLayerResult.length == 0
                    
                {
                    
                    
                    
                    let alertController = UIAlertController(title: "Order Approval App", message:
                        
                        "Order Successful Approved", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                    
                }
                    
                else
                    
                {
                    
                    let alertController = UIAlertController(title: "Order Approval App", message:
                        
                        "Order Approval Failed", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    
                }
                
        }
        
        
        
    }
    
    
    
    //init(){
    
    
    
    //}
    
    
    
    required init(coder aDecoder: NSCoder!)
        
    {
        
        super.init(coder: aDecoder)!
        
        // Your intializations
        
        //CardNameLabel.text = String ()
        
    }
    
    
    
    required init() {
        
        super.init(nibName: nil, bundle: nil)
        
        //Do whatever you want here
        
        //CardNameLabel.text = String ()
        
    }
    
    
    
    /*
    
    init(coder aDecoder: NSCoder!)
    
    {
    
    super.init(coder: aDecoder)
    
    }*/
    
    

    
    
    
    
    
    
}//Close all





