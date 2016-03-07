/**
	Licensed Materials - Property of IBM

	(C) Copyright 2015 IBM Corp.

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

//
//  WLClient.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 3/4/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLDelegate.h"
#import "BaseChallengeHandler.h"

@class WLCookieExtractor;
@class WLRequest;
@class WLProcedureInvocationData;
@class WLEventTransmissionPolicy;

extern NSString * const WL_DEFAULT_ACCESS_TOKEN_SCOPE;

extern NSString * const WLClientErrorDomain;

enum {
    WLClientErrorInternalError = 1,
    WLClientErrorUnresponsiveHost = 2,
    WLClientErrorRequestTimeout = 3,
    WLClientErrorServerError = 4,
    WLClientErrorAuthenticationFailure = 5
};

@protocol WLDevice;


/**
 * This singleton class exposes methods that you use to communicate with the IBM MobileFirst Platform Server.
 */
@interface WLClient : NSObject {
    
@private
	
	// PUSH NOTIFICATION
	NSMutableArray *pending;
	NSMutableDictionary *registeredEventSourceIDs;
    
    //Challenge handlers
    NSMutableDictionary *challengeHandlers;
	
    
    BOOL isInitialized;
}


extern NSMutableDictionary *piggyBackData;

/**
 * Sets an authentication handler that WLClient can use for authentication-related tasks. 
 * This method must be called for WLClient to be able to access protected resources in the IBM MobileFirst Platform server.
 */
@property (nonatomic, strong) NSMutableDictionary *registeredEventSourceIDs;

@property (nonatomic) BOOL isInitialized;

@property (readwrite) NSInteger interval;

@property (readwrite, strong) NSTimer *timer;

@property (nonatomic) BOOL isResumed;

@property (nonatomic) BOOL isRequestFailed;

/**
 * This method returns the shared instance of <code>WLClient</code>.
 * @return <code>WLClient</code>
 */
+ (WLClient *) sharedInstance;

/**
 *
 * Retrieves the shared cookie storage that is used by the framework when communicating with the server.
 *
 * @return The cookie storage object
 *
 */
-(NSHTTPCookieStorage*)HTTPCookieStorage;

/**
 *  This method uses <code>NSURLConnection</code> to execute the provided <code>NSURLRequest</code>.
 *
 *  @param request <code>NSURLRequest</code> object
 *
 *  @param delegate
 *  An object that conforms to the <code>NSURLSessionDataDelegate</code> or <code>NSURLSessionTaskDelegate</code> protocol.
 *
 */
-(void) sendUrlRequest:(NSURLRequest *)request delegate:(id)delegate;


-(void) invokeProcedure:(WLProcedureInvocationData *)invocationData withDelegate:(id <WLDelegate>)delegate;

/**
 * This method is similar to invokeProcedure:invocationData:withDelegate, with an additional options parameter to provide more data for this procedure call.
 *
 * @param invocationData The invocation data for the procedure call.
 * @param delegate The delegate object that is used for the onSuccess and onFailure callback methods.
 * @param options A map with the following keys and values:
 *
 * - timeout – NSNumber:
 * The time, in milliseconds, for this invokeProcedure to wait before the request fails with WLErrorCodeRequestTimeout. The default timeout is 10 seconds. To disable the timeout, set this parameter to 0.
 * - invocationContext:
 * An object that is returned with WLResponse to the delegate methods. You can use this object to distinguish different invokeProcedure calls.
 *
 */

-(void) invokeProcedure:(WLProcedureInvocationData *)invocationData withDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;


-(void) sendInvoke:(WLProcedureInvocationData *)invocationData withDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options ignoreChallenges: (BOOL)ignoreChallenges;

/**
 * This method subscribes the application to receive push notifications from the specified event source and adapter.
 *
 * @param deviceToken The token received from the method application:didRegisterForRemoteNotificationsWithDeviceToken. Save the device token in case unsubscribedWithToken:adapter:eventSource:delegate: is called.
 * @param adapter The name of the adapter.
 * @param eventSource The name of the event source.
 * @param eventSourceID An ID that you assign to the event source that is returned by the IBM MobileFirst Platform Server with each notification from this event source. You can use the ID in your notification callback function to identify the notification event source.
 * The ID is passed on the notification payload. To save space in the notification payload, pass a short integer, otherwise it is used to pass the adapter and event source names.
 * @param notificationType Constants that indicate the types of notifications that the application accepts. For more information, see the <a href="http://developerns.apple.com/library/ios/" \l "documentation/UIKit/Reference/UIApplication_Class/Reference/Reference.html"> link Apple documentation.</a>
 * @param delegate A standard IBM MobileFirst Platform delegate with onSuccess and onFailure methods to indicate success or failure of the subscription to the IBM MobileFirst Platform Server.
 */
