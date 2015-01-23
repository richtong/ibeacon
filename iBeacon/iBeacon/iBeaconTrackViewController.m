//
//  iBeaconTrackViewController.m
//  iBeacon
//
//  Created by Rich on 11/14/13.
//  Copyright (c) 2013 Bitmachines. All rights reserved.
//

#import "iBeaconTrackViewController.h"

@interface iBeaconTrackViewController ()

@end

@implementation iBeaconTrackViewController {
    CLLocationManager *locationManager;
    CLBeaconRegion *beaconRegion;
    CBCentralManager *centralManager;
    NSUUID *uuid;
    CLRegionState beaconState;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"iBeacon"
                              message:@"This device cannot monitor iBeacons"
                              delegate:self
                              cancelButtonTitle:@"Return"
                              otherButtonTitles:nil];
        [alert show];
        // Control returns to the delegate alertView:clickButtonAtIndex: below
        return;
    }

    
    // This handles the case where Bluetooth isn't on, so we first need to turn it on.
    // The next thing is a call back to centralManagerDidUpdateState
    centralManager = [[CBCentralManager alloc]
                            initWithDelegate:self
                            queue:nil
                            options:@{CBCentralManagerOptionShowPowerAlertKey : @YES}];
    
    _monitorStatus.text = @"Initializing";
    NSLog(@"Initial Bluetooth state is %ld", centralManager.state);
    
    
}

// After error, this method is called, we don't do anything special with it right now.
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    

}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    UIAlertView *alert;

    switch (central.state) {
        case CBCentralManagerStateUnknown:
            _monitorStatus.text = @"Unknown State";
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            self.monitorStatus.text = @"Momentary Reset";
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            alert = [[UIAlertView alloc] initWithTitle:@"iBeacon"
                                               message:@"No Bluetooth LE on this device"
                                              delegate:self
                                     cancelButtonTitle:@"Return"
                                     otherButtonTitles: nil];
            [alert show];
            // this ends up popping when the button is pressed via the alertView:clickedButtonAtIndex:
            break;
        case CBCentralManagerStateUnauthorized:
            alert = [[UIAlertView alloc] initWithTitle:@"iBeacon"
                                               message:@"Unauthorized change in settings"
                                              delegate:self
                                     cancelButtonTitle:@"Return"
                                     otherButtonTitles: nil];
            [alert show];
            // this ends up popping when the button is pressed via the alertView:clickedButtonAtIndex:
            break;
            
        case CBCentralManagerStatePoweredOff:
            alert = [[UIAlertView alloc] initWithTitle:@"iBeacon"
                                               message:@"Bluetooth powered off"
                                              delegate:self
                                     cancelButtonTitle:@"Return"
                                     otherButtonTitles:@"Change", nil];
            [alert show];
            // this ends up popping when the button is pressed via the alertView:clickedButtonAtIndex:
            break;
        
        case CBCentralManagerStatePoweredOn:
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            
            
            if (![CLLocationManager isRangingAvailable]) {
                
                UIAlertView *alert = [[UIAlertView init]
                                      initWithTitle:@"iBeacon"
                                      message:@"Hardware cannot range iBeacons"
                                      delegate:self
                                      cancelButtonTitle:@"return"
                                      otherButtonTitles: nil];
                [alert show];
                break;
            }

           
            
            // Per http://stackoverflow.com/questions/19246493/locationmanagerdidenterregion-not-called-when-a-beacon-is-detected
            uuid = [[NSUUID alloc] initWithUUIDString:@"EE09D3FA-7C73-4538-AE2C-58577728E193"];
            beaconRegion = [[CLBeaconRegion alloc]
                            initWithProximityUUID:uuid
                            identifier:@"net.bitmachines.test.sony.x900a"];
            
            if (beaconRegion.notifyOnEntry != YES) {
                
                NSLog(@"something turned off notify entry %d", beaconRegion.notifyOnEntry);
                beaconRegion.notifyOnEntry = YES;

            }
            
            if (beaconRegion.notifyOnExit != YES) {
                NSLog(@"someone turned off notify on exit %d", beaconRegion.notifyOnExit);
                beaconRegion.notifyOnExit = YES;
            }
            // Handles the case where we are already inside the region when we start
            beaconRegion.notifyEntryStateOnDisplay = YES; // default is no

    
            // Region events are delivered to the locationManager:didEnterRegion: and locationManager:didExitRegion: methods of your delegate. If there is an error, the location manager calls the locationManager:monitoringDidFailForRegion:withError: method of your delegate instead.
            [locationManager startMonitoringForRegion:beaconRegion];
            _monitorStatus.text = @"Monitor Region";
            _proximityUUIDLabel.text = [uuid UUIDString];
            
            // Simultaneously start ranging as the entryRegion is not reliable. But ranging seems to always work
            
            [locationManager startRangingBeaconsInRegion:beaconRegion];
            
            _rangingStatus.text = @"Ranging...";
            
            break;
        default:
            _monitorStatus.text = @"Unexpected";
            NSLog(@"CBCentralManager %@ unexpected state %ld", central, central.state);
            
    }
}

