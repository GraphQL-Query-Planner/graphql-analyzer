Dir.glob(File.join('spec', 'support', 'graphql', '**', '*.rb')).each do |filename|
  require(filename.gsub('spec/', ''))
end

class MockContext
  attr_reader :path, :context
  private :context

  def initialize(path:)
    @path = path
    @context = {
      'graphql-analyzer' => {
        'resolvers' => []
      }
    }
  end

  delegate :[], :[]=, :dig, to: :context
end
