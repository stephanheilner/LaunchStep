Pod::Spec.new do |s|
  s.name         = "LaunchStep"
  s.version      = "1.4.2"
  s.summary      = "Launch progress with progress bar."
  s.author       = 'Stephan Heilner'
  s.homepage     = "https://github.com/stephanheilner/LaunchStep"
  s.license      = 'MIT'
  s.description  = <<-DESC
                   Launch Splash screen with progress.
                   DESC
  s.source       = { :git => "https://github.com/stephanheilner/LaunchStep.git", :tag => s.version.to_s }
  s.platform     = :ios, '12.0'
  s.source_files  = 'Sources/LaunchStep/*.{swift}'
  s.requires_arc = true
  s.swift_version = '5.0'
end
