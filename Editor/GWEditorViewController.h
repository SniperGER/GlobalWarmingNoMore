//
//  GWEditorViewController.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

@class City, WAWeatherCityView;

@interface GWEditorViewController : UITableViewController {
	int userTemperatureUnit;
}

@property (nonatomic, strong) City* activeCity;
@property (nonatomic, strong) WAWeatherCityView* weatherCityView;

@end