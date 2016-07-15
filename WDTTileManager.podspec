#
# Be sure to run `pod lib lint WDTTileManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WDTTileManager'
  s.version          = '0.1.1'
  s.summary          = 'WDTTileManager is a Google Maps Integration for WDT SWARM and RADAR Tiles.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Manages and animates Radar and SWARM Tiles from WDT.  Also has a customizable view to display the current frame, slide through frames, go to the most current, with an animating play/pause button.  To get a key, contact WDT Directly at wdtinc.com.
                       DESC

  s.homepage         = 'https://github.com/rjmiller2543/WDTTileManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rjmiller2543' => 'robertmiller2543@gmail.com' }
  s.source           = { :git => 'https://github.com/rjmiller2543/WDTTileManager.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MillerTheMaker'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WDTTileManager/Classes/**/*'
 
  ########s.resource_bundles = 'WDTTileManager/Assets/*.{png,xib}'
#  s.resource_bundles = {
#    'WDTTileManager' => ['WDTTileManager/Assets/*.{png,xib}']
    #'WDTTileManager' => ['Pod/WDTTileManager/**/*.xib']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'VBFPopFlatButton'
  s.dependency 'GoogleMaps'
  s.dependency 'AFNetworking'

  s.resources = ['WDTTileManager/Assets/*']
end
