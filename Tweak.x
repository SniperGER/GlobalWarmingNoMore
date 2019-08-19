//
//  Tweak.x
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

NSString* GWLocalizedString(NSString* key) {
	NSBundle* gwBundle = [NSBundle bundleWithPath:@"/Library/Application Support/GlobalWarmingNoMore"];
	return [gwBundle localizedStringForKey:key value:key table:@"Localizable"];
}

%hook Application
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if (![defaults objectForKey:@"GWDidCompleteOnboarding"]) {
		[self.keyWindow.rootViewController presentViewController:[GWOnboardingViewController new] animated:YES completion:nil];
	}
}
%end	// %hook Application



%hook WAWeatherCityView
%property (nonatomic, strong) UINavigationController* editorNavigationController;
%property (nonatomic, strong) GWEditorViewController* editorViewController;
%property (nonatomic, strong) UILongPressGestureRecognizer* editorLongPressGestureRecognizer;

- (id)initWithFrame:(CGRect)arg1 {
	id r = %orig;
	
	self.editorViewController = [[GWEditorViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.editorViewController setWeatherCityView:self];
	
	self.editorNavigationController = [[UINavigationController alloc] initWithRootViewController:self.editorViewController];
	[self.editorNavigationController.navigationBar setPrefersLargeTitles:YES];
	
	return r;
}

- (void)layoutSubviews {
	%orig;
	
	[self.longPressGestureRecognizer setMinimumPressDuration:0.5];
}

- (void)longPressedOnCity:(id)arg1 {
	if ([self.presentingViewController isKindOfClass:%c(WAPageCollectionViewController)] && ![self.editorNavigationController isBeingPresented]) {
		[self.editorViewController setActiveCity:[(WAPageCollectionViewController*)self.presentingViewController activeCity]];
		[self.presentingViewController presentViewController:self.editorNavigationController animated:YES completion:nil];
	} else {
		%orig;
	}
}

%new
- (UIViewController*)presentingViewController {
	UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
	
	return (UIViewController*)responder;
}
%end	// %hook WAWeatherCityView

%hook WAPageCollectionViewController
- (void)didUpdateWeather {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}

- (BOOL)needsLoadingWeatherCondition {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return NO;
	
	return %orig;
}

- (void)setNeedsLoadingWeatherCondition:(BOOL)arg1 {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}

- (void)reloadData {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}
%end	// %hook WAPageCollectionViewController

%hook WAContainerViewController
- (void)_startUpdateTimer {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}

- (void)_updateLocalWeather {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}

- (void)cityDidUpdateWeather:(City*)arg1 {
	if (arg1.isDirty || arg1.overrideValues != nil) return;
	
	%orig;
}

- (void)reloadCities {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}
- (void)reloadCitiesFromPrefs {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}

- (void)reloadLocalCity {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}

- (void)updateAllCities {
	if (self.activeCity.isDirty || self.activeCity.overrideValues != nil) return;
	
	%orig;
}
%end	// %hook WAContainerViewController



%hook City
%property (nonatomic, assign) BOOL isDirty;
%property (nonatomic, strong) NSMutableDictionary* overrideValues;

- (NSArray*)dayForecasts {
	if (self.overrideValues && self.overrideValues[@"dayForecasts"]) return self.overrideValues[@"dayForecasts"];
	return %orig;
}
- (WFTemperature*)feelsLike {
	if (self.overrideValues && self.overrideValues[@"feelsLike"]) return self.overrideValues[@"feelsLike"];
	return %orig;
}
- (NSArray*)hourlyForecasts {
	if (self.overrideValues && self.overrideValues[@"hourlyForecasts"]) return self.overrideValues[@"hourlyForecasts"];
	return %orig;
}
- (WFTemperature*)temperature {
	if (self.overrideValues && self.overrideValues[@"temperature"]) return self.overrideValues[@"temperature"];
	return %orig;
}
- (id)objectForKey:(id)key {
	if (self.overrideValues && self.overrideValues[key]) return self.overrideValues[key];
	return %orig;
}



- (BOOL)autoUpdate {
	if (self.isDirty || self.overrideValues != nil) return NO;
	return %orig;
}

- (BOOL)update {
	if (self.isDirty || self.overrideValues != nil) return NO;
	return %orig;
}

- (NSInteger)updateInterval {
	if (self.isDirty || self.overrideValues != nil) return -1;
	return %orig;
}

- (id)updateTime {
	if (self.isDirty || self.overrideValues != nil) return [NSDate date];
	return %orig;
}
%end	// %hook City

%hook WADayForecast
%property (nonatomic, strong) NSMutableDictionary* overrideValues;

- (WFTemperature*)high {
	if (self.overrideValues && self.overrideValues[@"high"]) return self.overrideValues[@"high"];
	return %orig;
}

- (WFTemperature*)low {
	if (self.overrideValues && self.overrideValues[@"low"]) return self.overrideValues[@"low"];
	return %orig;
}
%end	// %hook WADayForecast

%hook WAHourlyForecast
%property (nonatomic, strong) NSMutableDictionary* overrideValues;

- (WFTemperature*)temperature {
	if (self.overrideValues && self.overrideValues[@"temperature"]) return self.overrideValues[@"temperature"];
	return %orig;
}
%end	// %hook WADayForecast



%hook TWCCityUpdater
- (void)updateWeatherForCity:(City*)arg1 {
	if (arg1.isDirty || arg1.overrideValues != nil) return;
	%orig;
}
%end	// %hook TWCCityUpdater

%hook TWCLocationUpdater
- (void)updateWeatherForCity:(City*)arg1 {
	if (arg1.isDirty || arg1.overrideValues != nil) return;
	%orig;
}

- (void)updateWeatherForLocation:(id)arg1 city:(City*)arg2 {
	if (arg2.isDirty || arg2.overrideValues != nil) return;
	%orig;
}

- (void)updateWeatherForLocation:(id)arg1 city:(City*)arg2 isFromFrameworkClient:(BOOL)arg3 withCompletionHandler:(/*block*/id)arg4 {
	if (arg2.isDirty || arg2.overrideValues != nil) return;
	%orig;
}
%end	// %hook TWCLocationUpdater