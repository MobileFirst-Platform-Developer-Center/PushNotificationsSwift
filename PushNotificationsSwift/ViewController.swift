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

import UIKit
import IBMMobileFirstPlatformFoundation
import IBMMobileFirstPlatformFoundationPush

// MARK: Variables and Helper Methods
class ViewController: UIViewController {

    // Button outlets
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var getSubcriptionBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    // Array of tags to subscribe to
    var tagsArray: [String] = ["Tag 1", "Tag 2"]

    func enableButtons() {
        subscribeBtn.isEnabled = true
        getSubcriptionBtn.isEnabled = true
        unsubscribeBtn.isEnabled = true
        unregisterBtn.isEnabled = true
    }

    func disableButtons() {
        subscribeBtn.isEnabled = false
        getSubcriptionBtn.isEnabled = false
        unsubscribeBtn.isEnabled = false
        unregisterBtn.isEnabled = false
    }

    func showAlert(_ message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertDialog.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))

        present(alertDialog, animated: true, completion: nil)
    }

}

// MARK: Lifecycle Methods
extension ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable buttons by default
        subscribeBtn.isEnabled = false
        getSubcriptionBtn.isEnabled = false
        unsubscribeBtn.isEnabled = false
        unregisterBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loginRequired(_:)), name: NSNotification.Name(rawValue: LoginRequiredNotificationKey), object: nil)
    }
    
    // viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Buttons
extension ViewController {

    @IBAction func isPushSupported(_ sender: AnyObject) {
        print("Is push supported entered")

        let isPushSupported: Bool = MFPPush.sharedInstance().isPushSupported()

        if isPushSupported {
            showAlert("Yes, Push is supported")
        } else {
            showAlert("No, Push is not supported")
        }

    }

    @IBAction func registerDevice(_ sender: AnyObject) {
        print("Register device entered")
        
        // Register device
        
        MFPPush.sharedInstance().registerDevice(nil) { (response, error) -> Void in
            if error == nil {
                self.enableButtons()
                self.showAlert("Registered successfully")
                
                print(response?.description ?? "")
            } else {
                self.showAlert("Registrations failed.  Error \(error?.localizedDescription)")
                print(error?.localizedDescription ?? "")
            }
        }
//        MFPPush.sharedInstance().registerDevice(nil, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.enableButtons()
//                self.showAlert("Registered successfully")
//                
//                print(response.description)
//            } else {
//                self.showAlert("Registrations failed.  Error \(error.description)")
//                print(error.description)
//            }
//        })
    }

    @IBAction func getTags(_ sender: AnyObject) {
        print("Get tags entered")
        
        // Get tags
        MFPPush.sharedInstance().getTags { (response, error) -> Void in
            if error == nil {
                print("The response is: \(response)")
                print("The response text is \(response?.responseText)")
                if response?.availableTags().isEmpty == true {
                    self.tagsArray = []
                    self.showAlert("There are no available tags")
                } else {
                    self.tagsArray = response!.availableTags() as! [String]
                    self.showAlert(String(describing: self.tagsArray))
                    print("Tags response: \(response)")
                }
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().getTags({(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                print("The response is: \(response)")
//                print("The response text is \(response.responseText)")
//                if response.availableTags().isEmpty == true {
//                    self.tagsArray = []
//                    self.showAlert("There are no available tags")
//                } else {
//                    self.tagsArray = response.availableTags()
//                    self.showAlert(String(self.tagsArray))
//                    print("Tags response: \(response)")
//                }
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//
//        })
    }

    @IBAction func subscribe(_ sender: AnyObject) {
        print("Subscribe entered")

        // Subscribe to tags
        MFPPush.sharedInstance().subscribe(self.tagsArray) { (response, error)  -> Void in
            if error == nil {
                self.showAlert("Subscribed successfully")
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Failed to subscribe")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().subscribe(self.tagsArray, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.showAlert("Subscribed successfully")
//                print("Subscribed successfully response: \(response)")
//            } else {
//                self.showAlert("Failed to subscribe")
//                print("Error \(error.description)")
//            }
//        })
    }

    @IBAction func getSubscriptions(_ sender: AnyObject) {
        print("Get subscription entered")

        // Get list of subscriptions
        MFPPush.sharedInstance().getSubscriptions { (response, error) -> Void in
            if error == nil {
                
                var tags = [String]()
                
                let json = (response?.responseJSON)! as [AnyHashable: Any]
                let subscriptions = json["subscriptions"] as? [[String: AnyObject]]
                
                for tag in subscriptions! {
                    if let tagName = tag["tagName"] as? String {
                        print("tagName: \(tagName)")
                        tags.append(tagName)
                    }
                }
                
                self.showAlert(String(describing: tags))
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().getSubscriptions({(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//
//                var tags = [String]()
//
//                let json = response.responseJSON as Dictionary
//                let subscriptions = json["subscriptions"] as? [[String: AnyObject]]
//
//                for tag in subscriptions! {
//                    if let tagName = tag["tagName"] as? String {
//                        print("tagName: \(tagName)")
//                        tags.append(tagName)
//                    }
//                }
//
//                self.showAlert(String(tags))
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//        })
    }

    @IBAction func unsubscribe(_ sender: AnyObject) {
        print("Unsubscribe entered")

        // Unsubscribe from tags
         MFPPush.sharedInstance().unsubscribe(self.tagsArray) { (response, error)  -> Void in
            if error == nil {
                self.showAlert("Unsubscribed successfully")
                print(String(describing: response?.description))
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }

        }
//        MFPPush.sharedInstance().unsubscribe(self.tagsArray, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.showAlert("Unsubscribed successfully")
//                print(String(response.description))
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//        })
    }

    @IBAction func unregisterDevice(_ sender: AnyObject) {
        print("Unregister device entered")

        // Unregister device
        MFPPush.sharedInstance().unregisterDevice { (response, error)  -> Void in
            if error == nil {
                // Disable buttons
                self.disableButtons()
                self.showAlert("Unregistered successfully")
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().unregisterDevice({(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                // Disable buttons
//                self.disableButtons()
//                self.showAlert("Unregistered successfully")
//                print("Subscribed successfully response: \(response)")
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//        })
    }
}

//MARK: Security
extension ViewController{
    // loginRequired
    func loginRequired(_ notification:Notification){
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject?>        
        self.performSegue(withIdentifier: "showLogin", sender: userInfo)
    }
    
    // prepareForSegue (for TimedOutSegue)
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if (segue.identifier == "showLogin") {
            let userInfo = sender as! Dictionary<String, AnyObject?>
            if let destination = segue.destination as? LoginViewController{
                destination.errorViaSegue = userInfo["errorMsg"] as! String
                destination.remainingAttemptsViaSegue = userInfo["remainingAttempts"] as! Int
            }
        }
    }
}
