//
//  GWEditorTableViewCell.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include <UIKit/UIKit.h>

@class City;

typedef enum {
	ConditionTypeAirQualityCategory,
	ConditionTypeAirQualityIndex,
	ConditionTypeConditionCode,
	ConditionTypeFeelsLike,
	ConditionTypeHumidity,
	// ConditionTypeIsDay,
	ConditionTypePrecipitationPast24Hours,
	ConditionTypePressure,
	ConditionTypeSunriseTime,
	ConditionTypeSunsetTime,
	ConditionTypeTemperature,
	ConditionTypeUVIndex,
	ConditionTypeVisibility,
	ConditionTypeWindDirection,
	ConditionTypeWindSpeed
} ConditionType;

@interface UITableViewCell (Private)
- (UITableView*)_tableView;
@end

@interface GWEditorTableViewCell : UITableViewCell {
	id _detail;
}

@property (nonatomic, strong) City* city;
@property (nonatomic, assign) ConditionType conditionType;

@end