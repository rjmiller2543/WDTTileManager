//
//  RadarControllerView.h
//  Knockdown
//
//  Created by Robert Miller on 7/5/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VBFPopFlatButton.h>

@protocol RadarControllerViewDelegate <NSObject>

@required
-(void)radarControllerPlayButtonPressedToState:(NSInteger)state;
-(void)radarControllerSliderValueChanged:(NSInteger)value;
-(void)radarControllerNowButtonPressed;

@optional

@end

#define kAnimating  buttonRightTriangleType
#define kPaused     buttonPausedType

@interface RadarControllerView : UIView

// Interface Outlets
@property(nonatomic,retain) IBOutlet UIView *touchableView;
@property(nonatomic,retain) IBOutlet UIView *bottomBar;
@property(nonatomic,retain) IBOutlet UISlider *slider;
@property(nonatomic,retain) IBOutlet UIView *leftView;
@property(nonatomic,retain) IBOutlet UIView *rightView;
@property(nonatomic,retain) IBOutlet UIView *topView;
@property(nonatomic,retain) IBOutlet UILabel *topLabel;
@property(nonatomic,retain) VBFPopFlatButton *playButton;
@property(nonatomic,retain) IBOutlet UIButton *nowButton;

// View Parameters
@property(nonatomic,retain) UIColor *bottomBarBackgroundColor;
@property(nonatomic,retain) UIColor *topBarBackgroundColor;
@property(nonatomic,retain) UIColor *dateLabelTextColor;
@property(nonatomic,retain) UIFont *dateLabelFont;
@property(nonatomic,retain) UIColor *shadowColor;
@property(nonatomic,retain) UIColor *tintColor;

// Interface Methods
-(IBAction)sliderChanged:(id)sender;

@property(nonatomic,assign) id <RadarControllerViewDelegate> delegate;

@property(nonatomic) NSInteger sliderFrames;

//Allows the Tile Manager to se the time
-(void)updateViewWithTime:(NSString*)time andFrame:(NSInteger)frame;

-(void)setupView;

@end