#if !TARGET_OS_WATCH
-(void) subscribeWithToken:(NSData *)deviceToken adapter:(NSString *)adapter eventSource: (NSString *)eventSource eventSourceID: (int)eventSourceID notificationType:(UIRemoteNotificationType) types delegate:(id <WLDelegate>)delegate;
#endif
/**
 * This method subscribes the application to receive push notifications from the specified event source and adapter.
 *
 * @param deviceToken The token received from the method application:didRegisterForRemoteNotificationsWithDeviceToken. Save the device token in case unsubscribedWithToken:adapter:eventSource:delegate: is called.
 * @param adapter The name of the adapter.
 * @param eventSource The name of the event source.
 * @param eventSourceID An ID that you assign to the event source that is returned by the IBM MobileFirst Platform Server with each notification from this event source. You can use the ID in your notification callback function to identify the notification event source.
 * The ID is passed on the notification payload. To save space in the notification payload, pass a short integer, otherwise it is used to pass the adapter and event source names.
 * @param notificationType Constants that indicate the types of notifications that the application accepts. For more information, see the <a href="http://developerns.apple.com/library/ios/" \l "documentation/UIKit/Reference/UIApplication_Class/Reference/Reference.html"> link Apple documentation.</a>
 * @param delegate A standard IBM MobileFirst Platform delegate with onSuccess and onFailure methods to indicate success or failure of the subscription to the IBM MobileFirst Platform Server.
 * @param options Optional. This parameter contains data that is passed to the IBM MobileFirst Platform Server, which is used by the adapter.
 */
#if !TARGET_OS_WATCH
-(void) subscribeWithToken:(NSData *)deviceToken adapter:(NSString *)adapter eventSource: (NSString *)eventSource eventSourceID: (int)eventSourceID notificationType:(UIRemoteNotificationType) types delegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;
#endif
/**
 * This method unsubscribes to notifications from the specified event source in the specified adapter.
 *
 * @param adapter The name of the adapter.
 * @param eventSource TThe name of the event source.
 * @param delegate A standard IBM MobileFirst Platform delegate with the onSuccess and onFailure methods to indicate success or failure of the unsubscription to the IBM MobileFirst Platform Server.
 */
-(void) unsubscribeAdapter:(NSString *)adapter eventSource: (NSString *)eventSource delegate:(id <WLDelegate>)delegate;

/**
 * This method returns true if the current logged-in user on the current device is already subscribed to the adapter and event source. 
 * The method checks the information received from the server in the success response for the login request. If the information that is sent from the server is not received, or if there is no subscription, this method returns false.
 *
 * @param adapter The name of the adapter.
 * @param eventSource TThe name of the event source.
 */
-(BOOL) isSubscribedToAdapter:(NSString *)adapter eventSource:(NSString *)eventSource;

/**
 * This method compares the device token to the one registered in the IBM MobileFirst Platform Server with the current logged-in user and current device. If the device token is different, the method sends the updated token to the server.
 *
 * The registered device token from the server is received in the success response for the login request. It is available without the need for an additional server call to retrieve. If a registered device token from the server is not available in the application, this method sends an update to the server with the device token.
 *
 * @param deviceToken The token received from the method <code>application:didRegisterForRemoteNotificationsWithDeviceToken</code>. Save the device token in case <code>unsubscribedWithToken:adapter:eventSource:delegate</code> is called.
 * @param delegate A standard IBM MobileFirst Platform delegate with the onSuccess and onFailure methods to indicate success or failure of the unsubscription to the IBM MobileFirst Platform Server.
 */
-(void) updateDeviceToken:(NSData *)deviceToken  delegate:(id <WLDelegate>)delegate;

/**
 * This method returns the eventSourceID that the IBM MobileFirst Platform Server sends in the push notification.
 *
 * @param userInfo The NSDictionary received in the application:didReceiveRemoteNotification method.
 */
-(int) getEventSourceIDFromUserInfo:(NSDictionary *)userInfo;


