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


/* 
 *  Declaration for the Delegate for the Tile Manager.  The Delegate is optional and is used
 *  if showing a progress of downloads for the tiles, the animation progress, and a callback
 *  for when the tiles finish downloading, is necessary or desired.
 */
@protocol WDTTileManagerDelegate <NSObject>

@optional

/* 
 -(void)animationProgress:(float)progress
 
 Optional Delegate Method Callback if you need to know the progress of the animation frames.  Returned is a float between 0 and 1
 */
-(void)animationProgress:(float)progess;

/*
 -(void)animationLoadingProgress:(float)progress
 
 Optional Delegate Method Callback if you need to know the progress of the downloads from the tiles from WDT
 */
-(void)animationLoadingProgress:(float)progress;

/*
 -(void)tilesDidFinish
 
 Optional Delegate Method Callback if you need to know when all tiles have completed their download
 */
 -(void)tilesDidFinish;

@end


/*
 *  The WDT Tile Manager is used to display Weather Radar as a tile overlay for Google Maps
 *  iOS SDK.  The Tile Manager includes a customizable view to be able to show the radar, animate the radar,
 *  select a place in time, and go directly to the most current radar frame.  In addition, the Time of the currently 
 *  shown frame is also displayed.  To use, just call the instancetype included to init with a map and app keys.
 */
@interface WDTTileManager : NSObject

/*  For customization of the included View to control the radar, you have some color options, as well as the option to the
 *  font of the text on the top bar.  You can change the text color for the top bar's label that displays the time of the
 *  frame, the background color of the top bar, bottom bar, and the shadow for the left and right buttons, as well as the
 *  tint color of the bottom bar, which changes the color of the animating lines on the play/pause button, as well as the
 *  tint color of the progress bar.
 */
@property(nonatomic,retain) UIColor *bottomBarBackgroundColor;
@property(nonatomic,retain) UIColor *topBarBackgroundColor;
@property(nonatomic,retain) UIColor *dateLabelTextColor;
@property(nonatomic,retain) UIFont *dateLabelFont;
@property(nonatomic,retain) UIColor *shadowColor;
@property(nonatomic,retain) UIColor *tintColor;

/*  For customization of the tile layer, you have the option to change the opacity of the tile layer, to make the ground layer more or less visible, the tile size returned from WDT, which will effect the pixel density of the radar, and the animation time to speed up or slow down the animation
 */
@property(nonatomic) float opacity; /* Default is 0.8, 1.0 is completely opaque, 0.0 is completely invisible */

@property(nonatomic) float tileSize;    /* Default is 1024 to increase download speed and lower bandwidth, lower number increases the size of the returned images.  Too low of a number may cause low memory warnings and crashes */

@property(nonatomic) float animationTime;   /* Default is 0.5seconds.  Counted in Seconds, the animation time is the delay time between two frames, a higher number will slow the animation, and a lower number will speed up the animation. */


/* Public methods */

/*
 *  -(void)animateTiles:(BOOL)animate
 *  
 *  The left button with play/pause will handle the start/stop of animation, however you can also handle animation play/pause
 *  in code
 */
-(void)animateTiles:(BOOL)animate;

/*
 *  -(void)showFirstFrame:(BOOL)show
 *  
 *  This method call can take the place of the right button for "NOW" and takes you to the most current radar frame
 */
-(void)showFirstFrame:(BOOL)show;

/*
 *  -(void)clearTileCache
 *
 *  clears all of the tile cache, if the map is still attached, the radar will reload immediately.  Can be called if
 *  a reload of data is necessary
 */
-(void)clearTileCache;

/*
 *  -(void)releaseTiles
 *
 *  Clears all of the tile cache, disconnects the tiles from map, and release all tiles from memory.  Should be called
 *  just before setting the tile manager to nil to ensure that all tiles and images are cleared from cache and memory
 */
-(void)releaseTiles;

/*
 *  -(void)hideControlView:(BOOL)hidden
 *
 *  If you have your own View for controlling the radar animations, or just want to show the most current radar without
 *  animation, whatever makes your heart content, you have the freedom and ability to just trash and hide the view that
 *  was made and included to control the radar
 */
-(void)hideControlView:(BOOL)hidden;

/*
 *  -(instancetype)initWithMap:(GMSMapView*)map appKey:(NSString*)appKey appID:(NSString*)appID delegate:(id)delegate
 *
 *  This instancetype is necessary, in order to ensure that the tiles have a map to show, and to be able to make calls to WDT
 *  using the appKey and appID are necessary, though the delegate is not necessary
 */
-(instancetype)initWithMap:(GMSMapView*)map appKey:(NSString*)appKey appID:(NSString*)appID delegate:(id)delegate;

@end
