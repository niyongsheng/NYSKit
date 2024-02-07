Pod::Spec.new do |s|
  s.name             = 'NYSKit'
  s.version          = '0.0.6'
  s.platform         = :ios, '13.0'
  s.summary          = 'iOS scaffold core framework.'
  s.homepage         = 'https://github.com/niyongsheng/NYSKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NiYongsheng' => 'niyongsheng@outlook.com' }
  s.source           = { :git => 'https://github.com/niyongsheng/NYSKit.git', :tag => s.version }
  s.source_files     = 'NYSKit/**/*.{h,m}'
  s.dependency       'AFNetworking', '~> 4.0'
  s.dependency       'SVProgressHUD', '~> 2.0'
  s.requires_arc     = true
end
