//
//  WDTTileManager.m
//  Knockdown
//
//  Created by Robert Miller on 5/14/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import "WDTTileManager.h"
#import <AFNetworking.h>
#import "RadarControllerView.h"

typedef void (^ValidFrameCallback)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface WDTTileManager () <RadarControllerViewDelegate>
{
    ValidFrameCallback validFramesCallback;
}

@property(nonatomic,assign) id <WDTTileManagerDelegate> delegate;
@property(nonatomic,strong) NSArray<NSString*> *validTimeFrames;
@property(nonatomic,strong) NSMutableArray<WDTWeatherTile*> *tileLayers;
@property(nonatomic,weak) GMSMapView *map;

@property(nonatomic,retain) NSTimer *animationTimer;
@property(nonatomic) NSInteger animationFrame;
@property(nonatomic) NSInteger tileCount;
@property(nonatomic) NSInteger maxTiles;
@property(nonatomic) BOOL isLoadingFrames;
@property(nonatomic) BOOL isAnimating;
@property(nonatomic,retain) WDTWeatherTile *currentAnimateTile;
@property(nonatomic,retain) NSString *appKey;
@property(nonatomic,retain) NSString *appID;

@property(nonatomic,retain) RadarControllerView *radarView;
@end

#define kTileShow   0.8f
#define kTileHide   0.0f

@implementation WDTTileManager

-(instancetype)initWithMap:(GMSMapView*)map appKey:(NSString*)appKey appID:(NSString*)appID delegate:(id)delegate {
    self = [super init];
    
    if (self) {
        
        self.map = map;
        
        self.delegate = delegate;
        
        _validTimeFrames = [[NSMutableArray alloc] init];
        
        _tileLayers = [[NSMutableArray alloc] init];
        
        _tileCount = 0;
        _isAnimating = false;
        
        //Set with Default Opacity
        _opacity = kTileShow;
        
        //Set with Default Tile Size
        _tileSize = 1024;
        
        _isLoadingFrames = YES;
        _appKey = appKey;
        _appID = appID;
        [self addRadarController];
        [self getValidWdtFramesWithAppKey:appKey appID:appID];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(increaseTileCount:) name:kTileWillBeginDownload object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decreaseTileCount:) name:kTileDidFinishDownload object:nil];
        
    }
    
    return self;
}

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass {
    
    if (nibName && objClass) {
        NSBundle *bundle = [NSBundle bundleForClass:objClass];
        NSArray *objects = [bundle loadNibNamed:nibName
                                                         owner:self
                                                       options:nil];
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:objClass])
                return currentObject;
        }
    }
    
    return nil;
    
}

