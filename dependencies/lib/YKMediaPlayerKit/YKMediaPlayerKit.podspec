Pod::Spec.new do |s|
  s.name         = "YKMediaPlayerKit"
  s.version      = "0.0.2"
  s.summary      = "Painlessly and natively play YouTube, Vimeo, and .MP4, .MOV, .MPV, .3GP videos and fetch thumbnails on your iOS devices"
  s.homepage     = "https://github.com/YasKuraishi/YKMediaPlayerKit"
  s.license      = 'MIT'
  s.author       = { "Yas Kuraishi" => "kuraishi@gmail.com" }
  s.social_media_url = "http://twitter.com/@YasKuraishi"
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/YasKuraishi/YKMediaPlayerKit.git", :tag => "0.0.2" }
  s.frameworks   = 'UIKit', 'CoreGraphics'
  s.requires_arc = true

  s.subspec 'YKMediaPlayerKit' do |sub|
    sub.source_files = 'Pod/Classes/YKMediaPlayerKit/**/*.{h,m}'
  end

  s.subspec 'DJMediaPlayerKit' do |sub|
    sub.source_files = 'Pod/Classes/DJMediaPlayerKit/*.{h,m}'
  end

  s.subspec 'XCDYouTubeKit' do |sub|
    sub.source_files = 'Pod/Classes/XCDYouTubeKit/*.{h,m}'
  end
end
