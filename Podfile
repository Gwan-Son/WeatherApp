# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'my-weather' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end

  # Pods for my-weather

  target 'my-weatherTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'my-weatherUITests' do
    # Pods for testing
  end

end
