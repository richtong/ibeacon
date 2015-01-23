//
//  BBFViewController.h
//  Basic Beacon Finder for Budheads
//
//  Created by Rich on 1/28/14.
//  Copyright (c) 2014 Bitmachines.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BBFViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *monitorStatus;
@property (weak, nonatomic) IBOutlet UILabel *monitorLog;

@property (weak, nonatomic) IBOutlet UILabel *rangingLog;
@property (weak, nonatomic) IBOutlet UILabel *rangingStatus;

@end
