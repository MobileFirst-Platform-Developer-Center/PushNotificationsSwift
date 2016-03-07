//
//  LoginViewController.swift
//  PushNotificationsSwift
//
//  Created by Nathan Hazout on 07/03/2016.
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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    var errorViaSegue: String!
    var remainingAttemptsViaSegue: Int!
    
    // viewWillAppear
    override func viewWillAppear(animated: Bool) {
        self.usernameInput.text = ""
        self.passwordInput.text = ""
        if(self.remainingAttemptsViaSegue != nil) {
            self.remainingLabel.text = "Remaining Attempts: " + String(self.remainingAttemptsViaSegue)
        }
        if(self.errorViaSegue != nil) {
            self.errorLabel.text = self.errorViaSegue
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLabels:", name: LoginRequiredNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess", name: LoginSuccessNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cleanFieldsAndLabels", name: LoginFailureNotificationKey, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton) {
        if(self.usernameInput.text != "" && self.passwordInput.text != ""){
            NSNotificationCenter.defaultCenter().postNotificationName(LoginNotificationKey, object: nil, userInfo: ["username": usernameInput.text!, "password": passwordInput.text!])
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(LoginCancelNotificationKey, object: nil)
    }
    
    func back(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(LoginCancelNotificationKey, object: nil)
    }
    
    
    // updateLabels (triggered by LoginRequired notification)
    func updateLabels(notification:NSNotification){
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject!>
        let errMsg = userInfo["errorMsg"] as! String
        let remainingAttempts = userInfo["remainingAttempts"] as! Int
        self.errorLabel.text = errMsg
        self.remainingLabel.text = "Remaining Attempts: " + String(remainingAttempts)
    }
    
    // loginSuccess (triggered by LoginSuccess notification)
    func loginSuccess(){
        NSLog("login success")
        navigationController?.popViewControllerAnimated(true)
    }
    
    // cleanFieldsAndLabels (triggered by LoginFailure notification)
    func cleanFieldsAndLabels(){
        self.usernameInput.text = ""
        self.passwordInput.text = ""
        self.remainingLabel.text = ""
        self.errorLabel.text = ""
    }
    
    // viewDidDisappear
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
