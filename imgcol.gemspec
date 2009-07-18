Gem::Specification.new do |spec|
  spec.name = "some_cool_lib"
  spec.version = "0.0.1"
  spec.summary = "土曜の午後に書いたステキな小さいライブラリ"
  spec.author = "Chad Fowler"
  spec.email = "chad+spam@chadfowler.com"
  spec.homepage = "http://www.chadfowler.com"
  spec.autorequire = "cool"
  spec.files = Dir.glob("{test,lib}/**/*") << "README" << "ChangeLog"
  spec.test_files = ["test/cool_tc.rb"]
  spec.has_rdoc = true
  spec.rdoc_options << << '--line-numbers' << '--inline-source' <<
    "--main" << "README" << "-c UTF-8"
  spec.extra_rdoc_files = ["README"]
end  
