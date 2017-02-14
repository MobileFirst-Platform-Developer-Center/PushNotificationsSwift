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

let LoginRequiredNotificationKey = "com.sample.PushNotificationsSwift.LoginRequiredNotificationKey"
let LoginSuccessNotificationKey = "com.sample.PushNotificationsSwift.LoginSuccessNotificationKey"
let LoginFailureNotificationKey = "com.sample.PushNotificationsSwift.LoginFailureNotificationKey"
let LoginCancelNotificationKey = "com.sample.PushNotificationsSwift.LoginCancelNotificationKey"
let LoginNotificationKey = "com.sample.PushNotificationsSwift.LoginNotificationKey"
let LogoutNotificationKey = "com.sample.PushNotificationsSwift.LogoutNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize MFPPush
        MFPPush.sharedInstance().initialize()

        // Initialize challenge handler
        _ = UserLoginChallengeHandler()

        // Check if application was opened from a notification
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            //handle your notification
            print("Received Notification in didFinishLaunchingWithOptions \(userInfo)")

        }

        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Received Notification in didReceiveRemoteNotification \(userInfo)")

        // display the alert body
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? NSDictionary,
            let body = alert["body"] as? String {
                showAlert(body)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: Registered device successfully")

        // Registers device token with server.
        MFPPush.sharedInstance().sendDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
        
        showAlert("Failed to register for remote notifications with error: \(error.localizedDescription)")
    }

    func showAlert(_ message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertDialog.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))

        window!.rootViewController?.present(alertDialog, animated: true, completion: nil)
    }


}
