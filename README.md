# WDTTileManager

[![CI Status](http://img.shields.io/travis/rjmiller2543/WDTTileManager.svg?style=flat)](https://travis-ci.org/rjmiller2543/WDTTileManager)
[![Version](https://img.shields.io/cocoapods/v/WDTTileManager.svg?style=flat)](http://cocoapods.org/pods/WDTTileManager)
[![License](https://img.shields.io/cocoapods/l/WDTTileManager.svg?style=flat)](http://cocoapods.org/pods/WDTTileManager)
[![Platform](https://img.shields.io/cocoapods/p/WDTTileManager.svg?style=flat)](http://cocoapods.org/pods/WDTTileManager)

## Example

![Demo](https://raw.github.com/rjmiller2543/WDTTileManager/WDT_POD_GIF.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use, declare a Google Map using either an IBOutlet, or frames
    
	@property(nonatomic,retain) GMSMapView *mapView;

or
    
	@property(nonatomic,retain) IBOutlet GMSMapView *mapView;

then connect the Outlet in your Storyboard or XIB
and declare the tile manager

	@property(nonatomic,retain) WDTTileManager *tileManager;

If not using an outlet, instantiate your map
    
	_mapView = [[GMSMapView alloc] initWithFrame:frame];

Create the tile manager

    	_tileManager = [[WDTTileManager alloc] initWithMap:_mapView appKey:kWDTAppKey appID:kWDTAppID delegate:self];

To Customize the view and animation Speed

	[_tileManager setTopBarBackgroundColor:[UIColor darkGrayColor]];
    	[_tileManager setBottomBarBackgroundColor:[UIColor darkGrayColor]];
    	[_tileManager setTintColor:[UIColor grayColor]];
    	[_tileManager setAnimationTime:0.3];

## Requirements

All of the necessary frameworks are included in the Podspec, but you will need to get an App Key and App Id from WDT, and you’ll need to setup your GoogleMaps key to work with your Bundle Identifier.  To get your Bundle Identifier, I’ve included an NSLog that outputs in the example, that you can copy/paste, or just go to your General Project Settings and copy/paste the reverse com Bundle Identifier

## Installation

WDTTileManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WDTTileManager"
```

## Author

rjmiller2543, robertmiller2543@gmail.com

## License

WDTTileManager is available under the MIT license. See the LICENSE file for more info.