// The monitorRegion returns to these three methods locationManager:monitoringDirFailForRegion, didStartMonitoringRegion, didDetermineState
- (void) locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"iBeacon"
                          message:@"Monitor Failed"
                          delegate:self cancelButtonTitle:@"Return"
                          otherButtonTitles: nil];
    NSLog(@"monitoringDidFailRegion %@", error);
    _monitorStatus.text = @"Monitor Failed";
    [alert show];
}

// We shouldn't really need this call
// But sometimes, CLLocationManager:the didEnterRegion is not being called
// So instead start polling
- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [locationManager requestStateForRegion:region];
}

// The above method then will call this function and force the inside region message
- (void) locationManager:(CLLocationManager *)manager
       didDetermineState:(CLRegionState)state
               forRegion:(CLRegion *)region {
    
    beaconState = state;
    NSLog(@"did determine state %ld", state);
    switch (state) {
        case CLRegionStateInside:
            _monitorStatus.text = @"Inside";
            break;
        case CLRegionStateOutside:
            _monitorStatus.text = @"Outside";
            break;
        case CLRegionStateUnknown:
            _monitorStatus.text = @"Unknown";
            break;
        default:
            _monitorStatus.text = @"Unexpected";
    }


}

//
// General error, documented as when locations can't be found
//
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"iBeacon"
                          message:@"General CLLocationManager failure"
                          delegate:self cancelButtonTitle:@"Return"
                          otherButtonTitles: nil];
    NSLog(@"didFailWithError: %@", error);
    [alert show];
    _monitorStatus.text = @"CLLocation Error";

}

// This should call corretly, the documentation isn't correct. This does *not* get called
// at start. So you can be ranging and never get a didEnterRegion
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    beaconState = CLRegionStateInside;
    _monitorStatus.text = @"Enter Region";
    NSLog(@"found region %@", region.identifier);
    
    
}


// This also does not get called realiably. So you can stop ranging (this happens by getting an accuracy unknown
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    beaconState = CLRegionStateOutside;
    _monitorStatus.text = @"Exit Region";
    NSLog(@"%@", @"exiting region");
    
}


// Separate from entry and exit is the ranging call. The first time you get a range is by default
// A synthetic entry, so we call the didEnterREgion method and when you get accuracy unknown, that is a
// de facto didExitRegion. Also we can get a range with zero beacons?! which is the entry detection so we need guard against this and probably call didEnterREgion
- (void) locationManager:(CLLocationManager *)manager
         didRangeBeacons:(NSArray *)beacons
                inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon;
    NSInteger count = [beacons count];
    
    if (count <1) {
        NSLog(@"Unusual beacon count");
        // This can happen and we never get out of it.
    }
    NSLog(@"Beacons found %ld", (long)count);
    
    _rangingStatus.text = (count <= 1)? @"A Beacon" :
                                        [NSString stringWithFormat:@"%ld Beacons", (long)count];

    
    NSString * major = @"";
    NSString * minor = @"";
    NSString * rssi = @"";
    NSString * accuracy = @"";
    NSString * proximity = @"";
    NSString * proximityText = @"";
    
    for (beacon in beacons) {

        major = [major stringByAppendingFormat:@"%@ ", beacon.major];
        minor = [minor stringByAppendingFormat:@"%@ ", beacon.minor];
        rssi = [rssi stringByAppendingFormat:@"%ld ", (long)beacon.rssi];
        
        accuracy = [accuracy stringByAppendingFormat:@"%f", beacon.accuracy];
    
        switch (beacon.proximity)
        {
           
            case CLProximityImmediate:
                if (beaconState != CLRegionStateInside)
                    [self locationManager:locationManager didEnterRegion:beaconRegion];
                proximityText = @"Immediate";
                break;
            case CLProximityNear:
                if (beaconState != CLRegionStateInside)
                    [self locationManager:locationManager didEnterRegion:beaconRegion];
                proximityText = @"Near";
                break;
            case CLProximityFar:
                if (beaconState != CLRegionStateInside)
                    [self locationManager:locationManager didEnterRegion:beaconRegion];
                proximityText = @"@Far";
                break;
            case CLProximityUnknown:
                proximityText = @"@Unknown";
                if (beaconState != CLRegionStateOutside)
                    [self locationManager:locationManager didExitRegion:beaconRegion];
                break;
            default:
                proximityText = @"Unexpected";

        }
        proximity = [proximity stringByAppendingString:proximityText];
    }
    _majorLabel.text = major;
    _minorLabel.text = minor;
    _rssiLabel.text = rssi;
    _accuracyLabel.text = accuracy;
    _proximityLabel.text = proximity;

}

-(void) locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView init]
                          initWithTitle:@"iBeacon"
                          message:@"Hardware cannot range iBeacons"
                          delegate:self
                          cancelButtonTitle:@"return"
                          otherButtonTitles: nil];
    [alert show];
    [locationManager stopMonitoringForRegion:beaconRegion];
    return;

}


- (IBAction)close
{
    [locationManager stopMonitoringForRegion:beaconRegion];
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
