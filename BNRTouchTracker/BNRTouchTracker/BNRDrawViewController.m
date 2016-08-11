//
//  BNRDrawViewController.m
//  BNRTouchTracker
//
//  Created by YangJialin on 8/11/16.
//  Copyright © 2016 YangJialin. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@implementation BNRDrawViewController


- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
