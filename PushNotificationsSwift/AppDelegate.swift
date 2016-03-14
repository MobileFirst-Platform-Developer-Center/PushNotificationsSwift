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

let LoginRequiredNotificationKey = "com.sample.RememberMeSwift.LoginRequiredNotificationKey"
let LoginSuccessNotificationKey = "com.sample.RememberMeSwift.LoginSuccessNotificationKey"
let LoginFailureNotificationKey = "com.sample.RememberMeSwift.LoginFailureNotificationKey"
let LoginCancelNotificationKey = "com.sample.RememberMeSwift.LoginCancelNotificationKey"
let LoginNotificationKey = "com.sample.RememberMeSwift.LoginNotificationKey"
let LogoutNotificationKey = "com.sample.RememberMeSwift.LogoutNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize MFPPush
        MFPPush.sharedInstance().initialize()
        
        // Initialize challenge handler
        _ = RememberMeChallengeHandler()
        
        // Check if application was opened from a notification
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
            //handle your notification
            print("Received Notification in didFinishLaunchingWithOptions \(userInfo)")
            
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Received Notification in didReceiveRemoteNotification \(userInfo)")
        
        // display the alert body
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? NSDictionary,
            let body = alert["body"] as? String {
                showAlert(body)
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: Registered device successfully")
        
        // Registers device token with server.
        MFPPush.sharedInstance().sendDeviceToken(deviceToken)
    }

    func showAlert(message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertDialog.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))

        window!.rootViewController?.presentViewController(alertDialog, animated: true, completion: nil)
    }


}
