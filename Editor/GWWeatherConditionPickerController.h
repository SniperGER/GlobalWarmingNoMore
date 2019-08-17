//
//  GWWeatherConditionPickerController.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include <UIKit/UIKit.h>

@class City, WADayForecast, WAHourlyForecast;

@interface GWWeatherConditionPickerController : UITableViewController
@property (nonatomic, strong) City* city;
@property (nonatomic, strong) WADayForecast* dayForecast;
@property (nonatomic, strong) WAHourlyForecast* hourlyForecast;
@end