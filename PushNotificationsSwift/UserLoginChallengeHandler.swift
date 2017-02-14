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

class UserLoginChallengeHandler: SecurityCheckChallengeHandler {
    
    var isChallenged: Bool
    let defaults = UserDefaults.standard
    
    override init(){
        self.isChallenged = false
        super.init(securityCheck: "UserLogin")
        WLClient.sharedInstance().register(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: NSNotification.Name(rawValue: LoginNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: LogoutNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: NSNotification.Name(rawValue: LoginCancelNotificationKey), object: nil)
    }
    
    // login (Triggered by Login Notification)
    func login(_ notification:Notification){
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject?>
        let username = userInfo["username"] as! String
        let password = userInfo["password"] as! String
        
        // If challenged use submitChallengeAnswer API, else use login API
        if(!self.isChallenged){
            WLAuthorizationManager.sharedInstance().login(self.securityCheck, withCredentials: ["username": username, "password": password]) { (error) -> Void in
                NSLog("login")
                if(error != nil){
                    NSLog("Login failed" + String(describing: error))
                }
            }
        }
        else{
            self.submitChallengeAnswer(["username": username, "password": password])
        }
    }
    
    // cancel (Triggered by Cancel Notification)
    override func cancel(){
        self.cancel()
    }
    
    // logout (Triggered by Logout Notification)
    func logout(){
        WLAuthorizationManager.sharedInstance().logout(self.securityCheck){
            (error) -> Void in
            if(error != nil){
                NSLog("Logout failed" + String(describing: error))
            }
        }
        self.isChallenged = false
    }
    
    // handleChallenge
    override func handleChallenge(_ challenge: [AnyHashable: Any]!) {
        self.isChallenged = true
        self.defaults.removeObject(forKey: "displayName")
        var errMsg: String!
        
        if(challenge["errorMsg"] is NSNull){
            errMsg = ""
        }
        else{
            errMsg = challenge["errorMsg"] as! String
        }
        let remainingAttempts = challenge["remainingAttempts"]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: LoginRequiredNotificationKey), object: nil, userInfo: ["errorMsg":errMsg!, "remainingAttempts":remainingAttempts!])
        
    }
    
    // handleSuccess
    override func handleSuccess(_ success: [AnyHashable: Any]!) {
        self.isChallenged = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: LoginSuccessNotificationKey), object: nil)
    }
    
    // handleFailure
    override func handleFailure(_ failure: [AnyHashable: Any]!) {
        self.isChallenged = false
        var errorMsg: String!
        if failure["failure"] != nil {
            errorMsg = failure["failure"] as! String
        }
        else{
            errorMsg = "Unknown error"
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: LoginFailureNotificationKey), object: nil, userInfo: ["errorMsg":errorMsg!])
    }

}
