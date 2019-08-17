//
//  GWWeatherConditionPickerController.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWWeatherConditionPickerController

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self setTitle:GWLocalizedString(@"CURRENT_CONDITION")];
	}
	
	return self;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return 48;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	if (indexPath.section == 0) {
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
		
		if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
		[cell.textLabel setText:[GWWeatherConditionParser localizedStringForConditionCode:indexPath.row]];
		
		CGRect targetRect = CGRectMake(0, 0, 29, 29);
		UIImage* image = [objc_getClass("WeatherImageLoader") conditionImageWithConditionIndex:indexPath.row];
		UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 2.0);
		
		[[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.0] setFill];
		UIRectFill(targetRect);
		
		[image drawInRect:targetRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		[cell.imageView setImage:image];
		[cell.imageView.layer setCornerRadius:3.625];
		[cell.imageView setClipsToBounds:YES];
		
		if ((_dayForecast && _dayForecast.icon == indexPath.row) ||
			(_hourlyForecast && _hourlyForecast.conditionCode == indexPath.row)) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else if (_city.conditionCode == indexPath.row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		return cell;
	}
	return [UITableViewCell new];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if (_dayForecast) {
		[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_dayForecast.icon inSection:0]].accessoryType = UITableViewCellAccessoryNone;
		_dayForecast.icon = indexPath.row;
	} else if (_hourlyForecast) {
		[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_hourlyForecast.conditionCode inSection:0]].accessoryType = UITableViewCellAccessoryNone;
		_hourlyForecast.conditionCode = indexPath.row;
	} else {
		[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_city.conditionCode inSection:0]].accessoryType = UITableViewCellAccessoryNone;
		_city.conditionCode = indexPath.row;
	}
	
	[_city setIsDirty:YES];
	[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end