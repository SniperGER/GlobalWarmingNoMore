//
//  GWDayForecastEditorViewController.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

@class City, WADayForecast;

@interface GWDayForecastEditorViewController : UITableViewController {
	int userTemperatureUnit;
}

@property (nonatomic, strong) City* city;
@property (nonatomic, strong) WADayForecast* forecast;

@end