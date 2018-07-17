IBM MobileFirst Platform Foundation
===
## PushNotificationsSwift
A sample application demonstrating use of push notifications in iOS applications.

### Tutorials
https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/notifications/

### Usage

1. From a **Command-line** window, navigate to the project's root folder and run the commands:
  - `pod update` followed by `pod install` to add the MobileFirst SDK.
  - `mfpdev app register` to register the application in the MobileFirst Server.
2. In the MobileFirst console: 
  - Under **Applications** → **PushNotificationsSwift** → **Security** → **Map scope elements to security checks**, add a mapping for `push.mobileclient`.
  - Under **Applications** → **PushNotificationsSwift** → **Push** → **Push Settings**, upload your PKCS 12 (.p12) file and password.
3. Import the project to Xcode using the .xcworkspace file.
4. Configure the project with your bundleId (based on bundleId that you have created for your push notifications certificate .p12 file). 
5. Run the app by clicking the **Run** button.

**[Sending a notification](https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/notifications/sending-push-notifications):**

* Tag notification
    * Use the **MobileFirst Operations Console → [your application] → Push → Send Push tab**.
* Authenticated notification:
    * Deploy the [**UserLogin** sample Security Check](https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/authentication-and-security/user-authentication/security-check).
    * In **MobileFirst Operations Console → [your application] → Security tab**, map the **push.mobileclient** scope to the **UserLogin** Security Check.
    * Follow the instructions for [REST APIs](https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/notifications/sending-push-notifications#rest-apis) to send the notification.

**Notes:**

* Must be tested on physical devices.
* The BundleID must relate to an AppID configured with push notifications.
* The certificate must be uploaded via the MobileFirst Operations Console.
* Must use Xcode 8.2.1 and above  and Swift 3.0

### Supported Levels
IBM MobileFirst Platform Foundation 8.0

### License
Copyright 2015 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
att
http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
