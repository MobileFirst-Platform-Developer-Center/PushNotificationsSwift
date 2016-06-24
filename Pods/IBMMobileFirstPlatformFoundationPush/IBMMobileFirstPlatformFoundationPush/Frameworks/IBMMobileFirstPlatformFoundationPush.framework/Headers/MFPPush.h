/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2015, 2016. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>
#import <IBMMobileFirstPlatformFoundation/IBMMobileFirstPlatformFoundation.h>
#import <objc/message.h>

extern NSString * const MFPPushErrorDomain;

enum{
    MFPPushErrorInternalError					= 1,
    MFPPushErrorInvalidToken					= 2,
    MFPPushErrorRemoteNotificationsNotSupported	= 3,
    MFPPushErrorEmptyTagArray                   = 4,
    MFPPushRegistrationVerificationError        = 5,
    MFPPushRegistrationError                    = 6,
    MFPPushRegistrationUpdateError              = 7,
    MFPPushRetrieveSubscriptionError            = 8,
    MFPPushRetrieveTagsError                    = 9,
    MFPPushTagSubscriptionError                 = 10,
    MFPPushTagUnsubscriptionError               = 11
};

/**
 * MFPPush class provides APIs for functionalities that are supported by the MFP Push Notification SDK
 *
 */
@interface MFPPush : NSObject

/**
 * This method creates the singleton instance of MFPPush
 *
 * @return The instance of the initialized MFPPush
 *
 */
+(MFPPush*) sharedInstance;


/**
 * This method initializes the MFPPush instance
 *
 */
-(void)initialize;


/**
 * This method initializes the MFPPush instance
 *
 */
-(void)initialize: (NSTimeInterval)timeout;

/**
 * This method checks whether push notification is supported.
 *
 */
-(BOOL)isPushSupported;

/**
 * This method retrieves all the subscriptions of the device
 *
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) getSubscriptions:(void(^) (WLResponse *response, NSError* error)) completionHandler;

/**
 * This method retrieves all the available tags of the application
 *
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) getTags:(void(^) (WLResponse *response, NSError* error)) completionHandler;


/**
 * This method registers the device with the push service
 * @param options - Mandatory. iOS notification options
 *					{ phoneNumber: String, alert: boolean, badge: boolean, sound: boolean, categories: NSSet }
 *					where
 *                      phoneNumber - Phone number to receive the SMS based notifications
 *						alert - To enable displaying alert messages
 *						badge - To enable badge icons
 *						sound - To enable playing sound
 *						categories - iOS8 interactive notification categories
 *					for example
 *						UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
 *						acceptAction.identifier = @"OK";
 *						acceptAction.title = @"OK";
 *
 *						UIMutableUserNotificationAction *rejetAction = [[UIMutableUserNotificationAction alloc] init];
 *						rejetAction.identifier = @"NOK";
 *						rejetAction.title = @"NOK";
 *
 *						UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
 *						category.identifier = @"poll";
 *						[category setActions:@[acceptAction,rejetAction] forContext:UIUserNotificationActionContextDefault];
 *						[category setActions:@[acceptAction,rejetAction] forContext:UIUserNotificationActionContextMinimal];
 *
 *						NSDictionary *options = @{
 *                          @"phoneNumber": @"999999999",
 *							@"alert": @true,
 *							@"badge": @true,
 *							@"sound": @true,
 *							@"categories": [NSSet setWithObject:category]
 *						}
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) registerDevice:(NSDictionary *) options completionHandler: (void(^) (WLResponse *response, NSError* error)) completionHandler;


/**
 * This method sends the device token to be registered with the push service
 *
 * @param deviceToken - the device token received from APNS.
 */
-(void) sendDeviceToken: (NSData*) deviceToken;

/**
 * This method subscribes the device to the given tags
 *
 * @param tagsArray - the tag array
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) subscribe: (NSArray*) tagsArray completionHandler: (void(^) (WLResponse* response, NSError* error)) completionHandler;

/**
 * This method unsubscribes the device from the given tags
 *
 * @param tagsArray - the tag array
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) unsubscribe: (NSArray*) tagsArray completionHandler: (void(^) (WLResponse* response, NSError * error))completionHandler;

/**
 * This method unregisters the device from the push service
 *
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) unregisterDevice: (void(^) (WLResponse *response, NSError* error)) completionHandler;

@end


