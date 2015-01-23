//
//  iBeaconCreateViewController.h
//  iBeacon
//
//  Created by Rich on 11/14/13.
//  Copyright (c) 2013 Bitmachines. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface iBeaconCreateViewController : UIViewController <CBPeripheralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *createStatus;

@property (weak, atomic) IBOutlet UILabel *uuidLabel;
@property (weak, atomic) IBOutlet UILabel *majorLabel;
@property (weak, atomic) IBOutlet UILabel *minorLabel;
@property (weak, atomic) IBOutlet UILabel *identityLabel;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;


@end
