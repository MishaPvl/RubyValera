require_relative './spec_helper'
require_relative '../lib/lab2/file_manager'

RSpec.describe FileManager do
  describe 'Save and load file' do
    let(:valera_expected) { Valera.new }
    let(:file_manager) { FileManager.new }
    it 'Save and load file' do
      file_manager.save(valera_expected)
      loadedGame = file_manager.load_game
      valera_loaded = Valera.new(loadedGame['health'], loadedGame['alcohol'], loadedGame['happy'], loadedGame['tired'], loadedGame['money'])
      expect(valera_loaded) == valera_expected
    end
  end
  describe 'Config file' do
    let(:file_manager) { FileManager.new }
    it 'Exist config' do
      expect(file_manager.load_config.size).to eq(1)
    end
  end
end

