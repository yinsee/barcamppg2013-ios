//
//  NSNumber+InnerBand.m
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

#import "NSNumber+InnerBand.h"

@implementation NSNumber (InnerBand)

- (NSString *)formattedCurrency {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];

	[format setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	return [format stringFromNumber:self];
}

- (NSString *)formattedFlatCurrency {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];

    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setMinimumFractionDigits:2];
    [format setMaximumFractionDigits:2];
    
    return [format stringFromNumber:self];
}

- (NSString *)formattedCurrencyWithMinusSign {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];

	[format setNumberStyle:NSNumberFormatterCurrencyStyle];
	[format setNegativeFormat:@"-$#,##0.00"];

	return [format stringFromNumber:self];
}

- (NSString *)formattedDecimal {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];

	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	
	return [format stringFromNumber:self];
}

- (NSString *)formattedFlatDecimal {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];

	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	[format setGroupingSeparator:@""];
	
	return [format stringFromNumber:self];
}

- (NSString *)formattedSpellOut {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];

	[format setNumberStyle:NSNumberFormatterSpellOutStyle];
	
	return [format stringFromNumber:self];
}

@end
