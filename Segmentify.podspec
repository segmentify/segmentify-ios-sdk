#
#  Be sure to run `pod spec lint Segmentify.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Segmentify"
  s.version      = "1.3.5"
  s.summary      = "Segmentify iOS SDK"
  s.platform      = :ios, "9.0"
  s.description  = "Segmentify iOS SDK to enable product recommendations and real-time conversion analytics"
  s.homepage     = "https://github.com/segmentify/segmentify-ios-sdk"
  s.license      = "BSD-2"
  s.author       = { "Segmentify Dev Team" => "development@segmentify.com" }
  s.source       = { :git => "https://github.com/segmentify/segmentify-ios-sdk.git", :tag => "#{s.version}" }
  s.source_files  = "Pod/Classes/**/*swift"
  s.swift_versions = ['3.0', '3.1', '4.0', '4.1', '4.2', '5.0', '5.1', '5.2']

end
