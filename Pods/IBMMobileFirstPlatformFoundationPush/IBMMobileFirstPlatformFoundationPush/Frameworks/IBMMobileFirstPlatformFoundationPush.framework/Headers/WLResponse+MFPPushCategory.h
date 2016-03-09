/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2015, 2016. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>
#import <IBMMobileFirstPlatformFoundation/IBMMobileFirstPlatformFoundation.h>

@interface WLResponse (MFPPushCategory)

/**
 * This method returns a dictionary of subscriptions of the device
 *
 * @return An array of subscriptions.
 */
- (NSArray*) subscriptions;

/**
 * This method returns a list of available tags of the application.
 *
 * @return An array of tags.
 */
- (NSArray*) availableTags;

/**
 * This method returns the subscription status by parsing multi-part response
 *
 * @return A dictionary containing subscription status.
 */
- (NSDictionary*) subscribeStatus;

/**
 * This method returns the unsubscription status by parsing multi-part response
 *
 * @return A dictionary containing unsubscription status.
 */
- (NSDictionary*) unsubscribeStatus;

@end
