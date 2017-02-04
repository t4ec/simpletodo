platform :ios, '9.3'
use_frameworks!

target "simpletodotest" do
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'RealmSwift'
    pod 'Eureka'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end