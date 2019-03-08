module Rubica
  def self.initialize
    Dir.glob(File.expand_path('lib/**/*.rb', __dir__)).each do |file|
      puts(file)
      #loading rubicatests.rb
      require file
    end
  end
end