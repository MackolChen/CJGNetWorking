#
# Be sure to run `pod lib lint CJGNetWorking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CJGNetWorking'
  s.version          = '1.0.0'
  s.summary          = '给予AFN封装网络请求，支持缓存、断点下载、取消任务'
  s.homepage         = 'https://github.com/MackolChen/CJGNetWorking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MackolChen' => 'engineer_macchen@163.com' }
  s.source           = { :git => 'https://github.com/MackolChen/CJGNetWorking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CJGNetWorking/Classes/**/*'
  s.dependency'AFNetworking'


  # s.resource_bundles = {
  #   'CJGNetWorking' => ['CJGNetWorking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
