platform :ios, '15.0'

use_frameworks!
use_modular_headers!

target 'PureBite' do
  pod "SwiftLint"
  pod "SwinjectAutoregistration"
  pod "DBDebugToolkit", :modular_headers => true
  pod "Firebase/DynamicLinks"
  pod "Firebase/Messaging"
  pod "Firebase/Crashlytics"
  pod "Firebase/RemoteConfig"
  pod "SnapKit"
  pod "SwiftGen"
  pod "SwiftUIIntrospect"
  pod "KeychainAccess"
  pod 'CombineCocoa'

end

# Set zero Pods optimization level in Debug configurations
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
    end
    target.build_configurations.each do |config|
      if config.name.include?("Debug")
        config.build_settings["GCC_OPTIMIZATION_LEVEL"] = "0"

        # Add DEBUG to custom configurations containing 'Debug'
        config.build_settings["GCC_PREPROCESSOR_DEFINITIONS"] ||= ["$(inherited)"]
        if !config.build_settings["GCC_PREPROCESSOR_DEFINITIONS"].include? "DEBUG=1"
          config.build_settings["GCC_PREPROCESSOR_DEFINITIONS"] << "DEBUG=1"
        end

        config.build_settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Onone"

        config.build_settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = ["DEBUG"]
      end

      if config.name.include?("Release")
        config.build_settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = ["RELEASE"]
      end
    end
  end
end