-(void)addRadarController {
    
    _radarView = [WDTTileManager loadNibNamed:@"RadarViewController" ofClass:[RadarControllerView class]];
    
    _radarView.delegate = self;
    _radarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_map addSubview:_radarView];
    
    [_map addConstraint:[NSLayoutConstraint constraintWithItem:_radarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_map attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [_map addConstraint:[NSLayoutConstraint constraintWithItem:_radarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_map attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [_map addConstraint:[NSLayoutConstraint constraintWithItem:_radarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_map attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    
    [_map addConstraint:[NSLayoutConstraint constraintWithItem:_radarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_map attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    
    [_map addConstraint:[NSLayoutConstraint constraintWithItem:_radarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_map attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [_map addConstraint:[NSLayoutConstraint constraintWithItem:_radarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_map attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [_map layoutIfNeeded];
    [_map setNeedsLayout];
    [_radarView layoutIfNeeded];
    [_radarView setNeedsLayout];
    [_radarView setupView];
    
}

-(void)getValidWdtFramesWithAppKey:(NSString*)appKey appID:(NSString*)appID {
    
    //https://skywisetiles.wdtinc.com/swarmweb/valid_frames?product=globalirgrid
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:@"nalowaltradarcontours" forKey:@"product"];
    
    AFHTTPRequestSerializer *ser = [[AFHTTPRequestSerializer alloc] init];
    [ser setValue:appID forHTTPHeaderField:@"app_id"];
    [ser setValue:appKey forHTTPHeaderField:@"app_key"];
    
    NSString *URLString = @"https://skywisetiles.wdtinc.com/swarmweb/valid_frames";
    NSMutableURLRequest *request = [ser requestWithMethod:@"GET" URLString:URLString parameters:jsonDict error:nil];
    
    __weak typeof(self) weakSelf = self;
    validFramesCallback = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"%@",error);
            
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getTilesWithData:data];
            });
            
        }
    };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request  completionHandler:validFramesCallback] resume];
    
}

-(void)getTilesWithData:(NSData *)data {
    
    NSString *validFramesString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *temparray = [validFramesString componentsSeparatedByString:@","];
    [self setValidTimeFrames:temparray];
    
    [self loadCurrentTile];
    
    [_radarView setSliderFrames:_validTimeFrames.count];
    
}

-(void)clearTileCache {
    
    for (WDTWeatherTile *tileLayer in _tileLayers) {
        [tileLayer clearTileCache];
    }
    
}

-(void)releaseTiles {
    [self clearTileCache];
    for (WDTWeatherTile *tileLayer in _tileLayers) {
        tileLayer.map = nil;
    }
    [_tileLayers removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTileWillBeginDownload object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTileDidFinishDownload object:nil];
}

-(void)increaseTileCount:(NSNotification *)notification {
    _tileCount++;
    if (_tileCount > _maxTiles)
        _maxTiles = _tileCount;
    
}

-(void)decreaseTileCount:(NSNotification *)notification {
    
    _tileCount--;
    if ([self.delegate respondsToSelector:@selector(animationLoadingProgress:)]) {
        [self.delegate animationLoadingProgress:(((float)_maxTiles - (float)_tileCount) / (float)_maxTiles)];
    }
    
    NSLog(@"finished download frame: %@", [[notification object] description]);
    if (_tileCount == 0) {
        [self tileFramesDidFinish];
    }
    
}

-(void)tileLayerDidFinishDownload:(NSString *)frame {
    
    if (_isLoadingFrames) {
        if ([self.delegate respondsToSelector:@selector(animationLoadingProgress:)]) {
            [self.delegate animationLoadingProgress:((float)_animationFrame / (float)_validTimeFrames.count)];
        }
        _animationFrame++;
        if (_animationFrame >= _validTimeFrames.count) {
            [self tileFramesDidFinish];
            return;
        }
        [self getAllValidTiles];
    }
}

-(void)tileFramesDidFinish {
    
    _animationFrame = 0;
    if ([self.delegate respondsToSelector:@selector(tilesDidFinish)]) {
        [self.delegate tilesDidFinish];
    }
    
}

-(void)loadCurrentTile {
    
    WDTWeatherTile *tile = [[WDTWeatherTile alloc] init];
    
    tile.frame = [_validTimeFrames lastObject];
    
    tile.tileSize = _tileSize;
    tile.map = _map;
    tile.opacity = _opacity;
    
    [tile setAppKey:_appKey];
    [tile setAddID:_appID];
    
    tile.countIncreaseCallback = ^(int count){
        _tileCount = count;
    };
    
    //[_tileLayers addObject:tile];
    
    _currentAnimateTile = tile;
    
    [self getAllValidTiles];
    
    [_radarView updateViewWithTime:[_validTimeFrames lastObject] andFrame:_validTimeFrames.count - 1];
    
}

-(void)getAllValidTiles {
    
    _maxTiles = _tileCount * _validTimeFrames.count;
    BOOL firstTile = true;
    for (NSString *thisFrame in _validTimeFrames) {
        
        WDTWeatherTile *tile = [[WDTWeatherTile alloc] init];
        
        tile.frame = thisFrame;
        
        tile.tileSize = _tileSize;
        tile.map = _map;
        
        tile.opacity = kTileHide;
        
        [_tileLayers addObject:tile];
        
    }
    
}

-(void)animateTile {
    
    if (_animationFrame >= _validTimeFrames.count) {
        _animationFrame = 0;
        [_tileLayers lastObject].opacity = kTileHide;
    }
    else if (_animationFrame == 0) {
        [_tileLayers lastObject].opacity = kTileHide;
    }
    else
        [_tileLayers objectAtIndex:_animationFrame-1].opacity = kTileHide;
    
    [_tileLayers objectAtIndex:_animationFrame].opacity = _opacity;
    
    _currentAnimateTile = [_tileLayers objectAtIndex:_animationFrame];
    
    if ([self.delegate respondsToSelector:@selector(animationProgress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate animationProgress:(float)_animationFrame / (float)_tileLayers.count];
        });
    }
    
    [_radarView updateViewWithTime:[_validTimeFrames objectAtIndex:_animationFrame] andFrame:_animationFrame];
    
    _animationFrame++;
    
}

-(void)startAnimation {
    _isLoadingFrames = YES;
    
    _animationFrame = 0;
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animateTile) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopAnimation {
    
    _isAnimating = false;
    [_animationTimer invalidate];
    
}

-(void)animateTiles:(BOOL)animate {
    animate ? [self startAnimation] : [self stopAnimation];
}

-(void)showFirstFrame:(BOOL)show {
    
    _currentAnimateTile.opacity = kTileHide;
    [_tileLayers lastObject].opacity = show ? _opacity : kTileHide;
    
    [_radarView updateViewWithTime:[_validTimeFrames lastObject] andFrame:[_validTimeFrames count] - 1];
    
}

-(void)showFrame:(NSInteger)frame {
    
    _currentAnimateTile.opacity = kTileHide;
    
    _currentAnimateTile = [_tileLayers objectAtIndex:frame];
    
    _currentAnimateTile.opacity = _opacity;
    
    [_radarView updateViewWithTime:[_validTimeFrames objectAtIndex:frame] andFrame:frame];
    
}

#pragma mark - Setters
-(void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    
    [_radarView setShadowColor:shadowColor];
}

-(void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    [_radarView setTintColor:tintColor];
}

-(void)setDateLabelFont:(UIFont *)dateLabelFont {
    _dateLabelFont = dateLabelFont;
    
    [_radarView dateLabelFont];
}

-(void)setDateLabelTextColor:(UIColor *)dateLabelTextColor {
    _dateLabelTextColor = dateLabelTextColor;
    
    [_radarView setDateLabelTextColor:dateLabelTextColor];
}

-(void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor {
    _topBarBackgroundColor = topBarBackgroundColor;
    
    [_radarView setTopBarBackgroundColor:topBarBackgroundColor];
}

-(void)setBottomBarBackgroundColor:(UIColor *)bottomBarBackgroundColor {
    _bottomBarBackgroundColor = bottomBarBackgroundColor;
    
    [_radarView setBottomBarBackgroundColor:bottomBarBackgroundColor];
}
-(void)setTileSize:(float)tileSize {
    
    _tileSize = tileSize;
    for (WDTWeatherTile *thisTile in _tileLayers) {
        thisTile.map = NULL;
        thisTile.tileSize = tileSize;
        thisTile.map = _map;
    }
    
}

-(void)setOpacity:(float)opacity {
    
    _opacity = opacity;
    _currentAnimateTile.opacity = opacity;
    
}


#pragma mark - Radar Controller Delegate Methods
-(void)radarControllerNowButtonPressed {
    
    [self showFirstFrame:YES];
    
}

-(void)radarControllerSliderValueChanged:(NSInteger)value {
    
    [self showFrame:value];
    
}

-(void)radarControllerPlayButtonPressedToState:(NSInteger)state {
    
    if (state == kPaused) {
        [self startAnimation];
    }
    else
        [self stopAnimation];
    
}

@end
