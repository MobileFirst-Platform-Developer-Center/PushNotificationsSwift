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

class UserLoginChallengeHandler: WLChallengeHandler {
    
    var isChallenged: Bool
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override init(){
        self.isChallenged = false
        super.init(securityCheck: "UserLogin")
        WLClient.sharedInstance().registerChallengeHandler(self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(login(_:)), name: LoginNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(logout), name: LogoutNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(cancel), name: LoginCancelNotificationKey, object: nil)
    }
    
    // login (Triggered by Login Notification)
    func login(notification:NSNotification){
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject!>
        let username = userInfo["username"] as! String
        let password = userInfo["password"] as! String
        
        // If challenged use submitChallengeAnswer API, else use login API
        if(!self.isChallenged){
            WLAuthorizationManager.sharedInstance().login(self.securityCheck, withCredentials: ["username": username, "password": password]) { (error) -> Void in
                NSLog("login")
                if(error != nil){
                    NSLog("Login failed" + String(error))
                }
            }
        }
        else{
            self.submitChallengeAnswer(["username": username, "password": password])
        }
    }
    
    // cancel (Triggered by Cancel Notification)
    func cancel(){
        self.submitFailure(nil)
    }
    
    // logout (Triggered by Logout Notification)
    func logout(){
        WLAuthorizationManager.sharedInstance().logout(self.securityCheck){
            (error) -> Void in
            if(error != nil){
                NSLog("Logout failed" + String(error))
            }
        }
        self.isChallenged = false
    }
    
    // handleChallenge
    override func handleChallenge(challenge: [NSObject : AnyObject]!) {
        self.isChallenged = true
        self.defaults.removeObjectForKey("displayName")
        var errMsg: String!
        
        if(challenge["errorMsg"] is NSNull){
            errMsg = ""
        }
        else{
            errMsg = challenge["errorMsg"] as! String
        }
        let remainingAttempts = challenge["remainingAttempts"]
        
        NSNotificationCenter.defaultCenter().postNotificationName(LoginRequiredNotificationKey, object: nil, userInfo: ["errorMsg":errMsg!, "remainingAttempts":remainingAttempts!])
        
    }
    
    // handleSuccess
    override func handleSuccess(success: [NSObject : AnyObject]!) {
        self.isChallenged = false
        NSNotificationCenter.defaultCenter().postNotificationName(LoginSuccessNotificationKey, object: nil)
    }
    
    // handleFailure
    override func handleFailure(failure: [NSObject : AnyObject]!) {
        self.isChallenged = false
        var errorMsg: String!
        if failure["failure"] != nil {
            errorMsg = failure["failure"] as! String
        }
        else{
            errorMsg = "Unknown error"
        }
        NSNotificationCenter.defaultCenter().postNotificationName(LoginFailureNotificationKey, object: nil, userInfo: ["errorMsg":errorMsg!])
    }

}
