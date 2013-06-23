//
//  IBMessageCenter.m
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

#import "IBMessageCenter.h"
#import "IBDispatchMessage.h"
#import "IBMessageProcessor.h"
#import "NSObject+InnerBand.h"
#import "NSMutableArray+InnerBand.h"
#import "IBTargetAction.h"

@interface IBMessageCenter (private)

+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name source:(id)source;
+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name sourceDescription:(NSString *)sourceDescription;
+ (void)runProcessorInThread:(IBDispatchMessage *)message targetActions:(NSArray *)targetActions;

@end

// (Source: MemAddr|Null) -> (Name) -> ([Target/Actions])
static NSMutableDictionary *_messageListeners = nil;

// debugging
static BOOL _debuggingEnabled = NO;

static NSString *getSourceIdentifier(id obj) {
	return [NSString stringWithFormat:@"%p", obj];
}

@implementation IBMessageCenter

+ (NSInteger)getCountOfListeningSources {
	return [_messageListeners count];
}

+ (void)setDebuggingEnabled:(BOOL)enabled {
	_debuggingEnabled = enabled;
}

+ (BOOL)isDebuggingEnabled {
	return _debuggingEnabled;
}

#pragma mark -

+ (void)initialize {
	_messageListeners = [[NSMutableDictionary alloc] init];
}

#pragma mark -

+ (void)addGlobalMessageListener:(NSString *)name target:(id)target action:(SEL)action {
	[IBMessageCenter addMessageListener:name source:nil target:target action:action];
}

+ (void)addMessageListener:(NSString *)name source:(id)source target:(id)target action:(SEL)action {
	// remove existing listener (avoids duplication)
	[IBMessageCenter removeMessageListener:name source:source target:target action:action];
	
	// add listener
	NSMutableArray *targetActions = [IBMessageCenter getTargetActionsForMessageName:name source:source];
    IBTargetAction *targetAction = [[IBTargetAction alloc] init];
    
    targetAction.target = target;
    targetAction.action = NSStringFromSelector(action);
    
	[targetActions addObject:targetAction];
}

#pragma mark -

+ (void)removeMessageListener:(NSString *)name source:(id)source target:(id)target action:(SEL)action {
	NSMutableArray *targetActions = [IBMessageCenter getTargetActionsForMessageName:name source:source];
	
	// remove all matching target/action pairs
	for (NSInteger i = targetActions.count - 1; i >= 0; --i) {
		IBTargetAction *targetAction = (IBTargetAction *)[targetActions objectAtIndex:i];
		id iTarget = targetAction.target;
		
		// remove if matched
		if (iTarget == target) {
			SEL iAction = NSSelectorFromString(targetAction.action);
			
			if (iAction == action) {
				[targetActions removeObjectAtIndex:i];
			}
		}
	}
}

+ (void)removeMessageListener:(NSString *)name source:(id)source target:(id)target {
	NSMutableArray *targetActions = [IBMessageCenter getTargetActionsForMessageName:name source:source];
	
	// remove all matching targets
	for (NSInteger i = targetActions.count - 1; i >= 0; --i) {
		IBTargetAction *targetAction = (IBTargetAction *)[targetActions objectAtIndex:i];
		id iTarget = targetAction.target;
		
		// remove if matched
		if (iTarget == target) {
			[targetActions removeObjectAtIndex:i];
		}
	}
}

+ (void)removeMessageListener:(NSString *)name target:(id)target action:(SEL)action {
	for (NSMutableDictionary *iMessageNames in _messageListeners) {
		for (NSMutableArray *iTargetActions in iMessageNames) {
			// remove all matching target/action pairs
			for (NSInteger i = iTargetActions.count - 1; i >= 0; --i) {
                IBTargetAction *targetAction = (IBTargetAction *)[iTargetActions objectAtIndex:i];
                id iTarget = targetAction.target;
				
				// remove if matched
				if (iTarget == target) {
                    SEL iAction = NSSelectorFromString(targetAction.action);
					
					if (iAction == action) {
						[iTargetActions removeObjectAtIndex:i];
					}
				}
			}
		}
	}
}

+ (void)removeMessageListenersForTarget:(id)target {
	for (NSString *iSourceDescription in _messageListeners) {
		NSMutableDictionary *targetActionsByName = [_messageListeners objectForKey:iSourceDescription];
		for (NSString *iTargetActionName in targetActionsByName) {
			NSMutableArray *iTargetActions = [targetActionsByName objectForKey:iTargetActionName];
			
			// remove all matching target/action pairs
			for (NSInteger i = iTargetActions.count - 1; i >= 0; --i) {
                IBTargetAction *targetAction = (IBTargetAction *)[iTargetActions objectAtIndex:i];
                id iTarget = targetAction.target;
				
				// remove if matched
				if (iTarget == target) {
					[iTargetActions removeObjectAtIndex:i];
				}
			}
		}
	}
}

