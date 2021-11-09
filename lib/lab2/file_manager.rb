class FileManager

  def initialize
    @saveFileLocation = "/storage/saved_game.json"
    @configFileLocation = "/storage/actions.json"
  end

  def save(valera)
    hash = { 'health' => valera.health,
             'alcohol' => valera.alcohol, 'happy' => valera.happy,
             'tired' => valera.tired, 'money' => valera.money
    }

    File.open(File.dirname(__FILE__) + @saveFileLocation, "w") do |f|
      f.write(JSON.pretty_generate(hash))
    end
  end

  def load_game
    file_new = open File.dirname(__FILE__) + @saveFileLocation
    hash_new = JSON.parse(file_new.read)
    return hash_new
  end

  def load_config
    file = open File.dirname(__FILE__) + @configFileLocation
    hash = JSON.parse(file.read)
    return hash
  end
end
