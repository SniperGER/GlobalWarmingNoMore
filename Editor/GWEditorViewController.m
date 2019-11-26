//
//  GWEditorViewController.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWEditorViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:GWLocalizedString(@"EDITOR_BUTTON_RESET") style:UIBarButtonItemStylePlain target:self action:@selector(resetActiveCity)];
	UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:GWLocalizedString(@"EDITOR_BUTTON_DONE") style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	
	self.navigationItem.leftBarButtonItem = leftButton;
	self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (@available(iOS 13, *)) {
		[self.navigationController.presentationController setDelegate:self];
	}
	
	userTemperatureUnit = [[objc_getClass("WeatherPreferences") sharedPreferences] userTemperatureUnit];
	
	if (_activeCity) {
		[self setTitle:_activeCity.name];
	}
	[self.tableView reloadData];
}

- (void)presentationControllerWillDismiss:(UIPresentationController *)presentationController {
	[self applyWeatherData];
}

- (void)dismiss {
	[self applyWeatherData];
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)applyWeatherData {
	[self.weatherCityView updateUI];
	[(WAPageCollectionViewController*)self.weatherCityView.presentingViewController scrollViewDidEndDecelerating:nil];
	[(WAPageCollectionViewController*)self.weatherCityView.presentingViewController updateBackground];
}

