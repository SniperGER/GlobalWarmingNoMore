//
//  GWEditorTableViewCell.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWEditorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.detailTextLabel setTextColor:UIColor.grayColor];
	}
	
	return self;
}

- (void)setConditionType:(ConditionType)conditionType {
	_conditionType = conditionType;
	
	NSBundle* weatherFramework = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"];
	
	switch (conditionType) {
		case ConditionTypeAirQualityCategory: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"AQ_DESCRIPTION" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[_city.airQualityCategory stringValue]];
			break;
		}
		case ConditionTypeAirQualityIndex: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"AQI" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[_city.airQualityIdx stringValue]];
			break;
		}
		case ConditionTypeConditionCode: {
			[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[self.textLabel setText:GWLocalizedString(@"CURRENT_CONDITION")];
			[self.detailTextLabel setText:[GWWeatherConditionParser localizedStringForConditionCode:_city.conditionCode]];
			
			break;
		}
		case ConditionTypeFeelsLike: {
			WFTemperatureFormatter* formatter = [objc_getClass("WFTemperatureFormatter") temperatureFormatterWithInputUnit:2 outputUnit:[[objc_getClass("WeatherPreferences") sharedPreferences] userTemperatureUnit]];
			
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"FEELS_LIKE" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[formatter formattedStringFromTemperature:_city.feelsLike]];
			break;
		}
		case ConditionTypeHumidity: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"HUMIDITY" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[NSString stringWithFormat:@"%.00f %%", _city.humidity]];
			break;
		}
		case ConditionTypePrecipitationPast24Hours: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"PRECIPITATION" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[[objc_getClass("WeatherPrecipitationFormatter") convenienceFormatter] stringFromDistance:_city.precipitationPast24Hours isDataMetric:YES]];
			break;
		}
		case ConditionTypePressure: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"PRESSURE" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[[objc_getClass("WeatherPressureFormatter") convenienceFormatter] stringFromPressure:_city.pressure isDataMetric:YES]];
			break;
		}
		case ConditionTypeSunriseTime: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"SUNRISE" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[NSString stringWithFormat:@"%lu", _city.sunriseTime]];
			break;
		}
		case ConditionTypeSunsetTime: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"SUNSET" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[NSString stringWithFormat:@"%lu", _city.sunsetTime]];
			break;
		}
		case ConditionTypeTemperature: {
			WFTemperatureFormatter* formatter = [objc_getClass("WFTemperatureFormatter") temperatureFormatterWithInputUnit:2 outputUnit:[[objc_getClass("WeatherPreferences") sharedPreferences] userTemperatureUnit]];
			
			[self.textLabel setText:GWLocalizedString(@"CURRENT_TEMPERATURE")];
			[self.detailTextLabel setText:[formatter formattedStringFromTemperature:_city.temperature]];
			break;
		}
		case ConditionTypeUVIndex: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"UV_INDEX" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[NSString stringWithFormat:@"%lu", _city.uvIndex]];
			break;
		}
		case ConditionTypeVisibility: {
			[self.textLabel setText:[weatherFramework localizedStringForKey:@"VISIBILITY" value:nil table:@"WeatherFrameworkLocalizableStrings"]];
			[self.detailTextLabel setText:[[objc_getClass("WeatherVisibilityFormatter") convenienceFormatter] stringFromKilometers:_city.visibility]];
			break;
		}
		case ConditionTypeWindDirection: {
			[self.textLabel setText:GWLocalizedString(@"CURRENT_WIND_DIRECTION")];
			[self.detailTextLabel setText:[NSString stringWithFormat:@"%.00f° (%@)", _city.windDirection, [[objc_getClass("WeatherWindSpeedFormatter") convenienceFormatter] stringForWindDirection:_city.windDirection]]];
			break;
		}
		case ConditionTypeWindSpeed: {
			WeatherWindSpeedFormatter* formatter = [objc_getClass("WeatherWindSpeedFormatter") convenienceFormatter];
			[self.textLabel setText:GWLocalizedString(@"CURRENT_WIND_SPEED")];
			[self.detailTextLabel setText:[formatter stringForWindSpeed:[formatter speedByConvertingToUserUnit:_city.windSpeed]]];
			break;
		}
		default: break;
	}
	
	if (conditionType == ConditionTypeConditionCode) {
		CGRect targetRect = CGRectMake(0, 0, 29, 29);
		UIImage* image = [objc_getClass("WeatherImageLoader") conditionImageWithConditionIndex:_city.conditionCode];
		UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 2.0);
		
		[[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.0] setFill];
		UIRectFill(targetRect);
		
		[image drawInRect:targetRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		[self.imageView setImage:image];
		[self.imageView.layer setCornerRadius:3.625];
		[self.imageView setClipsToBounds:YES];
	} else {
		[self.imageView setImage:nil];
	}
}

@end