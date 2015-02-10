
Pod::Spec.new do |s|
  s.name     = 'App-Datastore-Manager'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'App-Datastore-Manager aims to be a drop-in replacement for UITabBarController.' 
  s.description = 'App-Datastore-Manager aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://www.github.com/wanghaogithub720'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/wanghaogithub720/mxYoutube.git', :tag => '0.1.0' }
  s.platform = :ios, '7.0'

  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true

  s.subspec 'sqlite-helper' do |sub|
    sub.source_files = 'Pod/Classes/sqlite-helper/*.{h,m}'
  end


end



