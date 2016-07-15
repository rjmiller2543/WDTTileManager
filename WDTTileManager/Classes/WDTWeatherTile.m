//
//  WDTWeatherTile.m
//  Knockdown
//
//  Created by Robert Miller on 5/14/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import "WDTWeatherTile.h"
#import "WDTTileImage.h"
#import "WDTTileManager.h"
#import <AFNetworking.h>

typedef void (^WDTCompletionCallback)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface WDTWeatherTile () {
    WDTCompletionCallback wdtCompletionBlock;
}

//@property(nonatomic,retain) NSMutableArray *images;
@property(nonatomic,retain) id wdtmanager;
@property(nonatomic) int tileCount;

@end

@implementation WDTWeatherTile

-(instancetype)init {
    self = [super init];
    if (self) {
        //_images = [[NSMutableArray alloc] init];
        _tileCount = 0;
    }
    return self;
}

-(void)setAddID:(NSString *)addID {
    _addID = addID;
}

-(void)setAppKey:(NSString *)appKey {
    _appKey = appKey;
}

-(void)setManager:(id)manager {
    _wdtmanager = manager;
}

-(void)requestTileForX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom receiver:(id<GMSTileReceiver>)receiver {
    
    if (_countIncreaseCallback != nil) {
        _tileCount++;
        _countIncreaseCallback(_tileCount);
    }
    
    
    AFHTTPRequestSerializer *ser = [[AFHTTPRequestSerializer alloc] init];
    [ser setValue:_addID forHTTPHeaderField:@"app_id"];
    [ser setValue:_appKey forHTTPHeaderField:@"app_key"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DDTHH:MM:SS"];
    NSString *url = [NSString stringWithFormat:@"https://skywisetiles.wdtinc.com/swarmweb/tile/nalowaltradarcontours/%@/%lu/%lu/%lu.gif", _frame, zoom, x, y];
    //NSString *url = [NSString stringWithFormat:@"https://skywisetiles.wdtinc.com/swarmweb/comptile/%lu/%lu/%lu.gif", zoom, x, y];

    
    // Create the GMSTileLayer
    NSMutableURLRequest *request = [ser requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    __weak typeof(self) weakSelf = self;
    wdtCompletionBlock = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithUnsignedInteger:x], [NSNumber numberWithUnsignedInteger:y], [NSNumber numberWithUnsignedInteger:zoom], weakSelf.frame] forKeys:@[@"x", @"y", @"zoom", @"frame"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTileDidFinishDownload object:dict];
            
        });
        if (error) {
            NSLog(@"%@",error);
            [receiver receiveTileWithX:x y:y zoom:zoom image:kGMSTileLayerNoTile];
        }
        else {
            
            UIImage *image = [UIImage imageWithData:data];
            
            [receiver receiveTileWithX:x y:y zoom:zoom image:image];
        }
        
    };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request  completionHandler:wdtCompletionBlock] resume];
    
}

@end
