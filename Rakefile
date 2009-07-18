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

SPEC = Gem::Specification.new do |s|
  s.name = "imgcol"
  s.version = "0.0.1"
  s.summary = "画像収集ライブラリ"
  s.description = <<-EOF
    画像収集ライブラリ＆コマンドツール
  EOF
  s.author = "byplayer"
  s.email = "byplayer@s7.dion.ne.jp"
  s.homepage = "http://www.emaki.minidns.net"

  s.files = PKG_FILES.to_a

  s.require_path = 'lib'                         # Use these for libraries.
  s.bindir = "bin"                               # Use these for applications.
  s.executables = ["imgcol"]
  s.default_executable = "imgcol"

  s.has_rdoc = true
  s.rdoc_options << '--line-numbers' << '--inline-source' <<
    "--main" << "README" << "-c UTF-8"
  s.extra_rdoc_files = ["README"]

  s.add_dependency('nokogiri')
  s.add_dependency('mechanize', '>=0.9.2')
end

package_task = Rake::GemPackageTask.new(SPEC) do |pkg|
end
