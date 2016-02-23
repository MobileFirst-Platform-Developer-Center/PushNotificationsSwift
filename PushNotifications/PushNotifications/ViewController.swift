//
//  ViewController.swift
//  PushNotifications
//
//  Created by Eric Garcia on 2/17/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // Button outlets
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var getSubcriptionBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    let appDelaget = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func enableButtons() {
        subscribeBtn.enabled = true
        getSubcriptionBtn.enabled = true
        unsubscribeBtn.enabled = true
        unregisterBtn.enabled = true
    }
    
    func disableButtons() {
        subscribeBtn.enabled = false
        getSubcriptionBtn.enabled = false
        unsubscribeBtn.enabled = false
        unregisterBtn.enabled = false
    }
    
    func showAlert(message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertDialog.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertDialog, animated: true, completion: nil)
    }
    
}

// MARK: Lifecycle methods
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable buttons by default
        subscribeBtn.enabled = false
        getSubcriptionBtn.enabled = false
        unsubscribeBtn.enabled = false
        unregisterBtn.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Buttons
extension ViewController {
    
    @IBAction func isPushSupported(sender: AnyObject) {
        let isPushSupported: Bool = MFPPush.sharedInstance().isPushSupported()
  
        if isPushSupported {
            showAlert("Yes, Push is supported")
        } else {
            showAlert("No, Push is not supported")
        }
        
    }
    
    @IBAction func registerDevice(sender: AnyObject) {
        let systemVersion: Float = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        if systemVersion >= 8.0 {
            let userNotificationTypes = UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationTypes)
            enableButtons()
//            self.showAlert("Registered successfully")
        } else {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            enableButtons()
//            self.showAlert("Registered successfully")
        }
        
        
        MFPPush.sharedInstance().registerDevice({(responce: WLResponse!, error: NSError!) -> Void in
            
            print("Registered closure entered")
            
            if error == nil {
                print("")
            } else {
                self.showAlert("Registrations failed.  Error \(error.description)")
                print("Error \(error.description)")
            }
            
        })
    }
    
    @IBAction func getTags(sender: AnyObject) {
        MFPPush.sharedInstance().getTags({(responce: WLResponse!, error: NSError!) -> Void in
            if error == nil {
                self.showAlert("this could work")
            } else {
                self.showAlert("Error \(error.description)")
                print("Error \(error.description)")
            }
            
        })
    }
    
    @IBAction func subscribe(sender: AnyObject) {
        showAlert("Setup subscribe")
    }
    
    @IBAction func getSubscriptions(sender: AnyObject) {
        showAlert("Setup get subscriptions")
    }
    
    @IBAction func unsubscribe(sender: AnyObject) {
        showAlert("Setup unsubscribe")
    }
    
    @IBAction func unregisterDevice(sender: AnyObject) {
        self.disableButtons()
        showAlert("Setup unregister")
    }
}
