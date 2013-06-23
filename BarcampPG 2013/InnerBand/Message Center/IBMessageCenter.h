//
//  IBMessageCenter.h
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

#import <Foundation/Foundation.h>

@class IBDispatchMessage;

@interface IBMessageCenter : NSObject {
}

// testing
+ (NSInteger)getCountOfListeningSources;

+ (void)setDebuggingEnabled:(BOOL)enabled;
+ (BOOL)isDebuggingEnabled;
	
// add message listener
+ (void)addGlobalMessageListener:(NSString *)name target:(id)target action:(SEL)action;
+ (void)addMessageListener:(NSString *)name source:(id)source target:(id)target action:(SEL)action;

// remove message listener
+ (void)removeMessageListener:(NSString *)name source:(id)source target:(id)target action:(SEL)action;
+ (void)removeMessageListener:(NSString *)name source:(id)source target:(id)target;
+ (void)removeMessageListener:(NSString *)name target:(id)target action:(SEL)action;
+ (void)removeMessageListenersForTarget:(id)name;

// global dispatches
+ (void)sendGlobalMessage:(IBDispatchMessage *)message;
+ (void)sendGlobalMessageNamed:(NSString *)name;
+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfoKey:(id)key andValue:(id)value;
+ (void)sendGlobalMessageNamed:(NSString *)name withObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

// source dispatches
+ (void)sendMessage:(IBDispatchMessage *)message forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name withUserInfoKey:(id)key andValue:(id)value forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name forSource:(id)source withObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end
