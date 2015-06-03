require "./lib/genebrand/version"

`gem uninstall genebrand -x`
`rm ./genebrand-*.gem`
`gem build genebrand.gemspec`
`gem install ./genebrand-#{Genebrand::VERSION}.gem`
