Pod::Spec.new do |spec|

  spec.name         = "STSemiView"
  spec.version      = "1.0.0"
  spec.summary      = "A category file of UIViewController."
  spec.description  = <<-DESC
			it is easy to present a semiView in ViewController.
                      DESC
  spec.homepage     = "https://github.com/Shawnli1201"
  spec.license      = "MIT"
  spec.author             = { "Shawnli1201" => "shawnli1201@gmail.com" }
  spec.platform     = :ios,"8.0"
  spec.source       = { :git => "https://github.com/Shawnli1201/STSemiView.git", :tag => "#{spec.version}" }
  spec.source_files  = "STSemiView/**/*.{h,m}"
  spec.requires_arc  = true

end
