#
# Be sure to run `pod lib lint CGADKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CGADKit'
  s.version          = '1.0.0'
  s.summary          = 'CGADKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
传广聚合广告SDK
                       DESC

  s.homepage         = 'https://github.com/YuanMingyang/CGADKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yuanmingyang' => '302603448@qq.com' }
  s.source           = { :git => 'https://github.com/YuanMingyang/CGADKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CGADKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CGADKit' => ['CGADKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.static_framework = true
   s.dependency 'Ads-CN'
   s.dependency 'GDTMobSDK'
end
