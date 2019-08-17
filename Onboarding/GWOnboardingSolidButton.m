//
//  GWOnboardingSolidButton.m
//  GlobalWarmingNoMore
//
//  Created by Janik Schmidt on 15.08.19.
//  Copyright © 2019 Team FESTIVAL. All rights reserved
//

#include "Tweak.h"

@implementation GWOnboardingSolidButton

- (id)init {
	if (self = [super init]) {
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.47843 blue:1.0 alpha:1.0]];
		[self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
		[self.titleLabel setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]];
		[self.layer setCornerRadius:8.0];
	}
	
	return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
	
	[self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:highlighted ? 0.2 : 1.0]];
}

@end