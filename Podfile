platform :ios, '9.3'
use_frameworks!

target "simpletodotest" do
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'RealmSwift'
    pod 'Eureka', '~> 2.0.0-beta.1'
    pod 'MGSwipeTableCell'
    pod 'Hue'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end