Gem::Specification.new do |s|
  s.name        = "update_tags"
  s.version     = "0.0.1"
  s.summary     = "Jekyll blog post tags for GitHub Pages"
  s.description = "Automatically update your jekyll blog's tag index pages for GitHub Pages"
  s.authors     = ["Nick Pachulski"]
  s.email       = "nick@pachulski.me"
  s.files       = ["lib/update_tags.rb"]
  s.homepage    = "https://github.com/pachun/update_tags"
  s.license     = "MIT"
  s.add_runtime_dependency "thor", "~> 1.2.1"
  s.add_runtime_dependency "fileutils", "~> 1.6.0"
  s.add_runtime_dependency "filewatcher", "~> 2.0.0"
  s.add_runtime_dependency "front_matter_parser", "~> 1.0.1"
  s.executables << "update_tags"
end
