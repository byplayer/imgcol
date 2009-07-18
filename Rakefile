# Rakefile for imgcol        -*- ruby -*-

require 'rubygems'
require 'rake/gempackagetask'

if `ruby -Ilib ./bin/imgcol --version` =~ /ImageCollector, version ([0-9.]+)$/
  CURRENT_VERSION = $1
else
  CURRENT_VERSION = "0.0.0"
end

# ====================================================================
# Create a task that will package the Rake software into distributable
# gem files.
PKG_FILES = FileList[
  '[A-Z]*',
  'bin/**/*',
  'lib/**/*.rb',
  'test/**/*.rb',
  'doc/**/*'
]

SPEC = Gem::Specification.new do |spec|
  spec.name = "imgcol"
  spec.version = "0.0.1"
  spec.summary = "画像収集ライブラリ"
  spec.description = <<-EOF
    画像収集ライブラリ＆コマンドツール
  EOF
  spec.author = "byplayer"
  spec.email = "byplayer@s7.dion.ne.jp"
  spec.homepage = "http://www.emaki.minidns.net"

  spec.files = Dir.glob("{test,lib}/**/*") << "README" << "ChangeLog"
  # spec.test_files = ["test/imgcol.rb"]
  spec.has_rdoc = true
  spec.rdoc_options << '--line-numbers' << '--inline-source' <<
    "--main" << "README" << "-c UTF-8"
  spec.extra_rdoc_files = ["README"]

  spec.add_dependency('nokogiri')
  spec.add_dependency('mechanize', '>=0.9.2')
end

package_task = Rake::GemPackageTask.new(SPEC) do |pkg|
end
