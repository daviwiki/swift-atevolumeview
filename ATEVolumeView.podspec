
Pod::Spec.new do |s|
  s.name             = 'ATEVolumeView'
  s.version          = '0.1.0'
  s.summary          = 'A visual customization for MPVolumeView'

  s.description      = <<-DESC
This module implements a full customization for MPVolumenView control that you could add to any uiviewcontroller
                       DESC

  s.homepage         = 'https://github.com/daviwiki/ATEVolumeView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daviwiki' => 'daviddvd19@gmail.com' }
  s.source           = { :git => 'https://github.com/daviwiki/ATEVolumeView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'ATEVolumeView/Classes/**/*'

end