/**
 * You can use this method to register a custom Challenge Handler, which is a class that inherits from ChallengeHandler. See example 1: Adding a custom Challenge Handler.
 * You can also use this method to override the default Remote Disable / Notify Challenge Handler, by registering a class that inherits from WLChallengeHandler. See example <a href=""> link  2: Customizing the Remote Disable / Notify.</a>
 *
 * @param challengeHandler The Challenge Handler to register.
 */
-(void) registerChallengeHandler: (BaseChallengeHandler *) challengeHandler;

/**
 * You use this method to add a global header, which is sent on each request.
 * Each WlRequest instance will use this header as an HTTP header.
 *
 * @param headerName The header name/key.
 * @param value The header value.
 */
-(void) addGlobalHeader: (NSString *) headerName headerValue:(NSString *)value;

/**
 * You use this method to remove a global header, which is no longer sent with each request.
 *
 * @param headerName The header name to be removed.
 */
-(void) removeGlobalHeader: (NSString *) headerName;

/**
 * Get a global header.
 */
-(NSDictionary *) getGlobalHeaders;


/**
 * Get challenge handler by realm key
 */
-(BaseChallengeHandler *) getChallengeHandlerBySecurityCheck: (NSString *) securityCheck;


-(NSDictionary *) getAllChallengeHandlers;

/**
 * This method sets the interval, in seconds, at which the client (device) sends a heartbeat signal to the server. 
 *
 * You use the heartbeat signal to prevent a session with the server from timing out because of inactivity. Typically, the heartbeat interval has a value that is less than the server session timeout.The server session timeout is defined in the worklight.properties file. By default, the value of the heartbeat interval is set to 420 seconds (7 minutes).
 * To disable the heartbeat signal, set a value that is less than, or equal to zero.
 *
 * @note The client sends a heartbeat signal to the server only when the application is in the foreground. When the application is sent to the background, the client stops sending heartbeat signals. The client resumes sending heartbeat signals when the application is brought to the foreground again.
 *
 * @param val The interval, in seconds, at which the heartbeat signal is sent to the server.
 */
-(void) setHeartBeatInterval :(NSInteger)val;


/**
 * Sets the IBM MobileFirst Platform server URL to the specified URL.
 * 
 * Changes the IBM MobileFirst Platform server URL to the new URL and cleans the HTTP client context.
 * After calling this method, the application is not logged in to any server.
 * 
 * Notes:
 * <ul>
 * <li>The responsibility for checking the validity of the URL is on the developer.</li>
 * <li>For hybrid applications: This call does not clean the HTTP client context saved in JavaScript.
 * For hybrid applications, it is recommended to set the server URL by using the following JavaScript function: <code>WL.App.setServerUrl</code>.</li>
 * <li>If the app uses push notification, it is the developer's responsibility to unsubscribe from the previous server and subscribe to the new server.
 * For more information on push notification, see <code>WLPush</code>.</li>
 * </ul>
 *
 * Example:
 * 
 *		[[WLClient sharedInstance] setServerUrl:[NSURL URLWithString:@"http://9.148.23.88:10080/context"]];
 *
 * @param url The URL of the new server, including protocol, IP, port, and context.
 *
 */
- (void) setServerUrl: (NSURL*) url;

/**
 * Returns the current IBM MobileFirst Platform server URL
 *
 * @return IBM MobileFirst Platform server URL
 */
- (NSURL*) serverUrl;

/**
 * Pins the host X509 certificate public key to the client application. Secured calls to the pinned remote host will be checked for a public key match. Secured calls to other hosts containing other certificates will be rejected. Some mobile operating systems might cache the certificate validation check results. Your app must call the certificate pinning method before making a secured request. Calling this method a second time overrides any previous pinning operation.
 * @param certificateFilename the name of the certificate file
 **/
-(void) pinTrustedCertificatePublicKeyFromFile:(NSString*) certificateFilename;

/*
 * Sets the device's Display name in the server (calls update registration)
 */
-(void) setDeviceDisplayName:(NSString*)deviceDisplayName WithCompletionHandler:(void(^)(NSError* error))completionHandler;

/*
 * Get the Display name of this device from the MFP server
 */
-(void) getDeviceDisplayNameWithCompletionHandler:(void(^)(NSString *deviceDisplayName , NSError *error))completionHandler;

/**
 * Specifies default request time out.
 */
@property (readwrite) NSTimeInterval defaultRequestTimeoutInterval;

@end

@interface IBMMobileFirstPlatformFoundationHelper : NSObject

// TO DO : check if this should be visible or not
/*
 * Returns the current <em>IBMMobileFirstPlatformFoundation<em> version
 */
+(NSString*) version;

@end
