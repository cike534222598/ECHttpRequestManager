#
# Be sure to run `pod lib lint ECHttpRequestManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ECHttpRequestManager'
  s.version          = '1.1.2'
  s.summary          = 'ECHttpRequestManager是基于AFNetwork3.x开发的Http请求Manager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    ECHttpRequestManager是基于AFNetwork3.x开发的Http请求Manager,包括get、post请求,文件upload、download,网络监测等功能。
                       DESC

  s.homepage         = 'https://github.com/cike534222598/ECHttpRequestManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jame' => 'cike534222598@qq.com' }
  s.source           = { :git => 'https://github.com/cike534222598/ECHttpRequestManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ECHttpRequestManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ECHttpRequestManager' => ['ECHttpRequestManager/Assets/*.png']
  # }

  s.dependency "AFNetworking", "~> 3.1.0"
  s.dependency "YYCache", "~> 1.0.3"
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
