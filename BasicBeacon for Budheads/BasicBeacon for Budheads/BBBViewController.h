//
//  BBBViewController.h
//  BasicBeacon for Budheads
//
//  Created by Rich on 1/28/14.
//  Copyright (c) 2014 Bitmachines.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface BBBViewController : UIViewController <CBPeripheralManagerDelegate>

- (IBAction)transmitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *UUIDLabel;

@end
