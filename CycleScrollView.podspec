Pod::Spec.new do |s|
      s.name = 'CycleScrollView'
      s.version = '1.0.0'
      s.license = 'MIT'
      s.summary = 'Simple and easy to use wheel seeding'
      s.homepage = 'https://github.com/YUyakun/CycleScrollView'
      s.authors = { 'YUyakun' => '1667607242@qq.com' }
      s.source = { :git => 'https://github.com/Darren-chenchen/CLImagePickerTool.git', :tag => s.version.to_s }

      s.ios.deployment_target = '8.0'

      s.source_files = 'CycleScrollView/CycleScrollView/**/*.swift'
      s.resource_bundles = { 
'CLImagePickerTool' => ['CycleScrollView/CycleScrollView/Assets.xcassets']
      }
 end