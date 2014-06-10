Pod::Spec.new do |s|
  s.name         = "Alkemy"
  s.version      = "0.0.1"
  s.summary      = "Alkemy enables to accelate your development afficiency."
  s.homepage     = "http://www.heartlay-studio.co.jp"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author    = "KazukiSaima"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://KazukiSaima@bitbucket.org/heartlaystudio/alkemy.git", :tag => "#{s.version}" }
  s.source_files  = "Alkemy", "Alkemy/**/*.{h,m}"
  s.exclude_files = "Alkemy/Exclude"
  s.requires_arc = true
  s.dependency "AFNetworking"
end
