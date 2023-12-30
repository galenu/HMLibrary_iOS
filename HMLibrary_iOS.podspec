#
# Be sure to run `pod lib lint HMLibrary_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMLibrary_iOS'
  s.version          = '0.0.7'
  s.summary          = 'iOS开发基础组件库HMLibrary_iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  iOS开发基础组件库HMLibrary_iOS.
                       DESC

  s.homepage         = 'https://github.com/galenu/HMLibrary_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'galenu' => '250167616@qq.com' }
  s.source           = { :git => 'https://github.com/galenu/HMLibrary_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
  # 指定Swift语言版本
  s.swift_version = ['5.0']

  # s.source_files = 'HMLibrary_iOS/Classes/**/*'
  
  # 1级文件夹Core
  s.subspec 'Core' do |ss|
    
    # 2级文件夹Extension
    ss.subspec 'Extension' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Core/Extension/**/*'
    end
    
    # 2级文件夹Protocol
    ss.subspec 'Protocol' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Core/Protocol/**/*'
    end
    
    # 2级文件夹Util
    ss.subspec 'Util' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Core/Util/**/*'
    end
    
  end
  
  # 1级文件夹Component
  s.subspec 'Component' do |ss|
    
    # 依赖Core
    ss.dependency 'HMLibrary_iOS/Core'
    
    ss.source_files = 'HMLibrary_iOS/Classes/Component/*.swift'
    
    # 2级文件夹HMNavigation
    ss.subspec 'HMNavigation' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Component/HMNavigation/**/*'
    end
    
    # 2级文件夹HMPopup
    ss.subspec 'HMPopup' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Component/HMPopup/**/*'
    end
    
    # 2级文件夹NetworkChange
    ss.subspec 'NetworkChange' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Component/NetworkChange/**/*'
    end
    
  end
  
  # 1级文件夹HMFont
  s.subspec 'HMFont' do |s1|
    s1.source_files = 'HMLibrary_iOS/Classes/HMFont/**/*'
  end
  
  # 1级文件夹HMLog
  s.subspec 'HMLog' do |s1|
    s1.source_files = 'HMLibrary_iOS/Classes/HMLog/**/*'
  end
  
  # 1级文件夹I18n
  s.subspec 'I18n' do |s1|
    s1.source_files = 'HMLibrary_iOS/Classes/I18n/**/*'
  end
  
  # 1级文件夹Route
  s.subspec 'Route' do |s1|
    s1.source_files = 'HMLibrary_iOS/Classes/Route/**/*'
  end
  
   s.resource_bundles = {
     'HMLibrary_iOS' => ['HMLibrary_iOS/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  
  # 依赖的第三方库
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SnapKit'
  s.dependency 'Alamofire'
  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'URLNavigator'
  
end
