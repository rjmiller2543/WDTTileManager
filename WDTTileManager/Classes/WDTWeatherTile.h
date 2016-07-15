//
//  WDTWeatherTile.h
//  Knockdown
//
//  Created by Robert Miller on 5/14/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#define kTileWillBeginDownload  @"Tile Download Will Begin"
#define kTileDidFinishDownload  @"Tile Did Finish Download"

typedef void(^CountIncreaseCallback)(int count);

@interface WDTWeatherTile : GMSTileLayer

@property(nonatomic,retain) NSArray *validFrame;
@property(nonatomic,retain) NSString *frame;
@property(nonatomic,retain) NSString *appKey;
@property(nonatomic,retain) NSString *addID;
@property(nonatomic) CountIncreaseCallback countIncreaseCallback;

-(void)setManager:(id)manager;

@end
