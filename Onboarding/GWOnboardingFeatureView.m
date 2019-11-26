//
//  GWOnboardingFeatureView.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWOnboardingFeatureView

- (id)init {
	if (self = [super init]) {
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		self.imageView = [UIImageView new];
		[self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self addSubview:self.imageView];
		
		if (@available(iOS 13, *)) {
			[self.imageView setTintColor:[UIColor systemBlueColor]];
		} else {
			[self.imageView setTintColor:[UIColor colorWithRed:0.0 green:0.47843 blue:1.0 alpha:1.0]];
		}
		
		[[self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
		[[self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
		[[self.imageView.widthAnchor constraintEqualToConstant:48.0] setActive:YES];
		[[self.imageView.heightAnchor constraintEqualToConstant:48.0] setActive:YES];
		
		
		
		self.textLabel = [UILabel new];
		[self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.textLabel setNumberOfLines:0];
		[self.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
		[self addSubview:self.textLabel];
		
		[[self.textLabel.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
		[[self.textLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:12] setActive:YES];
		[[self.textLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
		
		
		
		self.detailTextLabel = [UILabel new];
		[self.detailTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.detailTextLabel setNumberOfLines:0];
		[self.detailTextLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]];
		[self addSubview:self.detailTextLabel];
		
		[[self.detailTextLabel.topAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor] setActive:YES];
		[[self.detailTextLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
		[[self.detailTextLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:12] setActive:YES];
		[[self.detailTextLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
	}
	
	return self;
}

@end
