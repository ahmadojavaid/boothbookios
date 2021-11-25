# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BoothBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'IQKeyboardManagerSwift', '5.0.0' #'4.0.7'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  
  #pod 'SwiftMessages'
  pod 'NVActivityIndicatorView'
  #pod 'KMPlaceholderTextView'
  #pod 'SkeletonView'
  #pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
  pod 'SignaturePad'
  pod 'ChromaColorPicker'
  pod 'RLBAlertsPickers'
  pod 'SVProgressHUD'
  pod 'ActionSheetPicker-3.0'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
  end

  # Pods for BoothBook

  target 'BoothBookTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BoothBookUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
