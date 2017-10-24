#
# Be sure to run `pod lib lint MRJ_QRCode.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MRJ_QRCode'
  s.version          = '0.3.1.5'
  s.summary          = '集成扫码和生成二维码功能，添加必要的加密.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 通过修改资源，对二维码添加logo，增加加密算法，这个库可能还有些问题等待修复，希望大家帮助找出，并给我发邮件消息.
                       DESC

  s.homepage         = 'https://github.com/mrjlovetian/YHJARCode'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrjyuhongjiang' => 'mrjlovetian@gmail.com' }
  s.source           = { :git => 'https://github.com/mrjlovetian/YHJARCode.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MRJ_YU'

  s.ios.deployment_target = '8.0'


  # s.resource_bundles = {
  #    'MRJ_QRCode' => ['MRJ_QRCode/KKQRCode/*.png'],
  # 'MRJ_QRCode' => ['MRJ_QRCode/Assets/*.png']
  #  }

#资源文件引入
    s.resource      = 'MRJ_QRCode.bundle'

#文件夹创建
    s.subspec 'Code' do |yy|
        yy.source_files = 'MRJ_QRCode/Classes/*.{h,m}'
#yy.frameworks = 'QRCode'
    end

end
