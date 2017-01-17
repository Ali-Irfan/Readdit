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
    pod 'StringExtensionHTML'
    pod 'EZLoadingActivity'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
