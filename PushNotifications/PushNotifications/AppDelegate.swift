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
//  AppDelegate.swift
//  PushNotifications
//
//  Created by Eric Garcia on 2/17/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // Blue
    let primaryColor = UIColor(red: 75/255, green: 107/255, blue: 175/255, alpha: 1.0)
    // Purple
    let iconColor = UIColor(red: 127/255, green: 28/255, blue: 125/255, alpha: 1.0)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize MFPPush
        MFPPush.initialize()
        
        setAppStyle()
        
        return true
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
    
    

}

// MARK: Notification Registration Methods
extension AppDelegate {
    
    func showAlert(message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertDialog.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
    
        window!.rootViewController?.presentViewController(alertDialog, animated: true, completion: nil)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: Registered device successfully")
        MFPPush.sharedInstance().sendDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {

    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        self.showAlert("Registration failed")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Recieved Notification \(userInfo.description)")
        
        showAlert(userInfo.description)
    }
    
}

// MARK: App Setup
extension AppDelegate {
    
    func setAppStyle() {
        
        // Set status bar color to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Set navigation bar color
        let navBarAppearance = UINavigationBar.appearance()
        
        navBarAppearance.barTintColor = primaryColor
        navBarAppearance.tintColor = iconColor
        navBarAppearance.barStyle = .Black
        
        let toolBarApperance = UIToolbar.appearance()
        
        toolBarApperance.barTintColor = primaryColor
        toolBarApperance.tintColor = iconColor
    }
}

