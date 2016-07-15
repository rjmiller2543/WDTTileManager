//
//  WDTViewController.m
//  WDTTileManager
//
//  Created by rjmiller2543 on 07/06/2016.
//  Copyright (c) 2016 rjmiller2543. All rights reserved.
//

#import "WDTViewController.h"
#import <WDTTileManager/WDTTileManager.h>

@interface WDTViewController () <GMSMapViewDelegate, WDTTileManagerDelegate>

@property(nonatomic,retain) WDTTileManager *tileManager;

@end

@implementation WDTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.mapType = kGMSTypeNormal;
    
}

-(void)viewDidLayoutSubviews {
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    _tileManager = [[WDTTileManager alloc] initWithMap:_mapView appKey:@"0c4caf9b3303f0cc98905bcc477dbbbc" appID:@"0a447496" delegate:self];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.8282
                                                            longitude:98.5795
                                                                 zoom:3];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(39.8282, 98.5795);
    marker.title = @"Center of US";
    marker.snippet = @"Yup, Right Here";
    marker.map = _mapView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Google Map Delegate


@end
