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
//  EventSourceListener.h
//  WorklightStaticLibProject
//
//  Created by worklightdev on 24/01/13.
//  Copyright (c) 2013 odedr@worklight.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WLEventSourceListener <NSObject>

-(void)onReceive:(NSString *)props :(NSString *)payload;

@end
