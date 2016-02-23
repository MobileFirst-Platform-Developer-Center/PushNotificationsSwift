/**
	Licensed Materials - Property of IBM

	(C) Copyright 2015 IBM Corp.

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/


#import <Foundation/Foundation.h>

/**
 Contains Simple Data Sharing methods to share tokens across a group of applications.
 @since IBM Worklight V6.2.0
 */
@interface WLSimpleDataSharing : NSObject

/**
 Saves a key,value pair to a shared credential storage available to a group of applications in the same family.
 @param name The key or name of token to save to the shared credential storage
 @param value The value of the token to save to the shared credential storage
 @return Boolean indicating whether the token was successfully stored.
 @since IBM Worklight V6.2.0
 */
+ (BOOL) setSharedToken:(NSString*)name value:(NSString*) value;

/**
 Retrieves the value of a token in the shared credential storage.
 @param name The name of the token to retrive from shared credential storage.
 @return A string representing the value of the token found in shared credential storage or nil if not found.
 @since IBM Worklight V6.2.0
 */
+ (NSString*) getSharedToken:(NSString*)name;

/**
 Removes the token from shared credential storage.
 @param name The name of the token to remove from shared credential storage.
 @return Boolean indicating whether the token was found and successfully removed.
 @since IBM Worklight V6.2.0
 */
+ (BOOL) clearSharedToken:(NSString*)name;


@end
