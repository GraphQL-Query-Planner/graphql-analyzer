Dir.glob(File.join('spec', 'support', 'graphql', '**', '*.rb')).each do |filename|
  require(filename.gsub('spec/', ''))
end
