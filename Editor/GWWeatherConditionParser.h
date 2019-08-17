//
//  GWWeatherConditionParser.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include <Foundation/Foundation.h>

@interface GWWeatherConditionParser : NSObject

+ (NSString*)conditionNameForConditionCode:(int)conditionCode;
+ (NSString*)localizedStringForConditionCode:(int)conditionCode;

@end