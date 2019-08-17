//
//  GWWeatherConditionParser.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "GWWeatherConditionParser.h"

@implementation GWWeatherConditionParser

+ (NSString*)conditionNameForConditionCode:(int)conditionCode {
	switch (conditionCode) {
		case 0: return @"WeatherConditionTornado";
		case 1: return @"WeatherConditionTropicalStorm";
		case 2: return @"WeatherConditionHurricane";
		case 3: return @"WeatherConditionSevereThunderstorm";
		case 4: return @"WeatherConditionThunderstorm";
		case 5: return @"WeatherConditionMixedRainAndSnow";
		case 6: return @"WeatherConditionMixedRainAndSleet";
		case 7: return @"WeatherConditionMixedSnowAndSleet";
		case 8: return @"WeatherConditionFreezingDrizzle";
		case 9: return @"WeatherConditionDrizzle";
		case 10: return @"WeatherConditionFreezingRain";
		case 11: return @"WeatherConditionShowers1";
		case 12: return @"WeatherConditionRain";
		case 13: return @"WeatherConditionSnowFlurries";
		case 14: return @"WeatherConditionSnowShowers";
		case 15: return @"WeatherConditionBlowingSnow";
		case 16: return @"WeatherConditionSnow";
		case 17: return @"WeatherConditionHail";
		case 18: return @"WeatherConditionSleet";
		case 19: return @"WeatherConditionDust";
		case 20: return @"WeatherConditionFog";
		case 21: return @"WeatherConditionHaze";
		case 22: return @"WeatherConditionSmoky";
		case 23: return @"WeatherConditionBreezy";
		case 24: return @"WeatherConditionWindy";
		case 25: return @"WeatherConditionFrigid";
		case 26: return @"WeatherConditionCloudy";
		case 27: return @"WeatherConditionMostlyCloudyNight";
		case 28: return @"WeatherConditionMostlyCloudyDay";
		case 29: return @"WeatherConditionPartlyCloudyNight";
		case 30: return @"WeatherConditionPartlyCloudyDay";
		case 31: return @"WeatherConditionClearNight";
		case 32: return @"WeatherConditionSunny";
		case 33: return @"WeatherConditionMostlySunnyNight";
		case 34: return @"WeatherConditionMostlySunnyDay";
		case 35: return @"WeatherConditionMixedRainFall";
		case 36: return @"WeatherConditionHot";
		case 37: return @"WeatherConditionIsolatedThunderstorms";
		case 38: return @"WeatherConditionScatteredThunderstorms";
		case 39:
		case 45: return @"WeatherConditionScatteredShowers";
		case 40: return @"WeatherConditionHeavyRain";
		case 41:
		case 46: return @"WeatherConditionScatteredSnowShowers";
		case 42: return @"WeatherConditionHeavySnow";
		case 43: return @"WeatherConditionBlizzard";
		case 44: return @"NotAvailable";
		case 47: return @"WeatherConditionIsolatedThundershowers";
		default: return nil;
	}
}

+ (NSString*)localizedStringForConditionCode:(int)conditionCode {
	NSBundle* weatherFramework = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"];
	
	if (conditionCode == 44) return [weatherFramework localizedStringForKey:@"DASH_DASH" value:nil table:@"WeatherFrameworkLocalizableStrings"];
	
	return [weatherFramework localizedStringForKey:[self conditionNameForConditionCode:conditionCode] value:nil table:@"WeatherFrameworkLocalizableStrings"];
}

@end