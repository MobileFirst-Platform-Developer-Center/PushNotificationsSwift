/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
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
        
        MFPPush.sharedInstance().initialize()
        
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
        print("Is push supported entered")
        
        let isPushSupported: Bool = MFPPush.sharedInstance().isPushSupported()
  
        if isPushSupported {
            showAlert("Yes, Push is supported")
        } else {
            showAlert("No, Push is not supported")
        }
        
    }
    
    @IBAction func registerDevice(sender: AnyObject) {
        print("Register device entered")
        
        // Reference to system version as float
        let systemVersion: Float = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        
        // Verify version and enable notifications accordingly at the device level
        if systemVersion >= 8.0 {
            let userNotificationTypes = UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationTypes)
        } else {
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        
        // Register device
        MFPPush.sharedInstance().registerDevice({(response: WLResponse!, error: NSError!) -> Void in
            if error == nil {
                self.enableButtons()
                self.showAlert("Registered successfully")

                print(response.description)
            } else {
                self.showAlert("Registrations failed.  Error \(error.description)")
                print(error.description)
            }
            
        })
    }
    
    @IBAction func getTags(sender: AnyObject) {
        print("Get tags entered")
        
        // Get tags
        MFPPush.sharedInstance().getTags({(response: WLResponse!, error: NSError!) -> Void in
            if error == nil {
                if response.availableTags() == nil {
                    self.showAlert("There are no available tags")
                } else {
                    self.showAlert(String(response.availableTags()))
                    print("Tags response: \(response)")
                }
            } else {
                self.showAlert("Error \(error.description)")
                print("Error \(error.description)")
            }
            
        })
    }
    
    @IBAction func subscribe(sender: AnyObject) {
        print("Subscribe entered")
        
        // Array of tags to subscribe to
        let tagsArray: [AnyObject] = ["Tag 1", "Tag 2"]
        
        // Subscribe to tags
        MFPPush.sharedInstance().subscribe(tagsArray, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
            if error == nil {
                self.showAlert("Subscribed successfully")
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Fialed to subscribe")
                print("Error \(error.description)")
            }
        })
    }
    
    @IBAction func getSubscriptions(sender: AnyObject) {
        print("Get subscription entered")
        
        // Get list of subscriptions
        MFPPush.sharedInstance().getSubscriptions({(response: WLResponse!, error: NSError!) -> Void in
            if error == nil {

                var tags = [String]()
            
                let json = response.responseJSON as NSDictionary
  
                let subscriptions = json["subscriptions"] as? [[String: AnyObject]]
                
                for tag in subscriptions! {
                    if let tagName = tag["tagName"] as? String {
                        print("tagName: \(tagName)")
                        tags.append(tagName)
                    }
                }
                
                self.showAlert(String(tags))
            } else {
                self.showAlert("Error \(error.description)")
                print("Error \(error.description)")
            }
        })
    }
    
    @IBAction func unsubscribe(sender: AnyObject) {
        print("Unsubscribe entered")
        
        // Array of tags to unsubscribe from
        let tagsArray: [String] = ["Tag 1", "Tag 2"]
        
        // Unsubscribe from tags
        MFPPush.sharedInstance().unsubscribe(tagsArray, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
            if error == nil {
                self.showAlert(String(response.description))
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Error \(error.description)")
                print("Error \(error.description)")
            }
        })
    }
    
    @IBAction func unregisterDevice(sender: AnyObject) {
        print("Unregister device entered")
        
        // Disable buttons
        self.disableButtons()
        
        // Unregister device
        MFPPush.sharedInstance().unregisterDevice({(response: WLResponse!, error: NSError!) -> Void in
            if error == nil {
                self.showAlert(String(response.description))
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Error \(error.description)")
                print("Error \(error.description)")
            }
        })
    }
}
