//
//  GWDayForecastEditorViewController.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWDayForecastEditorViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	userTemperatureUnit = [[objc_getClass("WeatherPreferences") sharedPreferences] userTemperatureUnit];
	
	if (_forecast) {
		NSCalendar* calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
		[calendar setLocale:[NSLocale currentLocale]];
		NSArray* weekDays = [calendar weekdaySymbols];
		[self setTitle:weekDays[_forecast.dayOfWeek - 1]];
	}
	[self.tableView reloadData];
}

- (void)handleInput:(NSString*)input forConditionType:(ConditionType)conditionType atIndexPath:(NSIndexPath*)indexPath {
	if (!_forecast.overrideValues) _forecast.overrideValues = [NSMutableDictionary dictionary];
	
	switch (indexPath.row) {
		case 0:
			_forecast.overrideValues[@"high"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:input.floatValue];
			break;
		case 2:
			_forecast.overrideValues[@"low"] = [[objc_getClass("WFTemperature") alloc] initWithTemperatureUnit:userTemperatureUnit value:input.floatValue];
			break;
		default: break;
	}
	
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"forecastCell"];
	
	if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"forecastCell"];
	if (!_forecast) return cell;
	
	[cell.detailTextLabel setTextColor:UIColor.grayColor];
	
	switch (indexPath.row) {
		case 0: {
			WFTemperatureFormatter* formatter = [objc_getClass("WFTemperatureFormatter") temperatureFormatterWithInputUnit:2 outputUnit:userTemperatureUnit];
			
			[cell.textLabel setText:GWLocalizedString(@"DAY_HIGH")];
			[cell.detailTextLabel setText:[formatter formattedStringFromTemperature:_forecast.high]];
			
			break;
		}
		case 1: {
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[cell.textLabel setText:GWLocalizedString(@"CURRENT_CONDITION")];
			[cell.detailTextLabel setText:[GWWeatherConditionParser localizedStringForConditionCode:_forecast.icon]];
			
			CGRect targetRect = CGRectMake(0, 0, 29, 29);
			UIImage* image = [objc_getClass("WeatherImageLoader") conditionImageWithConditionIndex:_forecast.icon];
			UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 2.0);
			
			[[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.0] setFill];
			UIRectFill(targetRect);
			
			[image drawInRect:targetRect];
			image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			[cell.imageView setImage:image];
			[cell.imageView.layer setCornerRadius:3.625];
			[cell.imageView setClipsToBounds:YES];
			
			break;
		}
		case 2: {
			WFTemperatureFormatter* formatter = [objc_getClass("WFTemperatureFormatter") temperatureFormatterWithInputUnit:2 outputUnit:userTemperatureUnit];
			
			[cell.textLabel setText:GWLocalizedString(@"DAY_LOW")];
			[cell.detailTextLabel setText:[formatter formattedStringFromTemperature:_forecast.low]];
			
			break;
		}
		default: break;
	}
	
	return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	
	switch (indexPath.row) {
		case 0:
		case 2: {
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
						forConditionType:-1
						atIndexPath:indexPath];
			}]];
			
			[self presentViewController:alertController animated:YES completion:nil];
			
			break;
		}
		case 1: {
			GWWeatherConditionPickerController* conditionPicker = [[GWWeatherConditionPickerController alloc] initWithStyle:UITableViewStyleGrouped];
			[conditionPicker setCity:_city];
			[conditionPicker setDayForecast:_forecast];
			[self.navigationController pushViewController:conditionPicker animated:YES];
			
			break;
		}
		default: break;
	}
}

@end
