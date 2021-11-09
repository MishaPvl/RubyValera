require_relative './valera.rb'
require "json"

class View

  def initialize
    @fileManager = FileManager.new
  end

  def ui(valera)
    puts "\e[H\e[2J"
    print_stats(valera)
    print_actions
    print_configs
  end

  def print_stats(valera)
    puts 'Параметры Валеры:'
    puts "Здоровье: #{valera.health} \tОпьянение: #{valera.alcohol}"
    puts "Счастье: #{valera.happy} \t Усталость: #{valera.tired}"
    puts "Деньги: #{valera.money}$\n\n"
  end

  def start_menu
    puts "\e[H\e[2J"
    puts "|--------| Приключения Маргинала Валеры |--------|\n\n\n"
    puts "1 - Новая игра"
    puts "2 - Загрузить игру"
    puts "3 - Выход"
  end

  def print_actions
    config = @fileManager.load_config
    counter = 1
    config['actions'].each do |action|
      puts "#{counter.to_s} - #{action['name']}"
      counter += 1
    end
  end

  def print_configs
    puts "s - сохранить игру      ||      q - выйти из игры      ||      m - выйти в меню"
  end

  def print_exit
    puts "\nВы бросили Валеру"
  end

  def print_saved
    puts "\n****Игра сохранена****"
    puts "Нажмите любую клавишу чтобы продолжить"
  end
end
