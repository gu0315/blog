

Pod::Spec.new do |spec|
  spec.name             = 'RootViewController'
  spec.version          = '0.1.0'
  spec.summary          = '根控制器'
  spec.description      = <<-DESC
        TODO: Add long description of the pod here.
                       DESC
                       spec.homepage         = 'https://github.com'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "gqx" => "guqianxiang@souche.com" }
  spec.source = {:path => 'Classes/**/*'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  spec.ios.deployment_target = '9.0'
  # s.vendored_frameworks = 'Products/*.framework'
  spec.source_files  = "Classes/**/*.{h,m,swift}"
  # spec.exclude_files = "Classes/Exclude"

  spec.swift_versions = ['4.2', '5.0', '5.1']
  spec.public_header_files = 'RootViewController/Classes/**/*.{h,m,swift}'
  # spec.resource_bundles = {
  #   
  # }
  # spec.frameworks = 'UIKit', 'MapKit'
  spec.dependency 'Integration'
end
