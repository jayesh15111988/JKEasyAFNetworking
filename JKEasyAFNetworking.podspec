Pod::Spec.new do |s|
  s.name          = 'JKEasyAFNetworking'
  s.version       = '1.0'
  s.license       = 'MIT'
  s.summary       = 'AFNetworking Made easy with simple API and Demo example'
  s.homepage      = 'https://github.com/jayesh15111988'
  s.author        = 'Jayesh Kawli'
  s.source        = { 
            :git => 'git@github.com:jayesh15111988/JKEasyAFNetworking.git',:branch => 'master' 
            }
  s.source_files  = 'JKEasyAFNetworking/NetworkingSourceGroup/**'
  s.requires_arc  = true
  s.ios.deployment_target = '7.0'
  s.dependency 'AFNetworking', '~> 1.3.3'
  s.dependency 'TPKeyboardAvoiding', '~> 1.2'
end