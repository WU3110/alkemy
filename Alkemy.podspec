Pod::Spec.new do |s|
  s.name         = "Alkemy"
  s.version      = "0.0.4"
  s.summary      = "Alkemy enables to accelate your development afficiency."
  s.homepage     = "http://www.heartlay-studio.co.jp"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author    = "KazukiSaima"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "git@bitbucket.org:heartlaystudio/alkemy.git", :tag => "#{s.version}" }
  s.source_files  = 'Alkemy/**/*.{h,m}'
  s.resources    = 'Alkemy/**/*.xib'
  s.exclude_files = "Alkemy/Exclude"
  s.requires_arc = true
  s.dependency "AFNetworking"

  s.subspec "AKAnimationController" do |a|
    a.source_files = 'Alkemy/AKAnimationController/*.{h,m}'
  end

  s.subspec "AKDynamicLoadHelper" do |a|
    a.source_files = 'Alkemy/AKDynamicLoadHelper/*.{h,m}'
  end

  s.subspec "AKForkViewController" do |a|
    a.source_files = 'Alkemy/AKForkViewController/*.{h,m}'
    a.dependency "AFNetworking"
  end

  s.subspec "AKInteractionConroller" do |a|
    a.source_files = 'Alkemy/AKInteractionController/*.{h,m}'
  end

  s.subspec "AKSimpleWebViewController" do |a|
    a.source_files = 'Alkemy/AKSimpleWebViewController/*.{h,m}'
    a.resources = 'Alkemy/AkSimpleWebViewController/*.xib'
  end

  s.subspec "AKSwitchButton" do |a|
    a.source_files = 'Alkemy/AKSwitchButton/*.{h, m}'
  end

end
