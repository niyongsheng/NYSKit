Pod::Spec.new do |s|
  s.name             = 'NYSUIKit'
  s.version          = '0.0.2'
  s.platform         = :ios, '13.0'
  s.summary          = 'iOS scaffold UI framework.'
  s.homepage         = 'https://github.com/niyongsheng/NYSKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NiYongsheng' => 'niyongsheng@outlook.com' }
  s.source           = { :git => 'https://github.com/niyongsheng/NYSKit.git', :tag => s.version }
  s.source_files     = 'NYSUIKit/**/*.{h,m}'
  s.resources = [
  'NYSUIKit/BaseClass/WebViewController/ErrorHtml/WebLoadErrorView.html',
  'NYSUIKit/BaseClass/WebViewController/ErrorHtml/webloaderrorview.png',
  'NYSUIKit/Resources/NYSUIKit.xcassets',
  'NYSUIKit/Resources/NYSUIKit.bundle',
  'NYSUIKit/Resources/douyuFont.otf'
]
  s.dependency       'NYSKit', '~> 0.0.1'
  s.dependency       'MJRefresh', '~> 3.7.6'
  s.dependency       'DZNEmptyDataSet', '~> 1.8.1'
  s.requires_arc     = true
end
