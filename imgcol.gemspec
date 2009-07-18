Gem::Specification.new do |spec|
  spec.name = "imgcol"
  spec.version = "0.0.1"
  spec.summary = "‰æ‘œûWƒ‰ƒCƒuƒ‰ƒŠ"
  spec.author = "byplayer"
  spec.email = "byplayer@s7.dion.ne.jp"
  spec.homepage = "http://www.emaki.minidns.net"
  spec.autorequire = "cool"
  spec.files = Dir.glob("{test,lib}/**/*") << "README" << "ChangeLog"
  # spec.test_files = ["test/imgcol.rb"]
  spec.has_rdoc = true
  spec.rdoc_options << '--line-numbers' << '--inline-source' <<
    "--main" << "README" << "-c UTF-8"
  spec.extra_rdoc_files = ["README"]

  spec.add_dependency('nokogiri')
  spec.add_dependency('mechanize', '>=0.9.2')
end
