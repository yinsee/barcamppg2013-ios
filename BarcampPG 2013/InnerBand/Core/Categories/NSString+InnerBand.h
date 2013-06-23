//
//  NSString+InnerBand.h
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


@interface NSString (InnerBand)

- (NSComparisonResult)diacriticInsensitiveCaseInsensitiveSort:(NSString *)rhs;
- (NSComparisonResult)diacriticInsensitiveSort:(NSString *)rhs;
- (NSComparisonResult)caseInsensitiveSort:(NSString *)rhs;

- (NSString *)asBundlePath;
- (NSString *)asDocumentsPath;
	
- (BOOL)contains:(NSString *)substring;
- (BOOL)contains:(NSString *)substring options:(NSStringCompareOptions)options;

- (NSString *)trimmedString;

// NOTE: the regex cannot be partial, it has to match the ENTIRE string.  So, "a" doesn't match "aaa", but "a*" or "a+" will.
- (BOOL)matchesRegex:(NSString *)regex;

@end
