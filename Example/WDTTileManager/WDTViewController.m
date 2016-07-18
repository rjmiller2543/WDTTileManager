//
//  WDTViewController.m
//  WDTTileManager
//
//  Created by rjmiller2543 on 07/06/2016.
//  Copyright (c) 2016 rjmiller2543. All rights reserved.
//

#import "WDTViewController.h"
#import <WDTTileManager/WDTTileManager.h>

#warning REPLACE THE KEY AND ID WITH YOUR KEY AND ID
#define kWDTAppKey   @"0c4caf9b3303f0cc98905bcc477dbbbc"
#define kWDTAppID    @"0a447496"

@interface WDTViewController () <GMSMapViewDelegate, WDTTileManagerDelegate>

@property(nonatomic,retain) WDTTileManager *tileManager;
@property(nonatomic) NSInteger zoomLevel;

@end

@implementation WDTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.mapType = kGMSTypeNormal;
    
    NSLog(@"Current identifier: %@", [[NSBundle mainBundle] bundleIdentifier]);
    
}

-(void)viewDidLayoutSubviews {
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    _tileManager = [[WDTTileManager alloc] initWithMap:_mapView appKey:kWDTAppKey appID:kWDTAppID delegate:self];
    [_tileManager setTopBarBackgroundColor:[UIColor darkGrayColor]];
    [_tileManager setBottomBarBackgroundColor:[UIColor darkGrayColor]];
    [_tileManager setTintColor:[UIColor grayColor]];
    [_tileManager setAnimationTime:0.3];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.8282
                                                            longitude:-98.5795
                                                                 zoom:3];
    _zoomLevel = 3;
    _mapView.myLocationEnabled = YES;
    [_mapView setCamera:camera];
    
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
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    if (position.zoom >= 20 && _zoomLevel < 20) {
        [_tileManager setTileSize:128];
    }
    else if (position.zoom >= 18 && _zoomLevel < 18) {
        _zoomLevel = position.zoom;
        [_tileManager setTileSize:256];
    }
    else if (position.zoom >= 16 && _zoomLevel < 16) {
        _zoomLevel = position.zoom;
        [_tileManager setTileSize:512];
    }
    else if (_zoomLevel >= 16) {
        _zoomLevel = position.zoom;
        [_tileManager setTileSize:1024];
    }
    else
        _zoomLevel = position.zoom;
}

@end
