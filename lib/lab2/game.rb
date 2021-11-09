require_relative './file_manager.rb'
require_relative './view.rb'
require 'json'
require 'io/console'

module GameStates
  MENU = 0

  RUNNING = 1

  EXIT = 2
end

class Game
  include GameStates

  def initialize
    @view = View.new
    @valera = Valera.new
    @fileManager = FileManager.new
  end

  def start_menu
    @view.start_menu
    input = STDIN.getch.to_i
    case input
    when 1
      return { "player" => Valera.new, "start" => true }
    when 2
      loadedGame = @fileManager.load_game
      return { "player" => Valera.new(loadedGame['health'], loadedGame['alcohol'], loadedGame['happy'], loadedGame['tired'], loadedGame['money']), "start" => true }
    when 3
      return { "start" => false }
    else
      puts "fdssdfsd"
    end
  end

  def start
    app
  end

  def change_attr(name, value)
    @valera.send("#{name}=", @valera.send(name) + value)
  end

  def change_attr_v2(action)
    action['result'].each do |effect|
      change_attr(effect['name'], effect['value'])
      if effect.include?('condition')
        if @valera.send(effect['condition']['name']).between?(effect['condition']['min'], effect['condition']['max'])
          change_attr(effect['name'], effect['condition']['value'])
        end
      end
    end
  end

  def do_action_json(action)
    if action['conditions'].size != 0
      action['conditions'].each do |condition|
        unless @valera.send(condition['name']).between?(condition['min'], condition['max'])
          puts "\nПараметр Валеры #{condition['name']} должен быть в промежутке от #{condition['min']} до #{condition['max']}\n"
          return RUNNING
        end
      end
      change_attr_v2(action)
    else
      change_attr_v2(action)
    end
  end

  def app
    config = @fileManager.load_config
    print config
    state = MENU
    @valera = Valera.new

    loop do
      case state
      when MENU
        game = start_menu
        if game["start"]
          state = RUNNING
          @valera = game["player"]
        end
      when RUNNING
        state = game_step(config)
      when EXIT
        return
      else
        return
      end
    end
  end

  def game_step(config)
    @view.ui(@valera)
    input = STDIN.getch
    #TODO: меню
    case input
    when 'q'
      @view.print_exit
      return EXIT
    when 'm'
      @fileManager.save(@valera)
      return MENU
    when 's'
      @fileManager.save(@valera)
      @view.print_saved
      STDIN.getch
    end
    input = input.to_i - 1
    if input < 0 || input > config['actions'].length - 1
      return RUNNING
    end

    do_action_json(config['actions'][input])

    if @valera.dead?
      puts "Потрачено"
      return EXIT
    end
    return RUNNING
  end
end
