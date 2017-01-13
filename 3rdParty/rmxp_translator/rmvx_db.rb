require_relative 'tran_util'
require_relative 'common_db'

# This file contains all the RPG data structures for RPG Maker VX.

module RPG
  class Actor
    def initialize
      @id = 0
      @name = ""
      @class_id = 1
      @initial_level = 1
      @exp_basis = 25
      @exp_inflation = 35
      @character_name = ""
      @character_index = 0
      @face_name = ""
      @face_index = 0
      @parameters = Table.new(6, 100)
      for i in 1..99
        @parameters[0,i] = 400+i*50
        @parameters[1,i] = 80+i*10
        @parameters[2,i] = 15+i*5/4
        @parameters[3,i] = 15+i*5/4
        @parameters[4,i] = 20+i*5/2
        @parameters[5,i] = 20+i*5/2
      end
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @two_swords_style = false
      @fix_equipment = false
      @auto_battle = false
      @super_guard = false
      @pharmacology = false
      @critical_bonus = false
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      self 
    end

    def update(tran, info)
      update_string("name", @name, tran, info)
    end
  end

  class Class
    def initialize
      @id = 0
      @name = ""
      @position = 0
      @weapon_set = []
      @armor_set = []
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @learnings = []
      @skill_name_valid = false
      @skill_name = ""
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      self
    end

    def update(tran, info)
      update_string("name", @name, tran, info)
    end

    class Learning
      def initialize
        @level = 1
        @skill_id = 1
      end
    end
  end

  class Map
    def initialize(width, height)
      @width = width
      @height = height
      @scroll_type = 0
      @autoplay_bgm = false
      @bgm = RPG::AudioFile.new
      @autoplay_bgs = false
      @bgs = RPG::AudioFile.new("", 80)
      @disable_dashing = false
      @encounter_list = []
      @encounter_step = 30
      @parallax_name = ""
      @parallax_loop_x = false
      @parallax_loop_y = false
      @parallax_sx = 0
      @parallax_sy = 0
      @parallax_show = false
      @data = Table.new(width, height, 3)
      @events = {}
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'events' => dump_array(@events.sort)
      }.to_json(*a)
    end

    def translate(tran, info)
      @events = translate_hash("events", @events, tran, info)
      self
    end

    def update(tran, info)
      update_hash("events", @events, tran, info)
    end
  end

  class MapInfo
    def initialize
      @name = ""
      @parent_id = 0
      @order = 0
      @expanded = false
      @scroll_x = 0
      @scroll_y = 0
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      self
    end

    def update(tran, info)
      update_string("name", @name, tran, info)
    end
  end

  class Area
    def initialize
      @id = 0
      @name = ""
      @map_id = 0
      @rect = Rect.new(0,0,0,0)
      @encounter_list = []
      @order = 0
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      self
    end

    def update(tran, info)
      update_string("name", @name, tran, info)
    end
  end

  class Event
    def initialize(x, y)
      @id = 0
      @name = ""
      @x = x
      @y = y
      @pages = [RPG::Event::Page.new]
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'pages' => @pages
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @pages = translate_list("pages", @pages, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      update_list("pages", @pages, tran, info)
    end

    class Page
      def initialize
        @condition = RPG::Event::Page::Condition.new
        @graphic = RPG::Event::Page::Graphic.new
        @move_type = 0
        @move_speed = 3
        @move_frequency = 3
        @move_route = RPG::MoveRoute.new
        @walk_anime = true
        @step_anime = false
        @direction_fix = false
        @through = false
        @priority_type = 0
        @trigger = 0
        @list = [RPG::EventCommand.new]
      end

      def to_json(*a)
        {
          'json_class' => self.class.name,
          'commands' => merge_event_commands(@list)
        }.to_json(*a)
      end

      def translate(tran, info)
        @list = merge_event_commands(@list)
        @list = translate_list("commands", @list, tran, info)
        @list = split_event_commands(@list)
        self
      end

      def update(tran, info)
        @list = merge_event_commands(@list)
        update_list("commands", @list, tran, info)
      end

      class Condition
        def initialize
          @switch1_valid = false
          @switch2_valid = false
          @variable_valid = false
          @self_switch_valid = false
          @item_valid = false
          @actor_valid = false
          @switch1_id = 1
          @switch2_id = 1
          @variable_id = 1
          @variable_value = 0
          @self_switch_ch = "A"
          @item_id = 1
          @actor_id = 1
        end
      end

      class Graphic
        def initialize
          @tile_id = 0
          @character_name = ""
          @character_index = 0
          @direction = 2
          @pattern = 0
        end
      end
    end
  end

  class EventCommand
    def initialize(code = 0, indent = 0, parameters = [])
      @code = code
      @indent = indent
      @parameters = parameters
    end

    attr_accessor :code
    attr_accessor :indent
    attr_accessor :parameters

    def to_json(*a)
      obj = {}
      obj['json_class'] = self.class.name
      (type, is_text) = get_event_type(@code)

      obj['type'] = type

      if is_text then
        obj['parameters'] = dump_parameters(@parameters)
      end

      obj.to_json(*a)
    end

    def translate(tran, info)
      @parameters = translate_parameters("parameters", @parameters, tran, info)
      self
    end

    def update(tran, info)
      (_, is_text) = get_event_type(@code)

      if is_text then 
        update_parameters("parameters", @parameters, tran, info)
      else
        tran
      end
    end
  end

  class MoveRoute
    def initialize
      @repeat = true
      @skippable = false
      @wait = false
      @list = [RPG::MoveCommand.new]
    end
  end

  class MoveCommand
    def initialize(code = 0, parameters = [])
      @code = code
      @parameters = parameters
    end
  end

  class BaseItem
    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @description = ""
      @note = ""
    end

    def base_to_json(clsname)
      {
        'json_class' => clsname,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'note' => dump_string(@note)
      }
    end

    def base_translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
    end

    def base_update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class UsableItem < BaseItem
    def initialize
      super
      @scope = 0
      @occasion = 0
      @speed = 0
      @animation_id = 0
      @common_event_id = 0
      @base_damage = 0
      @variance = 20
      @atk_f = 0
      @spi_f = 0
      @physical_attack = false
      @damage_to_mp = false
      @absorb_damage = false
      @ignore_defense = false
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    def for_opponent?
      return [1, 2, 3, 4, 5, 6].include?(@scope)
    end
    def for_friend?
      return [7, 8, 9, 10, 11].include?(@scope)
    end
    def for_dead_friend?
      return [9, 10].include?(@scope)
    end
    def for_user?
      return [11].include?(@scope)
    end
    def for_one?
      return [1, 3, 4, 7, 9, 11].include?(@scope)
    end
    def for_two?
      return [5].include?(@scope)
    end
    def for_three?
      return [6].include?(@scope)
    end
    def for_random?
      return [4, 5, 6].include?(@scope)
    end
    def for_all?
      return [2, 8, 10].include?(@scope)
    end
    def dual?
      return [3].include?(@scope)
    end
    def need_selection?
      return [1, 3, 7, 9].include?(@scope)
    end
    def battle_ok?
      return [0, 1].include?(@occasion)
    end
    def menu_ok?
      return [0, 2].include?(@occasion)
    end
  end

  class Skill < UsableItem
    def initialize
      super
      @scope = 1
      @mp_cost = 0
      @hit = 100
      @message1 = ""
      @message2 = ""
    end

    def to_json(*a)
      data = base_to_json(self.class.name)
      data['message1'] = dump_string(@message1)
      data['message2'] = dump_string(@message2)
      data.to_json(*a)
    end

    def translate(tran, info)
      base_translate(tran, info)
      @message1 = translate_string("message1", @message1, tran, info)
      @message2 = translate_string("message2", @message2, tran, info)
      self
    end

    def update(tran, info)
      tran = base_update(tran, info)
      tran = update_string("message1", @message1, tran, info)
      update_string("message2", @message2, tran, info)
    end
  end

  class Item < UsableItem
    def initialize
      super
      @scope = 7
      @price = 0
      @consumable = true
      @hp_recovery_rate = 0
      @hp_recovery = 0
      @mp_recovery_rate = 0
      @mp_recovery = 0
      @parameter_type = 0
      @parameter_points = 0
    end

    def to_json(*a)
      base_to_json(self.class.name).to_json(*a)
    end

    def translate(tran, info)
      base_translate(tran, info)
      self
    end

    def update(tran, info)
      base_update(tran, info)
    end
  end

  class Weapon < BaseItem
    def initialize
      super
      @animation_id = 0
      @price = 0
      @hit = 95
      @atk = 0
      @def = 0
      @spi = 0
      @agi = 0
      @two_handed = false
      @fast_attack = false
      @dual_attack = false
      @critical_bonus = false
      @element_set = []
      @state_set = []
    end

    def to_json(*a)
      base_to_json(self.class.name).to_json(*a)
    end

    def translate(tran, info)
      base_translate(tran, info)
      self
    end

    def update(tran, info)
      base_update(tran, info)
    end
  end

  class Armor < BaseItem
    def initialize
      super
      @kind = 0
      @price = 0
      @eva = 0
      @atk = 0
      @def = 0
      @spi = 0
      @agi = 0
      @prevent_critical = false
      @half_mp_cost = false
      @double_exp_gain = false
      @auto_hp_recover = false
      @element_set = []
      @state_set = []
    end

    def to_json(*a)
      base_to_json(self.class.name).to_json(*a)
    end

    def translate(tran, info)
      base_translate(tran, info)
      self
    end

    def update(tran, info)
      base_update(tran, info)
    end
  end

  class Enemy
    def initialize
      @id = 0
      @name = ""
      @battler_name = ""
      @battler_hue = 0
      @maxhp = 10
      @maxmp = 10
      @atk = 10
      @def = 10
      @spi = 10
      @agi = 10
      @hit = 95
      @eva = 5
      @exp = 0
      @gold = 0
      @drop_item1 = RPG::Enemy::DropItem.new
      @drop_item2 = RPG::Enemy::DropItem.new
      @levitate = false
      @has_critical = false
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @note = ""
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      update_string("note", @note, tran, info)
    end

    class DropItem
      def initialize
        @kind = 0
        @item_id = 1
        @weapon_id = 1
        @armor_id = 1
        @denominator = 1
      end
    end

    class Action
      def initialize
        @kind = 0
        @basic = 0
        @skill_id = 1
        @condition_type = 0
        @condition_param1 = 0
        @condition_param2 = 0
        @rating = 5
      end
      def skill?
        return @kind == 1
      end
    end
  end

  class Troop
    def initialize
      @id = 0
      @name = ""
      @members = []
      @pages = [RPG::BattleEventPage.new]
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'pages' => @pages
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @pages = translate_list("pages", @pages, tran, info)
      self
    end

    def update(tran, info)
      @name = update_string("name", @name, tran, info)
      @pages = update_list("pages", @pages, tran, info)
    end

    class Member
      def initialize
        @enemy_id = 1
        @x = 0
        @y = 0
        @hidden = false
        @immortal = false
      end
    end

    class Page
      def initialize
        @condition = RPG::Troop::Page::Condition.new
        @span = 0
        @list = [RPG::EventCommand.new]
      end

      def to_json(*a)
        {
          'json_class' => self.class.name,
          'commands' => merge_event_commands(@list)
        }.to_json(*a)
      end

      def translate(tran, info)
        @list = merge_event_commands(@list)
        @list = translate_list("commands", @list, tran, info)
        @list = split_event_commands(@list)
        self
      end

      def update(tran, info)
        @list = merge_event_commands(@list)
        update_list("commands", @list, tran, info)
      end

      class Condition
        def initialize
          @turn_ending = false
          @turn_valid = false
          @enemy_valid = false
          @actor_valid = false
          @switch_valid = false
          @turn_a = 0
          @turn_b = 0
          @enemy_index = 0
          @enemy_hp = 50
          @actor_id = 1
          @actor_hp = 50
          @switch_id = 1
        end
      end
    end
  end 

  class State
    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @restriction = 0
      @priority = 5
      @atk_rate = 100
      @def_rate = 100
      @spi_rate = 100
      @agi_rate = 100
      @nonresistance = false
      @offset_by_opposite = false
      @slip_damage = false
      @reduce_hit_ratio = false
      @battle_only = true
      @release_by_damage = false
      @hold_turn = 0
      @auto_release_prob = 0
      @message1 = ""
      @message2 = ""
      @message3 = ""
      @message4 = ""
      @element_set = []
      @state_set = []
      @note = ""
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'message1' => dump_string(@message1),
        'message2' => dump_string(@message2),
        'message3' => dump_string(@message3),
        'message4' => dump_string(@message4),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @message1 = translate_string("message1", @message1, tran, info)
      @message2 = translate_string("message2", @message2, tran, info)
      @message3 = translate_string("message3", @message3, tran, info)
      @message4 = translate_string("message4", @message4, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("message1", @message1, tran, info)
      tran = update_string("message2", @message2, tran, info)
      tran = update_string("message3", @message3, tran, info)
      tran = update_string("message4", @message4, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class Animation
    def initialize
      @id = 0
      @name = ""
      @animation1_name = ""
      @animation1_hue = 0
      @animation2_name = ""
      @animation2_hue = 0
      @position = 1
      @frame_max = 1
      @frames = [RPG::Animation::Frame.new]
      @timings = []
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      self
    end

    def update(tran, info)
      update_string("name", @name, tran, info)
    end

    class Frame
      def initialize
        @cell_max = 0
        @cell_data = Table.new(0, 0)
      end
    end

    class Timing
      def initialize
        @frame = 0
        @se = RPG::AudioFile.new("", 80)
        @flash_scope = 0
        @flash_color = Color.new(255,255,255,255)
        @flash_duration = 5
      end
    end
  end

  class CommonEvent
    def initialize
      @id = 0
      @name = ""
      @trigger = 0
      @switch_id = 1
      @list = [RPG::EventCommand.new]
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'commands' => merge_event_commands(@list)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @list = merge_event_commands(@list)
      @list = translate_list("commands", @list, tran, info)
      @list = split_event_commands(@list)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      @list = merge_event_commands(@list)
      update_list("commands", @list, tran, info)
    end
  end

  class System
    def initialize
      @game_title = ""
      @version_id = 0
      @party_members = [1]
      @elements = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @passages = Table.new(8192)
      @boat = RPG::System::Vehicle.new
      @ship = RPG::System::Vehicle.new
      @airship = RPG::System::Vehicle.new
      @title_bgm = RPG::BGM.new
      @battle_bgm = RPG::BGM.new
      @battle_end_me = RPG::ME.new
      @gameover_me = RPG::ME.new
      @sounds = []
      20.times { @sounds.push(RPG::AudioFile.new) }
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @terms = RPG::System::Terms.new
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'game_title' => dump_string(@game_title),
        'terms' => @terms,
        'elements' => dump_array(@elements),
        'switches' => dump_array(@switches),
        'variables' => dump_array(@variables)
      }.to_json(*a)
    end

    def translate(tran, info)
      @game_title = translate_string("game_title", @game_title, tran, info)
      @terms = @terms.translate(tran["terms"], info.add("terms"))
      @elements = translate_array("elements", @elements, tran, info)
      @switches = translate_array("switches", @switches, tran, info)
      @variables = translate_array("variables", @variables, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("game_title", @game_title, tran, info)
      tran["terms"] = @terms.update(tran["terms"], info.add("terms"))
      tran = update_array("elements", @elements, tran, info)
      tran = update_array("switches", @switches, tran, info)
      tran = update_array("variables", @variables, tran, info)
    end

    class Vehicle
      def initialize
        @character_name = ""
        @character_index = 0
        @bgm = RPG::AudioFile.new
        @start_map_id = 0
        @start_x = 0
        @start_y = 0
      end
    end

    class Terms
      def initialize
        @level = ""
        @level_a = ""
        @hp = ""
        @hp_a = ""
        @mp = ""
        @mp_a = ""
        @atk = ""
        @def = ""
        @spi = ""
        @agi = ""
        @weapon = ""
        @armor1 = ""
        @armor2 = ""
        @armor3 = ""
        @armor4 = ""
        @weapon1 = ""
        @weapon2 = ""
        @attack = ""
        @skill = ""
        @guard = ""
        @item = ""
        @equip = ""
        @status = ""
        @save = ""
        @game_end = ""
        @fight = ""
        @escape = ""
        @new_game = ""
        @continue = ""
        @shutdown = ""
        @to_title = ""
        @cancel = ""
        @gold = ""
      end

      def to_json(*a)
        {
          'level' => dump_string(@level),
          'level_a' => dump_string(@level_a),
          'hp' => dump_string(@hp),
          'hp_a' => dump_string(@hp_a),
          'mp' => dump_string(@mp),
          'mp_a' => dump_string(@mp_a),
          'atk' => dump_string(@atk),
          'def' => dump_string(@def),
          'spi' => dump_string(@spi),
          'agi' => dump_string(@agi),
          'weapon' => dump_string(@weapon),
          'armor1' => dump_string(@armor1),
          'armor2' => dump_string(@armor2),
          'armor3' => dump_string(@armor3),
          'armor4' => dump_string(@armor4),
          'weapon1' => dump_string(@weapon1),
          'weapon2' => dump_string(@weapon2),
          'attack' => dump_string(@attack),
          'skill' => dump_string(@skill),
          'guard' => dump_string(@guard),
          'item' => dump_string(@item),
          'equip' => dump_string(@equip),
          'status' => dump_string(@status),
          'save' => dump_string(@save),
          'game_end' => dump_string(@game_end),
          'fight' => dump_string(@fight),
          'escape' => dump_string(@escape),
          'new_game' => dump_string(@new_game),
          'continue' => dump_string(@continue),
          'shutdown' => dump_string(@shutdown),
          'to_title' => dump_string(@to_title),
          'cancel' => dump_string(@cancel),
          'gold' => dump_string(@gold)
        }.to_json(*a)
      end

      def translate(tran, info)
        @level = translate_string("level", @level, tran, info)
        @level_a = translate_string("level_a", @level_a, tran, info)
        @hp = translate_string("hp", @hp, tran, info)
        @hp_a = translate_string("hp_a", @hp_a, tran, info)
        @mp = translate_string("mp", @mp, tran, info)
        @mp_a = translate_string("mp_a", @mp_a, tran, info)
        @atk = translate_string("atk", @atk, tran, info)
        @def = translate_string("def", @def, tran, info)
        @spi = translate_string("spi", @spi, tran, info)
        @agi = translate_string("agi", @agi, tran, info)
        @weapon = translate_string("weapon", @weapon, tran, info)
        @armor1 = translate_string("armor1", @armor1, tran, info)
        @armor2 = translate_string("armor2", @armor2, tran, info)
        @armor3 = translate_string("armor3", @armor3, tran, info)
        @armor4 = translate_string("armor4", @armor4, tran, info)
        @weapon1 = translate_string("weapon1", @weapon1, tran, info)
        @weapon2 = translate_string("weapon2", @weapon2, tran, info)
        @attack = translate_string("attack", @attack, tran, info)
        @skill = translate_string("skill", @skill, tran, info)
        @guard = translate_string("guard", @guard, tran, info)
        @item = translate_string("item", @item, tran, info)
        @equip = translate_string("equip", @equip, tran, info)
        @status = translate_string("status", @status, tran, info)
        @save = translate_string("save", @save, tran, info)
        @game_end = translate_string("game_end", @game_end, tran, info)
        @fight = translate_string("fight", @fight, tran, info)
        @escape = translate_string("escape", @escape, tran, info)
        @new_game = translate_string("new_game", @new_game, tran, info)
        @continue = translate_string("continue", @continue, tran, info)
        @shutdown = translate_string("shutdown", @shutdown, tran, info)
        @to_title = translate_string("to_title", @to_title, tran, info)
        @cancel = translate_string("cancel", @cancel, tran, info)
        @gold = translate_string("gold", @gold, tran, info)
        self
      end

      def update(tran, info)
        tran = update_string("level", @level, tran, info)
        tran = update_string("level_a", @level_a, tran, info)
        tran = update_string("hp", @hp, tran, info)
        tran = update_string("hp_a", @hp_a, tran, info)
        tran = update_string("mp", @mp, tran, info)
        tran = update_string("mp_a", @mp_a, tran, info)
        tran = update_string("atk", @atk, tran, info)
        tran = update_string("def", @def, tran, info)
        tran = update_string("spi", @spi, tran, info)
        tran = update_string("agi", @agi, tran, info)
        tran = update_string("weapon", @weapon, tran, info)
        tran = update_string("armor1", @armor1, tran, info)
        tran = update_string("armor2", @armor2, tran, info)
        tran = update_string("armor3", @armor3, tran, info)
        tran = update_string("armor4", @armor4, tran, info)
        tran = update_string("weapon1", @weapon1, tran, info)
        tran = update_string("weapon2", @weapon2, tran, info)
        tran = update_string("attack", @attack, tran, info)
        tran = update_string("skill", @skill, tran, info)
        tran = update_string("guard", @guard, tran, info)
        tran = update_string("item", @item, tran, info)
        tran = update_string("equip", @equip, tran, info)
        tran = update_string("status", @status, tran, info)
        tran = update_string("save", @save, tran, info)
        tran = update_string("game_end", @game_end, tran, info)
        tran = update_string("fight", @fight, tran, info)
        tran = update_string("escape", @escape, tran, info)
        tran = update_string("new_game", @new_game, tran, info)
        tran = update_string("continue", @continue, tran, info)
        tran = update_string("shutdown", @shutdown, tran, info)
        tran = update_string("to_title", @to_title, tran, info)
        tran = update_string("cancel", @cancel, tran, info)
        update_string("gold", @gold, tran, info)
      end
    end

    class TestBattler
      def initialize
        @actor_id = 1
        @level = 1
        @weapon_id = 0
        @armor1_id = 0
        @armor2_id = 0
        @armor3_id = 0
        @armor4_id = 0
      end
    end
  end

  class AudioFile
    def initialize(name = "", volume = 100, pitch = 100)
      @name = name
      @pitch = pitch
      @volume = volume
    end
  end

  class BGM < AudioFile
    @@last = BGM.new
    def play
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
      else
        Audio.bgm_play("Audio/BGM/" + @name, @volume, @pitch)
        @@last = self
      end
    end
    def self.stop
      Audio.bgm_stop
      @@last = BGM.new
    end
    def self.fade(time)
      Audio.bgm_fade(time)
      @@last = BGM.new
    end
    def self.last
      @@last
    end
  end

  class BGS < AudioFile
    @@last = BGS.new
    def play
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
      else
        Audio.bgs_play("Audio/BGS/" + @name, @volume, @pitch)
        @@last = self
      end
    end
    def self.stop
      Audio.bgs_stop
      @@last = BGS.new
    end
    def self.fade(time)
      Audio.bgs_fade(time)
      @@last = BGS.new
    end
    def self.last
      @@last
    end
  end

  class ME < AudioFile
    def play
      if @name.empty?
        Audio.me_stop
      else
        Audio.me_play("Audio/ME/" + @name, @volume, @pitch)
      end
    end
    def self.stop
      Audio.me_stop
    end
    def self.fade(time)
      Audio.me_fade(time)
    end
  end

  class SE < AudioFile
    def play
      unless @name.empty?
        Audio.se_play("Audio/SE/" + @name, @volume, @pitch)
      end
    end
    def self.stop
      Audio.se_stop
    end
  end
end

# Table of what type of event command the event codes corresponds to.
EVENT_COMMAND_CODES = {
  0 => ["Empty", false],
  101 => ["Show Text Attributes", false],
  102 => ["Show Choices", true],
  103 => ["Input Number", false],
  108 => ["Comment", true],
  111 => ["Conditional Branch", false],
  112 => ["Loop", false],
  113 => ["Break Loop", false],
  115 => ["Exit Event Processing"],
  117 => ["Call Common Event", false],
  118 => ["Label", false],
  119 => ["Jump to Label", false],
  121 => ["Control Switches", false],
  122 => ["Control Variables", false],
  123 => ["Control Self Switch", false],
  124 => ["Control Timer", false],
  125 => ["Change Gold", false],
  126 => ["Change Items", false],
  127 => ["Change Weapons", false],
  128 => ["Change Armor", false],
  129 => ["Change Party Member", false],
  132 => ["Change Battle BGM", false],
  133 => ["Change Battle End ME", false],
  134 => ["Change Save Access", false],
  135 => ["Change Menu Access", false],
  136 => ["Change Encounter", false],
  201 => ["Transfer Player", false],
  202 => ["Set Vehicle Location", false],
  203 => ["Set Event Location", false],
  204 => ["Scroll Map", false],
  205 => ["Set Move Route", false],
  206 => ["Get on/off Vehicle", false],
  211 => ["Change Transparency", false],
  212 => ["Show Animation", false],
  213 => ["Shot Balloon Icon", false],
  214 => ["Erase Event", false],
  221 => ["Fadeout Screen", false],
  222 => ["Fadein Screen", false],
  223 => ["Tint Screen", false],
  224 => ["Flash Screen", false],
  225 => ["Shake Screen", false],
  230 => ["Wait", false],
  231 => ["Show Picture", false],
  232 => ["Move Picture", false],
  233 => ["Rotate Picture", false],
  234 => ["Tint Picture", false],
  235 => ["Erase Picture", false],
  236 => ["Set Weather Effects", false],
  241 => ["Play BGM", false],
  242 => ["Fadeout BGM", false],
  245 => ["Play BGS", false],
  246 => ["Fadeout BGS", false],
  249 => ["Play ME", false],
  250 => ["Play SE", false],
  251 => ["Stop SE", false],
  301 => ["Battle Processing", false],
  302 => ["Shop Processing", false],
  303 => ["Name Input Processing", false],
  311 => ["Change HP", false],
  312 => ["Change MP", false],
  313 => ["Change State", false],
  314 => ["Recover All", false],
  315 => ["Change EXP", false],
  316 => ["Change Level", false],
  317 => ["Change Parameters", false],
  318 => ["Change Skills", false],
  319 => ["Change Equipment", false],
  320 => ["Change Actor Name", true],
  321 => ["Change Actor Class", false],
  322 => ["Change Actor Graphic", false],
  323 => ["Change Vehicle Graphic", false],
  331 => ["Change Enemy HP", false],
  332 => ["Change Enemy MP", false],
  333 => ["Change Enemy State", false],
  334 => ["Enemy Recover All", false],
  335 => ["Enemy Appear", false],
  336 => ["Enemy Transform", false],
  337 => ["Show Battle Animation", false],
  339 => ["Force Action", false],
  340 => ["Abort Battle", false],
  351 => ["Open Menu Screen", false],
  352 => ["Open Save Screen", false],
  353 => ["Game Over", false],
  354 => ["Return to Title Screen", false],
  355 => ["Script", true],
  401 => ["Show Text", true],
  402 => ["When", false],
  403 => ["When Cancel", false],
  404 => ["Choices End", false],
  408 => ["Comment More", true],
  411 => ["Else", false],
  412 => ["Branch End", false],
  413 => ["Repeat Above", false],
  505 => ["Move Command", false],
  601 => ["If Win", false],
  602 => ["If Escape", false],
  603 => ["If Lose", false],
  604 => ["Battle Processing End", false],
  605 => ["Shop Item", false],
  655 => ["Script More", true]
}

# Given an event code, returns the type of the event and whether it can contain
# something translatable.
def get_event_type(code)
  type = EVENT_COMMAND_CODES[code]
  type.nil? ? [code, false] : type
end

def merge_event_commands(commands)
  merged_cmds = []
  i = 0

  while i < commands.length
    cmd = commands[i]

    match_code = case cmd.code
      when 401 then 401  # Show Text
      when 108 then 408  # Comment
      when 355 then 655  # Script
      else 0
    end

    if match_code != 0 and commands[i+1].code == match_code
      params = cmd.parameters

      while commands[i+1].code == match_code
        i += 1
        params.concat commands[i].parameters
      end

      cmd = RPG::EventCommand.new(cmd.code, cmd.indent, params)
    end
      
    merged_cmds.push cmd
    i += 1
  end

  merged_cmds
end

def split_event_commands(commands)
  split_cmds = []

  commands.each do |cmd|
    match_code = case cmd.code
      when 401 then 401
      when 108 then 408
      when 355 then 655
      else 0
    end

    if match_code != 0 and cmd.parameters.length > 1
      code = cmd.code

      cmd.parameters.each do |p|
        split_cmds.push RPG::EventCommand.new(code, cmd.indent, [p])
        code = match_code
      end
    else
      split_cmds.push cmd
    end
  end  

  split_cmds
end
