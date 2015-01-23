//
//  iBeaconCreateViewController.m
//  iBeacon
//
//  Created by Rich on 11/14/13.
//  Copyright (c) 2013 Bitmachines. All rights reserved.
//

#import "iBeaconCreateViewController.h"

@interface iBeaconCreateViewController ()

@end

@implementation iBeaconCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"EE09D3FA-7C73-4538-AE2C-58577728E193"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                            major:5
                                                            minor:1
                                                       identifier:@"net.bitmachines"];
    
    _uuidLabel.text = _beaconRegion.proximityUUID.UUIDString;
    _majorLabel.text = [NSString stringWithFormat:@"%@", _beaconRegion.major];
    _minorLabel.text = [NSString stringWithFormat:@"%@", _beaconRegion.minor];
    _identityLabel.text = _beaconRegion.identifier;

}

- (IBAction) createBeacon: (UIButton *) sender
{
    _beaconPeripheralData = [_beaconRegion peripheralDataWithMeasuredPower:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];

}

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{

    switch(peripheral.state ) {
        case CBPeripheralManagerStatePoweredOn:
            _createStatus.text= @"Powered on";
            [peripheral startAdvertising:_beaconPeripheralData];
            break;
        case CBPeripheralManagerStatePoweredOff:
            _createStatus.text = @"powered off";
            [peripheral stopAdvertising];
            break;
        case CBPeripheralManagerStateResetting:
            _createStatus.text= @"resetting";
            break;
        case CBPeripheralManagerStateUnauthorized:
            _createStatus.text= @"unauthorized";
            break;
        case CBPeripheralManagerStateUnknown:
            _createStatus.text= @"unknown";
            break;
        case CBPeripheralManagerStateUnsupported:
            _createStatus.text=@"unsupported";
        default:
            _createStatus.text=@"state error";
    }
}


- (IBAction)close
{
    [_peripheralManager stopAdvertising];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
