#
#  Be sure to run `pod spec lint Segmentify.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Segmentify"
  s.version      = "1.0.0"
  s.summary      = "Segmentify SDK"
  s.platform      = :ios, "9.0"
  s.description  = "Segmentify iOS SDK"
  s.homepage     = "https://github.com/segmentify/segmentify-ios-sdk"
  s.license      = "MIT"
  s.author       = { "Ata Anıl Turgay" => "ata.turgay@appcent.mobi" }
  s.source       = { :git => "https://github.com/segmentify/segmentify-ios-sdk.git", :tag => "#{s.version}" }
  s.source_files  = "Pod/Classes/**/*"
  s.public_header_files = "Pod/Classes/*.h"

end
