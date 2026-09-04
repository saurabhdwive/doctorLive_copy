source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '15.6'
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

target 'DoctorLive' do
  use_frameworks! :linkage => :static
  
  # Pods for DoctorLive
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON'
  pod 'KYDrawerController'
  pod 'ADCountryPicker'
  pod 'DropDown'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'

  pod 'SDWebImage', '~> 5.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod "PromiseKit", "~> 6.8"
  pod 'RSSelectionMenu'
  pod 'Socket.IO-Client-Swift', '~> 15.0.0'
  pod 'AWSS3'
  pod 'AWSCognito'
  pod 'Mobilisten'
  pod 'PIPKit'
  pod 'SideMenu'
  pod 'AgoraRtcEngine_iOS'
  pod 'lottie-ios'
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|

          # Increase 'DeploymentTarget' version if it's less than 12
          if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].split('.').first.to_i < 17
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
          end
        end
      end
    end
  end
end
