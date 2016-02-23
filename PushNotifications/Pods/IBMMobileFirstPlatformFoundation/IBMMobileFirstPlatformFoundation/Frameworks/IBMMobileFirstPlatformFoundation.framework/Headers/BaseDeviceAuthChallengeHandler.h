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
//  BaseDeviceAuthChallengeHandler.h
//  WorklightStaticLibProject
//
//  Created by Ishai Borovoy on 9/13/12.
//  Base class for all device authentication classes
//

#import "BaseChallengeHandler.h"
#import "WLChallengeHandler.h"

@interface BaseDeviceAuthChallengeHandler : WLChallengeHandler
    -(void) getDeviceAuthDataAsync : (NSDictionary *) inputData;
    -(void) onDeviceAuthDataReady : (NSDictionary *) deviceData;
@end
