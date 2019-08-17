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
	if (self.activeCity.isDirty) return;
	
	%orig;
}

- (BOOL)needsLoadingWeatherCondition {
	if (self.activeCity.isDirty) return NO;
	
	return %orig;
}

- (void)setNeedsLoadingWeatherCondition:(BOOL)arg1 {
	if (self.activeCity.isDirty) return;
	
	%orig;
}

- (void)reloadData {
	if (self.activeCity.isDirty) return;
	
	%orig;
}
%end	// %hook WAPageCollectionViewController

%hook WAContainerViewController
- (void)_startUpdateTimer {
	if (self.activeCity.isDirty) return;
	
	%orig;
}

- (void)_updateLocalWeather {
	if (self.activeCity.isDirty) return;
	
	%orig;
}

- (void)cityDidUpdateWeather:(City*)arg1 {
	if (arg1.isDirty) return;
	
	%orig;
}

- (void)reloadCities {
	if (self.activeCity.isDirty) return;
	
	%orig;
}
- (void)reloadCitiesFromPrefs {
	if (self.activeCity.isDirty) return;
	
	%orig;
}

- (void)reloadLocalCity {
	if (self.activeCity.isDirty) return;
	
	%orig;
}

- (void)updateAllCities {
	if (self.activeCity.isDirty) return;
	
	%orig;
}
%end	// %hook WAContainerViewController



%hook City
%property (nonatomic, assign) BOOL isDirty;

- (BOOL)autoUpdate {
	if (self.isDirty) return NO;
	return %orig;
}

- (BOOL)update {
	if (self.isDirty) return NO;
	return %orig;
}

- (NSInteger)updateInterval {
	if (self.isDirty) return -1;
	return %orig;
}

- (id)updateTime {
	if (self.isDirty) return [NSDate date];
	return %orig;
}
%end	// %hook City



%hook TWCCityUpdater
- (void)updateWeatherForCity:(City*)arg1 {
	if (arg1.isDirty) return;
	%orig;
}
%end	// %hook TWCCityUpdater

%hook TWCLocationUpdater
- (void)updateWeatherForCity:(City*)arg1 {
	if (arg1.isDirty) return;
	%orig;
}

- (void)updateWeatherForLocation:(id)arg1 city:(City*)arg2 {
	if (arg2.isDirty) return;
	%orig;
}

- (void)updateWeatherForLocation:(id)arg1 city:(City*)arg2 isFromFrameworkClient:(BOOL)arg3 withCompletionHandler:(/*block*/id)arg4 {
	if (arg2.isDirty) return;
	%orig;
}
%end	// %hook TWCLocationUpdater