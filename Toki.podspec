Pod::Spec.new do |s|
  s.name             = "Toki"
  s.version          = "0.10.0"
  s.summary          = "SOAP Stubber for APIs generated by WSDL2Swift"
  s.description      = <<-DESC
                       Toki enables to test using stubbed SOAP responses for APIs generated by WSDL2Swift.
                       DESC

  s.homepage         = "https://github.com/banjun/Toki"
  s.license          = 'MIT'
  s.author           = { "banjun" => "banjun@gmail.com" }
  s.source           = { :git => "https://github.com/banjun/Toki.git", :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'XCTest'
  s.dependency 'Mockingjay', '~> 2.0'
  s.dependency 'OHHTTPStubs/NSURLSession', '~> 5.2'
  s.dependency 'AEXML'
  s.dependency 'WSDL2Swift', '>= 0.7'
  s.dependency 'Fuzi'
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
