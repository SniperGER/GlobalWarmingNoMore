//
//  Tweak.h
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include <objc/runtime.h>
#include "WeatherFormatters.h"

#include "Editor/GWDayForecastEditorViewController.h"
#include "Editor/GWEditorTableViewCell.h"
#include "Editor/GWEditorViewController.h"
#include "Editor/GWHourlyForecastEditorViewController.h"
#include "Editor/GWWeatherConditionParser.h"
#include "Editor/GWWeatherConditionPickerController.h"
#include "Onboarding/GWOnboardingFeatureView.h"
#include "Onboarding/GWOnboardingSolidButton.h"
#include "Onboarding/GWOnboardingViewController.h"

NSString* GWLocalizedString(NSString* key);

@class WFTemperature;

@interface Application : UIApplication
@end

@interface CALayer (Private)
- (void)setContinuousCorners:(BOOL)arg1;
@end

@interface City : NSObject
@property (nonatomic, strong, readwrite) NSNumber* airQualityCategory;
@property (nonatomic, strong, readwrite) NSNumber* airQualityIdx;
@property (nonatomic, assign, readwrite) NSInteger conditionCode;
@property (nonatomic, strong, readwrite) WFTemperature* feelsLike;
@property (nonatomic, assign, readwrite) float humidity;
@property (nonatomic, assign, readwrite) float pressure;
@property (nonatomic, assign, readwrite) NSUInteger sunriseTime;
@property (nonatomic, assign, readwrite) NSUInteger sunsetTime;
@property (nonatomic, strong, readwrite) WFTemperature* temperature;
@property (nonatomic, assign, readwrite, setter=setUVIndex:) NSUInteger uvIndex;
@property (nonatomic, assign, readwrite) float visibility;
@property (nonatomic, assign, readwrite) float windDirection;
@property (nonatomic, assign, readwrite) float windSpeed;
// %property
@property (nonatomic, assign) BOOL isDirty;

- (NSArray*)dayForecasts;
- (NSArray*)hourlyForecasts;
- (NSString*)name;
- (void)setUpdateTime:(NSDate*)arg1;
@end

@interface WAContainerViewController : UIViewController
- (City*)activeCity;
@end

@interface WADayForecast : NSObject
@property (nonatomic, strong, readwrite) WFTemperature* high;
@property (nonatomic, assign, readwrite) NSUInteger icon;
@property (nonatomic, strong, readwrite) WFTemperature* low;

- (NSUInteger)dayNumber;
- (NSUInteger)dayOfWeek;
@end

@interface WAHourlyForecast : NSObject
@property (nonatomic, assign, readwrite) NSUInteger conditionCode;
@property (nonatomic, assign, readwrite) float percentPrecipitation;
@property (nonatomic, strong, readwrite) WFTemperature* temperature;

- (id)time;
@end

@interface WAPageCollectionViewController : UIViewController
- (City*)activeCity;
- (void)scrollViewDidEndDecelerating:(id)arg1;
- (void)updateBackground;
- (void)updateAndDisplayActiveCity;
- (void)updateExtendedWeatherOnVisibleCells;
@end

@interface WAWeatherCityView : UIView
// %property
@property (nonatomic, strong) UINavigationController* editorNavigationController;
// %property
@property (nonatomic, strong) GWEditorViewController* editorViewController;

- (void)updateUI;
- (UILongPressGestureRecognizer*)longPressGestureRecognizer;

// %new
- (UIViewController*)presentingViewController;
@end

@interface WeatherImageLoader : NSObject
+ (id)conditionImageWithConditionIndex:(int)arg1;
@end

@interface WeatherPreferences : NSObject
+ (instancetype)sharedPreferences;
- (int)userTemperatureUnit;
@end

@interface WFTemperature : NSObject
- (void)_resetTemperatureValues;
- (void)_setValue:(CGFloat)arg1 forUnit:(int)arg2;
- (CGFloat)temperatureForUnit:(int)arg1;
@end