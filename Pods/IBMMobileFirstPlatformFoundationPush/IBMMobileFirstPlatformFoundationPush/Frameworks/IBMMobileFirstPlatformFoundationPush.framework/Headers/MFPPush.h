/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>
#import <IBMMobileFirstPlatformFoundation/IBMMobileFirstPlatformFoundation.h>

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
 *
 * @param deviceToken - the device token received from APNS.
 * @param completionHandler - returns a WLResponse or NSError
 */
-(void) registerDevice: (NSData*) deviceToken completionHandler: (void(^) (WLResponse *response, NSError* error)) completionHandler;

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


