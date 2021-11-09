require 'rspec'
require_relative '../lib/lab2/game'

describe Game do
  describe 'Save and load file' do
    let(:game) { Game.new }
    let(:valera_expected) { Valera.new }
    let(:valerabb) { Valera.new }
    let(:config) { FileManager.new.load_config }
    it 'Valera work' do
      game.do_action_json(config['actions'][0])
      expect(game.get_valera) == valera_expected
    end
  end
end
