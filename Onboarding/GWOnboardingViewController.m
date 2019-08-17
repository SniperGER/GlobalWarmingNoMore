//
//  GWOnboardingViewController.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWOnboardingViewController

- (void)viewDidLoad {
	[self.view setBackgroundColor:UIColor.whiteColor];
	NSBundle* gwBundle = [NSBundle bundleWithPath:@"/Library/Application Support/GlobalWarmingNoMore"];
	
	GWOnboardingSolidButton* getStartedButton = [GWOnboardingSolidButton new];
	[getStartedButton setTitle:GWLocalizedString(@"ONBOARDING_GET_STARTED") forState:UIControlStateNormal];
	[getStartedButton addTarget:self action:@selector(getStartedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:getStartedButton];
	
	[[getStartedButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-12.0] setActive:YES];
    [[getStartedButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:12.0] setActive:YES];
    [[getStartedButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12.0] setActive:YES];
    [[getStartedButton.heightAnchor constraintEqualToConstant:50.0] setActive:YES];
	
	
	
	UIScrollView* scrollView = [UIScrollView new];
	[scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setPreservesSuperviewLayoutMargins:YES];

    [self.view addSubview:scrollView];

	[[scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    [[scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:12.0] setActive:YES];
    [[scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12.0] setActive:YES];
	[[scrollView.bottomAnchor constraintEqualToAnchor:getStartedButton.topAnchor constant:-16.0] setActive:YES];
	
	
	
	UIImageView* appIcon = [[UIImageView alloc] init];
	[appIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
	[appIcon.layer setCornerRadius:15];
	[appIcon.layer setContinuousCorners:YES];
	[appIcon setClipsToBounds:YES];
	UIImage* appIconImage = [UIImage imageNamed:NSBundle.mainBundle.infoDictionary[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"][0]];
	[appIcon setImage:appIconImage];
	
	[scrollView addSubview:appIcon];
	
	[[appIcon.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:44] setActive:YES];
    [[appIcon.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor] setActive:YES];
	[[appIcon.heightAnchor constraintEqualToConstant:60.0] setActive:YES];
	[[appIcon.heightAnchor constraintEqualToConstant:60.0] setActive:YES];
	


	UILabel* titleLabel = [UILabel new];
	[titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[titleLabel setNumberOfLines:0];
	[titleLabel setFont:[UIFont systemFontOfSize:30 weight:UIFontWeightHeavy]];
	[titleLabel setText:[NSString stringWithFormat:GWLocalizedString(@"ONBOARDING_TITLE"), GWLocalizedString(@"ONBOARDING_NAME")]];
	
	NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
	[attributedString addAttributes:@{
		NSForegroundColorAttributeName: [UIColor colorWithRed:0.0901961 green:0.835294 blue:0.992571 alpha:1.0],
	} range:[titleLabel.text rangeOfString:GWLocalizedString(@"ONBOARDING_NAME")]];
	[titleLabel setAttributedText:attributedString];
	
	[scrollView addSubview:titleLabel];
	
	[[titleLabel.topAnchor constraintEqualToAnchor:appIcon.bottomAnchor constant:24.0] setActive:YES];
	[[titleLabel.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor] setActive:YES];
    [[titleLabel.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor] setActive:YES];
	
	
	
	GWOnboardingFeatureView* feature1 = [GWOnboardingFeatureView new];
	[feature1.textLabel setText:GWLocalizedString(@"ONBOARDING_FEATURE_1_TITLE")];
	[feature1.detailTextLabel setText:GWLocalizedString(@"ONBOARDING_FEATURE_1_DESCRIPTION")];
	[feature1.imageView setImage:[[UIImage imageNamed:@"mostly-sunny-white_Normal" inBundle:gwBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[scrollView addSubview:feature1];
	
	[[feature1.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:24.0] setActive:YES];
	[[feature1.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor] setActive:YES];
    [[feature1.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor] setActive:YES];
	[[feature1.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor] setActive:YES];
	[[feature1.heightAnchor constraintEqualToConstant:56.0] setActive:YES];
	
	
	
	GWOnboardingFeatureView* feature2 = [GWOnboardingFeatureView new];
	[feature2.textLabel setText:GWLocalizedString(@"ONBOARDING_FEATURE_2_TITLE")];
	[feature2.detailTextLabel setText:GWLocalizedString(@"ONBOARDING_FEATURE_2_DESCRIPTION")];
	[feature2.imageView setImage:[[UIImage imageNamed:@"rain_day-white_Normal" inBundle:gwBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[scrollView addSubview:feature2];
	
	[[feature2.topAnchor constraintEqualToAnchor:feature1.bottomAnchor constant:24.0] setActive:YES];
	[[feature2.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor] setActive:YES];
    [[feature2.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor] setActive:YES];
	[[feature2.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor] setActive:YES];
	[[feature2.heightAnchor constraintEqualToConstant:56.0] setActive:YES];
	
	
	
	GWOnboardingFeatureView* feature3 = [GWOnboardingFeatureView new];
	[feature3.textLabel setText:GWLocalizedString(@"ONBOARDING_OPEN_SOURCE_TITLE")];
	[feature3.detailTextLabel setText:GWLocalizedString(@"ONBOARDING_OPEN_SOURCE_DESCRIPTION")];
	[feature3.imageView setImage:[[UIImage imageNamed:@"github" inBundle:gwBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[scrollView addSubview:feature3];
	
	[[feature3.topAnchor constraintEqualToAnchor:feature2.bottomAnchor constant:24.0] setActive:YES];
	[[feature3.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor] setActive:YES];
    [[feature3.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor] setActive:YES];
	[[feature3.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor] setActive:YES];
	[[feature3.heightAnchor constraintEqualToConstant:56.0] setActive:YES];
}

- (void)getStartedButtonTapped:(UIButton*)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:@YES forKey:@"GWDidCompleteOnboarding"];
}

@end