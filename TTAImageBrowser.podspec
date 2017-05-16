#
# Be sure to run `pod lib lint TTAImageBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TTAImageBrowser'
  s.version          = '0.1.2'
  s.summary          = 'TTAImageBrowser is A Image Browser'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TTAImageBrowser is A Image Browser that you can broswe the image from net, local path, imageData and image
                       DESC

  s.homepage         = 'https://github.com/TMTBO/TTAImageBrowser'
# s.screenshots     = 'https://github.com/TMTBO/TTAImageBrowser/blob/master/TTAImageBrowser.gif', 'https://github.com/TMTBO/TTAImageBrowser/blob/master/TTAImageBrowser_SaveImage.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TobyoTenma' => 'tmtbo@hotmail.com' }
  s.source           = { :git => 'https://github.com/TMTBO/TTAImageBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TTAImageBrowser/Classes/**/*'
  
  s.resource_bundles = {
    'TTAImageBrowser' => ['TTAImageBrowser/Resources/*.lproj']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kingfisher', '3.6.2'
end
