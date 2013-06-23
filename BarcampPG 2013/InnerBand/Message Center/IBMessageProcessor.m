//
//  IBMessageProcessor.m
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IBMessageProcessor.h"
#import "IBDispatchMessage.h"
#import "IBTargetAction.h"

@implementation IBMessageProcessor

- (id)initWithMessage:(IBDispatchMessage *)message targetActions:(NSArray *)targetActions {
	self = [super init];
	
	if (self) {
        _message = message;
		_targetActions = [targetActions copy];
	}
	
	return self;
}

- (void)process {
	// process
	[_message inputData:nil];
	
	// dispatch for all target/action pairs
	for (NSInteger i = _targetActions.count - 1; i >= 0; --i) {
        IBTargetAction *targetAction = (IBTargetAction *)[_targetActions objectAtIndex:i];
		id iTarget = targetAction.target;
		SEL iAction = NSSelectorFromString(targetAction.action);
		
		// perform on main thread
		if (_message.isAsynchronous) {
			[iTarget performSelectorOnMainThread:iAction withObject:_message waitUntilDone:NO];
		} else {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [iTarget performSelector:iAction withObject:_message];
            #pragma clang diagnostic pop						
		}
	}
}

@end
