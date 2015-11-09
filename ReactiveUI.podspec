Pod::Spec.new do |s|
  s.name         = "ReactiveUI"
  s.version      = "0.0.3"
  s.summary      = "A lightweight replacement for target action with closures, modified from Scream.swift."
  s.homepage     = "https://github.com/zhxnlai/ReactiveUI"
  s.screenshots  = "https://github.com/zhxnlai/ReactiveUI/raw/master/Previews/screenshot.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Zhixuan Lai" => "zhxnlai@gmail.com" }
  s.social_media_url   = "http://twitter.com/ZhixuanLai"

  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/zhxnlai/ReactiveUI.git", :tag => "0.0.3" }
  s.source_files = 'ReactiveUI/ReactiveUI/*.swift'

  s.framework  = "UIKit"

  s.requires_arc = true
end
