//
//  iBeaconTrackViewController.h
//  iBeacon
//
//  Created by Rich on 11/14/13.
//  Copyright (c) 2013 Bitmachines. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// Need to figure out if Bluetooth is on
#import <CoreBluetooth/CoreBluetooth.h>



@interface iBeaconTrackViewController : UIViewController <UIAlertViewDelegate,CLLocationManagerDelegate, CBCentralManagerDelegate>




@property (weak, nonatomic) IBOutlet UILabel *monitorStatus;
@property (weak, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@property (weak, nonatomic) IBOutlet UILabel *rangingStatus;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

- (IBAction)close;

@end
