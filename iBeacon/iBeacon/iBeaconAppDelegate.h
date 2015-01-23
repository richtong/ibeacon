//
//  iBeaconAppDelegate.h
//  iBeacon
//
//  Created by Rich on 11/14/13.
//  Copyright (c) 2013 Bitmachines. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface iBeaconAppDelegate : UIResponder <UIApplicationDelegate>
{
    CMMotionManager *motionManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
