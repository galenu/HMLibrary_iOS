#
# Be sure to run `pod lib lint HMLibrary_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMLibrary_iOS'
  s.version          = '1.0.0'
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
  s.author           = { 'galen' => 'Qiang.Gui@harman.com' }
  s.source           = { :git => 'ssh://git@bitbucket2.harman.com:7999/hmszap/hm_partylight_library_ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
  # 指定Swift语言版本
  s.swift_version = ['5.0']
  
  s.resource_bundles = {
    'HMLibrary_iOS' => ['HMLibrary_iOS/Assets/*']
  }

  # s.source_files = 'HMLibrary_iOS/Classes/**/*'
  
  # 1级文件夹Core
  s.subspec 'Core' do |s1|
    
    # 2级文件夹Extension
    s1.subspec 'Extension' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Core/Extension/*.swift'
    end
    
    # 2级文件夹Protocol
    s1.subspec 'Protocol' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Core/Protocol/*.swift'
    end
    
    # 2级文件夹Extension
    s1.subspec 'HM+Extension' do |s2|
        # 依赖Extension
        s2.dependency 'HMLibrary_iOS/Core/Extension'
        # 依赖Protocol
        s2.dependency 'HMLibrary_iOS/Core/Protocol'
        s2.source_files = 'HMLibrary_iOS/Classes/Core/HM+Extension/*.swift'
    end
    
    # 2级文件夹Util
    s1.subspec 'Util' do |s2|
      s2.source_files = 'HMLibrary_iOS/Classes/Core/Util/*.swift'
    end
    
  end
  
  # 1级文件夹Component
  s.subspec 'Component' do |s1|
    # 依赖Core
    s1.dependency 'HMLibrary_iOS/Core'
    s1.source_files = 'HMLibrary_iOS/Classes/Component/**/*'
  end
  
  # 1级文件夹EmptyDataSet
  s.subspec 'EmptyDataSet' do |s1|
      # 依赖Core
      s1.dependency 'HMLibrary_iOS/Core'
      s1.source_files = 'HMLibrary_iOS/Classes/EmptyDataSet/**/*'
  end
  
  # 1级文件夹HMCache
  s.subspec 'HMCache' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/HMCache/**/*'
  end
  
  # 1级文件夹HMFont
  s.subspec 'HMFont' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/HMFont/**/*'
  end
  
  # 1级文件夹HMLog
  s.subspec 'HMLog' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/HMLog/**/*'
  end
  
  # 1级文件夹HMNavigation
  s.subspec 'HMNavigation' do |s1|
      # 依赖Core
      s1.dependency 'HMLibrary_iOS/Core'
      s1.source_files = 'HMLibrary_iOS/Classes/HMNavigation/**/*'
  end
  
  # 1级文件夹HMPopup
  s.subspec 'HMPopup' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/HMPopup/**/*'
  end
  
  # 1级文件夹HMRoute
  s.subspec 'HMRoute' do |s1|
      # 依赖HMNavigation
      s1.dependency 'HMLibrary_iOS/HMNavigation'
      s1.source_files = 'HMLibrary_iOS/Classes/HMRoute/**/*'
  end
  
  # 1级文件夹HMTagView
  s.subspec 'HMTagView' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/HMTagView/**/*'
  end
  
  # 1级文件夹HUD
  s.subspec 'HUD' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/HUD/**/*'
  end
  
  # 1级文件夹I18n
  s.subspec 'I18n' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/I18n/**/*'
  end
  
  # 1级文件夹NetworkChange
  s.subspec 'NetworkChange' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/NetworkChange/**/*'
  end
  
  # 1级文件夹Validate
  s.subspec 'Validate' do |s1|
      s1.source_files = 'HMLibrary_iOS/Classes/Validate/**/*'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  
  # 依赖的第三方库
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SnapKit'
  s.dependency 'Alamofire'
  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'URLNavigator'
  s.dependency 'Cache' # 缓存
  
end
