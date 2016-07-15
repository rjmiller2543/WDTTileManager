//
//  RadarControllerView.m
//  Knockdown
//
//  Created by Robert Miller on 7/5/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import "RadarControllerView.h"
#import "NSDate+DateParts.h"

@interface RadarControllerView ()

@property(nonatomic,retain) UIColor *bottomBarBackgroundColor;
@property(nonatomic,retain) UIColor *topBarBackgroundColor;
@property(nonatomic,retain) UIColor *dateLabelTextColor;
@property(nonatomic,retain) UIFont *dateLabelFont;
@property(nonatomic,retain) UIColor *shadowColor;
@property(nonatomic,retain) UIColor *tintColor;



@property(nonatomic) BOOL animating;

@end

@implementation RadarControllerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setupView {
    
    _animating = false;
    
    _touchableView.backgroundColor = [UIColor clearColor];
    
    _topView.backgroundColor = [UIColor blackColor];
    _topView.layer.cornerRadius = _topLabel.bounds.size.height / 2;
    
    _bottomBar.backgroundColor = [UIColor blackColor];
    _slider.tintColor = [UIColor whiteColor];
    _leftView.backgroundColor = [UIColor blackColor];
    _rightView.backgroundColor = [UIColor blackColor];
    _topLabel.text = @"Loading..";
    
    UIBezierPath *leftShadow = [UIBezierPath bezierPathWithRect:_leftView.bounds];
    _leftView.layer.masksToBounds = NO;
    _leftView.layer.shadowColor = [UIColor whiteColor].CGColor;
    _leftView.layer.shadowOffset = CGSizeMake(5.0f, 0.0f);
    _leftView.layer.shadowOpacity = 0.3f;
    _leftView.layer.shadowPath = leftShadow.CGPath;
    
    UIBezierPath *rightShadow = [UIBezierPath bezierPathWithRect:_rightView.bounds];
    _rightView.layer.masksToBounds = NO;
    _rightView.layer.shadowColor = [UIColor whiteColor].CGColor;
    _rightView.layer.shadowOffset = CGSizeMake(-5.0f, 0.0f);
    _rightView.layer.shadowOpacity = 0.3f;
    _rightView.layer.shadowPath = rightShadow.CGPath;
    
    [self setupButtons];
    
}

-(void)setupButtons {
    
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    CGRect buttonRect = CGRectMake(8, 8, (rect.size.width * 0.15) - 16, (rect.size.width * 0.15) - 16);
    
    _playButton = [[VBFPopFlatButton alloc] initWithFrame:buttonRect buttonType:buttonRightTriangleType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    [_playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton animateToType:buttonRightTriangleType];
    [_playButton setTitle:@"" forState:UIControlStateNormal];
    [_leftView addSubview:_playButton];
    
    [_nowButton addTarget:self action:@selector(nowButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_nowButton setTitle:@"NOW" forState:UIControlStateNormal];
    [_nowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void)setBottomBarBackgroundColor:(UIColor *)bottomBarBackgroundColor {
    
    _bottomBarBackgroundColor = bottomBarBackgroundColor;
    
    _bottomBar.backgroundColor = bottomBarBackgroundColor;
    _leftView.backgroundColor = bottomBarBackgroundColor;
    _rightView.backgroundColor = bottomBarBackgroundColor;
    
}

-(void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor {
    
    _topBarBackgroundColor = topBarBackgroundColor;
    
    _topView.backgroundColor = topBarBackgroundColor;
    
}

-(void)setDateLabelTextColor:(UIColor *)dateLabelTextColor {
    
    _dateLabelTextColor = dateLabelTextColor;
    
    _topLabel.textColor = dateLabelTextColor;
    
}

-(void)setDateLabelFont:(UIFont *)dateLabelFont {
    
    _dateLabelFont = dateLabelFont;
    
    _topLabel.font = dateLabelFont;
    
}

-(void)setShadowColor:(UIColor *)shadowColor {
    
    _shadowColor = shadowColor;
    
    UIBezierPath *leftShadow = [UIBezierPath bezierPathWithRect:_leftView.bounds];
    _leftView.layer.masksToBounds = NO;
    _leftView.layer.shadowColor = shadowColor.CGColor;
    _leftView.layer.shadowOffset = CGSizeMake(5.0f, 0.0f);
    _leftView.layer.shadowOpacity = 0.3f;
    _leftView.layer.shadowPath = leftShadow.CGPath;
    
    UIBezierPath *rightShadow = [UIBezierPath bezierPathWithRect:_rightView.bounds];
    _rightView.layer.masksToBounds = NO;
    _rightView.layer.shadowColor = shadowColor.CGColor;
    _rightView.layer.shadowOffset = CGSizeMake(-5.0f, 0.0f);
    _rightView.layer.shadowOpacity = 0.3f;
    _rightView.layer.shadowPath = rightShadow.CGPath;
    
}

-(void)setTintColor:(UIColor *)tintColor {
    
    _tintColor = tintColor;
    
    _slider.tintColor = tintColor;
    
    _playButton.tintColor = tintColor;
    
}

-(void)playButtonPressed:(id)sender {
    
    //Flip the animating bool
    _animating = !_animating;
    
    //Set the local state
    NSInteger state = _animating ? kPaused : kAnimating;
    
    //Get the button to animate to the state
    [_playButton animateToType:state];
    
    //Let the delegate know we've changed state
    [self.delegate radarControllerPlayButtonPressedToState:state];
    
}

-(void)nowButtonPressed {
    
    if (_animating) {
        [_playButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.delegate radarControllerNowButtonPressed];
    
}

-(void)sliderChanged:(id)sender {
    
    UISlider *slider = (UISlider*)sender;
    
    _slider.value = (NSInteger)slider.value;
    
    [self.delegate radarControllerSliderValueChanged:_slider.value];
    
}

-(void)setSliderFrames:(NSInteger)sliderFrames {
    
    _slider.minimumValue = 0;
    _slider.maximumValue = sliderFrames - 1;
    
}

-(void)updateViewWithTime:(NSString *)time andFrame:(NSInteger)frame {
    
    NSDate *date = [NSDate formattedDateWithDateString:time withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    _topLabel.text = [NSString stringWithFormat:@"%ld:%@%@",(long)date.intHour, date.minuteString, date.ampm];
    
    [_slider setValue:frame animated:YES];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == _touchableView) {
        return nil;
    }
    
    return view;
    
}

@end
