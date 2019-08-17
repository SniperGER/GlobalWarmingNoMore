//
//  GWHourlyForecastEditorViewController.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

@class City, WAHourlyForecast;

@interface GWHourlyForecastEditorViewController : UITableViewController {
	int userTemperatureUnit;
}

@property (nonatomic, strong) City* city;
@property (nonatomic, strong) WAHourlyForecast* forecast;

@end