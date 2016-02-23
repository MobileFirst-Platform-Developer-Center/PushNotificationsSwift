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
//  WLUserCertAuth.h
//  WorklightStaticLibProject
//
//  Created by Lizet Ernand on 10/1/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//


/**
 * This class provides some methods that can be used for the configuration of the
 * X509 User Certificate Enrollment and Authentication feature.
 */
@interface WLUserCertAuth : NSObject

/**
 * Cleans User Certificate Credentials from KeyChain
 *
 *  @return return the true if successfully removed User Certificate credentials from the keyChain
 */
+ (BOOL) deleteUserCertificateCredentials;

@end
