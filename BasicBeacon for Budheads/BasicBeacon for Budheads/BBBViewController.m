//
//  BBBViewController.m
//  BasicBeacon for Budheads
//
//  Created by Rich on 1/28/14.
//  Copyright (c) 2014 Bitmachines.net. All rights reserved.
//

#import "BBBViewController.h"

@interface BBBViewController ()

@end

@implementation BBBViewController {
    CLBeaconRegion *radiatingBeacon;
    NSDictionary *radiatingData;
    CBPeripheralManager *peripheralManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"EE09D3FA-7C73-4538-AE2C-58577728E193"];
    _UUIDLabel.text = @"EE09D3FA-7C73-4538-AE2C-58577728E193";
    
    radiatingBeacon = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:2 minor:1 identifier:@"net.bitmachines.beacon.budhead"];
    _statusLabel.text = @"alloc.init";
    
}

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch(peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            _statusLabel.text = @"powered on";
            [peripheral startAdvertising:radiatingData];
            break;
        case CBPeripheralManagerStatePoweredOff:
            _statusLabel.text = @"powered off";
            [peripheral stopAdvertising];
            break;
        case CBPeripheralManagerStateResetting:
            _statusLabel.text= @"resetting";
            break;
        case CBPeripheralManagerStateUnauthorized:
            _statusLabel.text= @"unauthorized";
            break;
        case CBPeripheralManagerStateUnknown:
            _statusLabel.text= @"unknown";
            break;
        case CBPeripheralManagerStateUnsupported:
            _statusLabel.text=@"unsupported";
        default:
            _statusLabel.text=@"state error";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)transmitButton:(id)sender {
    radiatingData = [radiatingBeacon peripheralDataWithMeasuredPower:nil];
    
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}
@end
