platform :ios, '9.0'
use_frameworks!

target 'Readdit' do
    pod 'SwiftyJSON'
    pod 'Dollar'
    pod 'SlideMenuControllerSwift'
    pod "AsyncSwift"
    pod 'ReachabilitySwift', '~> 3'
    pod 'Alamofire', '~> 4.0'
    pod 'Alamofire-Synchronous', '~> 4.0'
    pod 'Zip', '~> 0.6'
    pod 'PMAlertController'
    pod 'XLActionController'
  pod 'XLActionController/Skype'
  #pod 'XLActionController/Spotify'
  #pod 'XLActionController/Tweetbot'
  #pod 'XLActionController/Twitter'
  pod 'XLActionController/Youtube'
    pod 'StringExtensionHTML'
    pod 'SwiftGifOrigin', '~> 1.6.1'
pod 'SDWebImage/WebP'
pod 'SDWebImage/GIF’


pod 'BonMot'

pod 'FontAwesomeKit’, :git => 'https://github.com/PrideChung/FontAwesomeKit.git'
pod 'ActionSheetPicker-3.0'

    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
