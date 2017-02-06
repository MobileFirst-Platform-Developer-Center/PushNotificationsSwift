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
    override func viewWillAppear(_ animated: Bool) {
        self.usernameInput.text = ""
        self.passwordInput.text = ""
        if(self.remainingAttemptsViaSegue != nil) {
            self.remainingLabel.text = "Remaining Attempts: " + String(self.remainingAttemptsViaSegue)
        }
        if(self.errorViaSegue != nil) {
            self.errorLabel.text = self.errorViaSegue
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels(_:)), name: NSNotification.Name(rawValue: LoginRequiredNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: LoginSuccessNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginFailure(_:)), name: NSNotification.Name(rawValue: LoginFailureNotificationKey), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        if(self.usernameInput.text != "" && self.passwordInput.text != ""){
            NotificationCenter.default.post(name: Notification.Name(rawValue: LoginNotificationKey), object: nil, userInfo: ["username": usernameInput.text!, "password": passwordInput.text!])
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: LoginCancelNotificationKey), object: nil)
    }
    
    func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: LoginCancelNotificationKey), object: nil)
    }
    
    
    // updateLabels (triggered by LoginRequired notification)
    func updateLabels(_ notification:Notification){
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject?>
        let errMsg = userInfo["errorMsg"] as! String
        let remainingAttempts = userInfo["remainingAttempts"] as! Int
        self.errorLabel.text = errMsg
        self.remainingLabel.text = "Remaining Attempts: " + String(remainingAttempts)
    }
    
    // loginSuccess (triggered by LoginSuccess notification)
    func loginSuccess(){
        NSLog("login success")
        navigationController?.popViewController(animated: true)
    }
    
    // loginFailure (triggered by LoginFailure notification)
    func loginFailure(_ notification:Notification){
        self.usernameInput.text = ""
        self.passwordInput.text = ""
        self.remainingLabel.text = ""
        self.errorLabel.text = ""
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject?>
        let errorMsg = userInfo["errorMsg"] as! String
        
        let alert = UIAlertController(title: "Error",
            message: errorMsg,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }

        
        
    }
    
    // viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
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
