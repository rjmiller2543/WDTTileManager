//
//  WDTTileImage.h
//  Knockdown
//
//  Created by Robert Miller on 5/14/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTTileImage : UIImage

@property(nonatomic,assign) NSInteger x;
@property(nonatomic,assign) NSInteger y;
@property(nonatomic,assign) NSInteger zoom;
@property(nonatomic,assign) NSString *frame;

@end
