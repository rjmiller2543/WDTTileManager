//
//  WDTTileManager.h
//  Knockdown
//
//  Created by Robert Miller on 5/14/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTWeatherTile.h"
#import <GoogleMaps/GoogleMaps.h>

@protocol WDTTileManagerDelegate <NSObject>

@optional
-(void)animationProgress:(float)progess;
-(void)animationLoadingProgress:(float)progress;
-(void)tilesDidFinish;

@end

@interface WDTTileManager : NSObject

@property(nonatomic,retain) UIColor *bottomBarBackgroundColor;
@property(nonatomic,retain) UIColor *topBarBackgroundColor;
@property(nonatomic,retain) UIColor *dateLabelTextColor;
@property(nonatomic,retain) UIFont *dateLabelFont;

-(void)animateTiles:(BOOL)animate;
-(void)showFirstFrame:(BOOL)show;
-(void)clearTileCache;
-(void)releaseTiles;

-(instancetype)initWithMap:(GMSMapView*)map appKey:(NSString*)appKey appID:(NSString*)appID delegate:(id)delegate;

@end