#pragma mark -

+ (void)sendGlobalMessageNamed:(NSString *)name {
	[IBMessageCenter sendMessageNamed:name forSource:nil];
}

+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
	[IBMessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:nil];
}

+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfoKey:(id)key andValue:(id)value {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:value forKey:key];
	[IBMessageCenter sendGlobalMessageNamed:name withUserInfo:userInfo];
}

+ (void)sendGlobalMessageNamed:(NSString *)name withObjectsAndKeys:(id)firstObject, ... {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    id currentObject = nil;
    id currentKey = nil;
    va_list argList;
    
    if (firstObject) {
        va_start(argList, firstObject);
        currentObject = firstObject;
        
        do {
            currentKey = va_arg(argList, id);
            [userInfo setObject:currentObject forKey:currentKey];
        } while ((currentObject = va_arg(argList, id)));
        
        va_end(argList);        
    }

    [IBMessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:nil ];
}

+ (void)sendGlobalMessage:(IBDispatchMessage *)message {
	[IBMessageCenter sendMessage:message forSource:nil];
}

+ (void)sendMessageNamed:(NSString *)name forSource:(id)source {
	IBDispatchMessage *message = [IBDispatchMessage messageWithName:name userInfo:nil];
	
	// dispatch
	[IBMessageCenter sendMessage:message forSource:source];
}

+ (void)sendMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo forSource:(id)source {
	IBDispatchMessage *message = [IBDispatchMessage messageWithName:name userInfo:userInfo];
	
	// dispatch
	[IBMessageCenter sendMessage:message forSource:source];
}

+ (void)sendMessageNamed:(NSString *)name withUserInfoKey:(id)key andValue:(id)value forSource:(id)source {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:value forKey:key];
	[IBMessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:source];
}

+ (void)sendMessageNamed:(NSString *)name forSource:(id)source withObjectsAndKeys:(id)firstObject, ... {
    // construct user info
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    id currentObject = nil;
    id currentKey = nil;
    va_list argList;
    
    if (firstObject) {
        va_start(argList, firstObject);
        currentObject = firstObject;
        
        do {
            currentKey = va_arg(argList, id);
            [userInfo setObject:currentObject forKey:currentKey];
        } while ((currentObject = va_arg(argList, id)));
        
        va_end(argList);        
    }

	// dispatch
	[IBMessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:source];
}

+ (void)sendMessage:(IBDispatchMessage *)message forSource:(id)source {
	// global or local delivery only
	NSArray *targetActions = [IBMessageCenter getTargetActionsForMessageName:message.name source:source];
	
	if (message.isAsynchronous) {
		// run completely in thread
		[IBMessageCenter performSelectorInBackground:@selector(runProcessorInThread:targetActions:) withObject:message withObject:targetActions];
	} else {
		// process message in sync
		IBMessageProcessor *processor = [[IBMessageProcessor alloc] initWithMessage:message targetActions:targetActions];

		[processor process];
	}
}

+ (void)runProcessorInThread:(IBDispatchMessage *)message targetActions:(NSArray *)targetActions {
	// pool
    @autoreleasepool {
        // process message
        IBMessageProcessor *processor = [[IBMessageProcessor alloc] initWithMessage:message targetActions:targetActions];

        // process
        [processor process];
    }
}

#pragma mark -

+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name source:(id)source {
	// if no source given, treat as global listener (use self as key)
	if (!source) {
		source = [NSNull null];
	}
	
	return [self.class getTargetActionsForMessageName:name sourceDescription:getSourceIdentifier(source)];
}

+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name sourceDescription:(NSString *)sourceDescription {
	NSMutableDictionary *messageNames = [_messageListeners objectForKey:sourceDescription];
	
	// add a new dictionary if there isn't one
	if (!messageNames) {
		[_messageListeners setObject:(messageNames = [NSMutableDictionary dictionary]) forKey:sourceDescription];
	}
	
	NSMutableArray *targetActions = [messageNames objectForKey:name];
	
	// add a new array if there isn't one
	if (!targetActions) {
		[messageNames setObject:(targetActions = [NSMutableArray array]) forKey:name];
    } else {
        // clean up
        [targetActions deleteIf:^NSInteger(id iTA) {
            return (![iTA target]);
        }];
    }

	return targetActions;
}

@end

