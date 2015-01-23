//
//  BBFViewController.m
//  Basic Beacon Finder for Budheads
//
//  Created by Rich on 1/28/14.
//  Copyright (c) 2014 Bitmachines.net. All rights reserved.
//

#import "BBFViewController.h"

@interface BBFViewController ()

@end

@implementation BBFViewController {
    CLLocationManager *locationManager;
    CLBeaconRegion *beaconRegion;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"EE09D3FA-7C73-4538-AE2C-58577728E193"];
    
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"net.bitmachines"];
    beaconRegion.notifyEntryStateOnDisplay=YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    
    [locationManager startMonitoringForRegion:beaconRegion];
    _monitorStatus.text = @"monitoring";
    [locationManager requestStateForRegion:beaconRegion];
    _monitorLog.text = @"requestStateForRegion";
    
    // Kind of a hack, sometimes you won't get an entry if you are already in the region,
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    _rangingStatus.text = @"ranging beacons";
    _rangingLog.text = @"";


}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    _monitorStatus.text = [NSString stringWithFormat:@"Determined %@", region.identifier];
    switch (state) {
        case CLRegionStateUnknown:
            _monitorLog.text = @"State Unknown";
            break;
        case CLRegionStateOutside:
            [self locationManager:manager didExitRegion:region];
            _monitorLog.text = @"State Outside";
            break;
        case CLRegionStateInside:
            [self locationManager:manager didEnterRegion:region];
            _monitorLog.text = @"State Inside";
            break;
        default:
            _monitorLog.text = @"Unexpected state";
    }
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    _monitorStatus.text = @"Enter region";
    _monitorLog.text = region.identifier;
    [manager startRangingBeaconsInRegion:beaconRegion];
    _rangingStatus.text = @"start ranging";
    _rangingLog.text = @"";
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    _monitorStatus.text = @"exit region";
    _monitorLog.text = region.identifier;
    // Because we don't reliably get entry, we need to leave ranging on all the time
    // [manager stopRangingBeaconsInRegion:beaconRegion];
    _rangingStatus.text = @"stop ranging";
    _rangingLog.text = @"";
}



- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    _rangingStatus.text = [NSString stringWithFormat:@"%lu beacon(s) found",[beacons count]];
    
    NSString *beaconText = @"";
    
    for (CLBeacon *beacon in beacons) {
        NSLog(@"%@\n", beacon);
        beaconText = [beaconText stringByAppendingFormat:@"(%@, %@) r=%ld p=%ld a= %f", beacon.major, beacon.minor, (long)beacon.rssi, beacon.proximity, beacon.accuracy];
        
        // Hack when this happens we've probably left the region but the exit region may fail
        if (beacon.accuracy == CLProximityUnknown)
            [locationManager requestStateForRegion:beaconRegion];
        
    }
    _rangingLog.text = beaconText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