- (void)resetActiveCity {
	UIAlertController* alertController = [UIAlertController 
		alertControllerWithTitle:[NSString stringWithFormat:GWLocalizedString(@"EDITOR_RESET_TITLE"), _activeCity.name] 
		message:[NSString stringWithFormat:GWLocalizedString(@"EDITOR_RESET_DESCRIPTION"), _activeCity.name] 
		preferredStyle:UIAlertControllerStyleActionSheet];
	
	[alertController addAction:[UIAlertAction
		actionWithTitle:GWLocalizedString(@"EDITOR_RESET_ACTION_CANCEL")
		style:UIAlertActionStyleCancel
		handler:nil]];
	
	[alertController addAction:[UIAlertAction
		actionWithTitle:[NSString stringWithFormat:GWLocalizedString(@"EDITOR_RESET_ACTION_CONFIRM"), _activeCity.name] 
		style:UIAlertActionStyleDestructive
		handler:^(UIAlertAction* action) {
			[_activeCity setIsDirty:NO];
			[_activeCity setOverrideValues:nil];
			
			for (WAHourlyForecast* forecast in _activeCity.hourlyForecasts) {
				[forecast setOverrideValues:nil];
			}
			for (WADayForecast* forecast in _activeCity.dayForecasts) {
				[forecast setOverrideValues:nil];
			}
			
			[_activeCity setUpdateTime:[NSDate distantPast]];
			[(WAPageCollectionViewController*)self.weatherCityView.presentingViewController updateAndDisplayActiveCity];
			[(WAPageCollectionViewController*)self.weatherCityView.presentingViewController updateExtendedWeatherOnVisibleCells];
			[self dismiss];
	}]];
	
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleInput:(NSString*)input forConditionType:(ConditionType)conditionType atIndexPath:(NSIndexPath*)indexPath {
	if (!_activeCity.overrideValues) _activeCity.overrideValues = [NSMutableDictionary dictionary];
	
	switch (conditionType) {
		case ConditionTypeAirQualityCategory:
			_activeCity.airQualityCategory = @(input.intValue);
			break;
		case ConditionTypeAirQualityIndex:
			_activeCity.airQualityIdx = @(input.intValue);
			break;
		case ConditionTypeFeelsLike:
			_activeCity.overrideValues[@"feelsLike"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:input.floatValue];
			// [_activeCity.feelsLike _resetTemperatureValues];
			// [_activeCity.feelsLike _setValue:input.floatValue forUnit:userTemperatureUnit];
			break;
		case ConditionTypeHumidity:
			_activeCity.humidity = input.floatValue;
			break;
		case ConditionTypePrecipitationPast24Hours:
			_activeCity.precipitationPast24Hours = input.floatValue / 10;
			break;
		case ConditionTypePressure:
			_activeCity.pressure = input.floatValue;
			break;
		case ConditionTypeSunriseTime:
			_activeCity.sunriseTime = input.intValue;
			break;
		case ConditionTypeSunsetTime:
			_activeCity.sunsetTime = input.intValue;
			break;
		case ConditionTypeTemperature:
			_activeCity.overrideValues[@"temperature"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:input.floatValue];
			// [_activeCity.temperature _resetTemperatureValues];
			// [_activeCity.temperature _setValue:input.floatValue forUnit:userTemperatureUnit];
			break;
		case ConditionTypeUVIndex:
			_activeCity.uvIndex = input.intValue;
			break;
		case ConditionTypeVisibility:
			_activeCity.visibility = input.floatValue;
			break;
		case ConditionTypeWindDirection:
			_activeCity.windDirection = input.floatValue;
			break;
		case ConditionTypeWindSpeed:
			_activeCity.windSpeed = input.floatValue;
			break;
		default: break;
	}
	
	[_activeCity setIsDirty:YES];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: return 1;
		case 1: return 14;
		case 2: return _activeCity.hourlyForecasts.count;
		case 3: return _activeCity.dayForecasts.count;
		default: return 0;
	}
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 1: return GWLocalizedString(@"SECTION_CURRENT_CONDITIONS");
		case 2: return GWLocalizedString(@"SECTION_HOURLY_FORECAST");
		case 3: return GWLocalizedString(@"SECTION_DAY_FORECAST");
		default: return nil;
	}
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	if (indexPath.section == 0) {
		UITableViewCell* cell = [UITableViewCell new];
		
		[cell.textLabel setTextColor:[UIColor colorWithRed:0.0 green:0.47843 blue:1.0 alpha:1.0]];
		[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
		[cell.textLabel setText:GWLocalizedString(@"EDITOR_ACTION_RANDOMIZE")];
		
		return cell;
	} else if (indexPath.section == 1) {
		GWEditorTableViewCell* cell = (GWEditorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"currentConditionCell"];
		
		if (!cell) cell = [[GWEditorTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"currentConditionCell"];
		
		[cell setCity:_activeCity];
		[cell setConditionType:(ConditionType)indexPath.row];
		
		return cell;
		
	} else if (indexPath.section == 2) {
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hourlyForecastCell"];
		
		if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"hourlyForecastCell"];
		
		if (_activeCity.hourlyForecasts.count < indexPath.row) return cell;
		WAHourlyForecast* forecast = _activeCity.hourlyForecasts[indexPath.row];
		[cell.textLabel setText:forecast.time];
		
		WFTemperatureFormatter* formatter = [objc_getClass("WFTemperatureFormatter") temperatureFormatterWithInputUnit:2 outputUnit:userTemperatureUnit];
		
		[cell.detailTextLabel setTextColor:UIColor.grayColor];
		[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@, %@", 
			[GWWeatherConditionParser localizedStringForConditionCode:forecast.conditionCode],
			[formatter formattedStringFromTemperature:forecast.temperature]
		]];
		
		CGRect targetRect = CGRectMake(0, 0, 29, 29);
		UIImage* image = [objc_getClass("WeatherImageLoader") conditionImageWithConditionIndex:forecast.conditionCode];
		UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 2.0);
		
		[[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.0] setFill];
		UIRectFill(targetRect);
		
		[image drawInRect:targetRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		[cell.imageView setImage:image];
		[cell.imageView.layer setCornerRadius:3.625];
		[cell.imageView setClipsToBounds:YES];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		
		return cell;
	} else if (indexPath.section == 3) {
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dayForecastCell"];
		
		if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dayForecastCell"];
		
		if (_activeCity.dayForecasts.count < indexPath.row) return cell;
		WADayForecast* forecast = _activeCity.dayForecasts[indexPath.row];

		NSCalendar* calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
		[calendar setLocale:[NSLocale currentLocale]];
		NSArray* weekDays = [calendar weekdaySymbols];
		[cell.textLabel setText:weekDays[forecast.dayOfWeek - 1]];
		
		WFTemperatureFormatter* formatter = [objc_getClass("WFTemperatureFormatter") temperatureFormatterWithInputUnit:2 outputUnit:userTemperatureUnit];
		
		[cell.detailTextLabel setTextColor:UIColor.grayColor];
		[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@, %@, %@", 
			[GWWeatherConditionParser localizedStringForConditionCode:forecast.icon],
			[NSString stringWithFormat:GWLocalizedString(@"DAY_HIGH_SHORT"), [formatter formattedStringFromTemperature:forecast.high]],
			[NSString stringWithFormat:GWLocalizedString(@"DAY_LOW_SHORT"), [formatter formattedStringFromTemperature:forecast.low]]
		]];
		
		CGRect targetRect = CGRectMake(0, 0, 29, 29);
		UIImage* image = [objc_getClass("WeatherImageLoader") conditionImageWithConditionIndex:forecast.icon];
		UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 2.0);
		
		[[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.0] setFill];
		UIRectFill(targetRect);
		
		[image drawInRect:targetRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		[cell.imageView setImage:image];
		[cell.imageView.layer setCornerRadius:3.625];
		[cell.imageView setClipsToBounds:YES];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		
		return cell;
	}
	return [UITableViewCell new];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	switch (indexPath.section) {
		case 0: {
			if (!_activeCity.overrideValues) _activeCity.overrideValues = [NSMutableDictionary dictionary];
			
			_activeCity.airQualityCategory = [NSNumber numberWithInt:(arc4random_uniform(6) + 1)];
			_activeCity.airQualityIdx = [NSNumber numberWithInt:(arc4random_uniform(100) + 1)];
			_activeCity.conditionCode = arc4random_uniform((uint32_t)(47 + 1));
			_activeCity.overrideValues[@"feelsLike"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:(((float)arc4random() / 0x100000000) * (100 - -100) + -100)];
			_activeCity.humidity = ((float)arc4random() / 0x100000000) * (100);
			_activeCity.precipitationPast24Hours = (((float)arc4random() / 0x100000000) * (100)) / 100;
			_activeCity.pressure = ((float)arc4random() / 0x100000000) * (1050 - 1000) + 1000;
			_activeCity.sunriseTime = arc4random_uniform((uint32_t)(2359 + 1));
			_activeCity.sunsetTime = arc4random_uniform((uint32_t)(2359 + 1));
			_activeCity.overrideValues[@"temperature"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:(((float)arc4random() / 0x100000000) * (100 - -100) + -100)];
			_activeCity.uvIndex = arc4random_uniform((uint32_t)(15 + 1));
			_activeCity.visibility = ((float)arc4random() / 0x100000000) * (100);
			_activeCity.windSpeed = ((float)arc4random() / 0x100000000) * (120);
			_activeCity.windDirection = ((float)arc4random() / 0x100000000) * (360);
			
			for (WAHourlyForecast* forecast in _activeCity.hourlyForecasts) {
				if (!forecast.overrideValues) forecast.overrideValues = [NSMutableDictionary dictionary];

				forecast.conditionCode = arc4random_uniform((uint32_t)(47 + 1));
				forecast.percentPrecipitation = ((float)arc4random() / 0x100000000) * (100);
				forecast.overrideValues[@"temperature"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:(((float)arc4random() / 0x100000000) * (100 - -100) + -100)];
			}
			
			for (WADayForecast* forecast in _activeCity.dayForecasts) {
				if (!forecast.overrideValues) forecast.overrideValues = [NSMutableDictionary dictionary];
				
				forecast.overrideValues[@"high"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:(((float)arc4random() / 0x100000000) * (100 - -100) + -100)];
				forecast.icon = arc4random_uniform((uint32_t)(47 + 1));
				forecast.overrideValues[@"low"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:(((float)arc4random() / 0x100000000) * (100 - -100) + -100)];
			}
			
			[_activeCity setIsDirty:YES];
			[tableView reloadData];
		
			break;
		}
		case 1: {
			GWEditorTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
			
			if (cell.conditionType != ConditionTypeConditionCode) {
				UIAlertController* alertController = [UIAlertController 
					alertControllerWithTitle:[NSString stringWithFormat:GWLocalizedString(@"EDITOR_EDIT_TITLE"), cell.textLabel.text] 
					message:[NSString stringWithFormat:GWLocalizedString(@"EDITOR_EDIT_DESCRIPTION"), cell.textLabel.text] 
					preferredStyle:UIAlertControllerStyleAlert];
				
				[alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
					[textField setPlaceholder:cell.detailTextLabel.text];
					[textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
				}];
				
				[alertController addAction:[UIAlertAction
					actionWithTitle:GWLocalizedString(@"EDITOR_EDIT_ACTION_CANCEL")
					style:UIAlertActionStyleCancel
					handler:^(UIAlertAction* action) {
						[tableView deselectRowAtIndexPath:indexPath animated:YES];
				}]];
				[alertController addAction:[UIAlertAction
					actionWithTitle:GWLocalizedString(@"EDITOR_EDIT_ACTION_CONFIRM")
					style:UIAlertActionStyleDefault
					handler:^(UIAlertAction* action) {
						[self 
							handleInput:alertController.textFields.firstObject.text
							forConditionType:cell.conditionType
							atIndexPath:indexPath];
				}]];
				
				[self presentViewController:alertController animated:YES completion:nil];
			} else {
				GWWeatherConditionPickerController* conditionPicker = [[GWWeatherConditionPickerController alloc] initWithStyle:UITableViewStyleGrouped];
				[conditionPicker setCity:_activeCity];
				[self.navigationController pushViewController:conditionPicker animated:YES];
			}
			
			break;
		}
		case 2: {
			GWHourlyForecastEditorViewController* forecastEditor = [[GWHourlyForecastEditorViewController alloc] initWithStyle:UITableViewStyleGrouped];
			[forecastEditor setCity:_activeCity];
			[forecastEditor setForecast:_activeCity.hourlyForecasts[indexPath.row]];
			[self.navigationController pushViewController:forecastEditor animated:YES];
			
			break;
		}
		case 3: {
			GWDayForecastEditorViewController* forecastEditor = [[GWDayForecastEditorViewController alloc] initWithStyle:UITableViewStyleGrouped];
			[forecastEditor setCity:_activeCity];
			[forecastEditor setForecast:_activeCity.dayForecasts[indexPath.row]];
			[self.navigationController pushViewController:forecastEditor animated:YES];
			
			break;
		}
	}
}

@end
