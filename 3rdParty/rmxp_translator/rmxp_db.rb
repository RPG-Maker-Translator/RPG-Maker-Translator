require_relative 'tran_util'
require_relative 'common_db'

# This file contains all the RPG data structures for RPG Maker XP

module RPG
  class Actor
    def initialize
      @id = 0
      @name = ""
      @class_id = 1
      @initial_level = 1
      @final_level = 99
      @exp_basis = 30
      @exp_inflation = 30
      @character_name = ""
      @character_hue = 0
      @battler_name = ""
      @battler_hue = 0
      @parameters = Table.new(6,100)
      for i in 1..99
        @parameters[0,i] = 500+i*50
        @parameters[1,i] = 500+i*50
        @parameters[2,i] = 50+i*5
        @parameters[3,i] = 50+i*5
        @parameters[4,i] = 50+i*5
        @parameters[5,i] = 50+i*5
      end
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @weapon_fix = false
      @armor1_fix = false
      @armor2_fix = false
      @armor3_fix = false
      @armor4_fix = false
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

  class Skill
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 1
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @sp_cost = 0
      @power = 0
      @atk_f = 0
      @eva_f = 0
      @str_f = 0
      @dex_f = 0
      @agi_f = 0
      @int_f = 100
      @hit = 100
      @pdef_f = 0
      @mdef_f = 100
      @variance = 15
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      update_string("description", @description, tran, info)
    end
  end

  class Item
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 0
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @price = 0
      @consumable = true
      @parameter_type = 0
      @parameter_points = 0
      @recover_hp_rate = 0
      @recover_hp = 0
      @recover_sp_rate = 0
      @recover_sp = 0
      @hit = 100
      @pdef_f = 0
      @mdef_f = 0
      @variance = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      update_string("description", @description, tran, info)
    end
  end

  class Weapon
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @animation1_id = 0
      @animation2_id = 0
      @price = 0
      @atk = 0
      @pdef = 0
      @mdef = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      update_string("description", @description, tran, info)
    end
  end

  class Armor
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @kind = 0
      @auto_state_id = 0
      @price = 0
      @pdef = 0
      @mdef = 0
      @eva = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @guard_element_set = []
      @guard_state_set = []
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      update_string("description", @description, tran, info)
    end
  end

  class Enemy
    def initialize
      @id = 0
      @name = ""
      @battler_name = ""
      @battler_hue = 0
      @maxhp = 500
      @maxsp = 500
      @str = 50
      @dex = 50
      @agi = 50
      @int = 50
      @atk = 100
      @pdef = 100
      @mdef = 100
      @eva = 0
      @animation1_id = 0
      @animation2_id = 0
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @exp = 0
      @gold = 0
      @item_id = 0
      @weapon_id = 0
      @armor_id = 0
      @treasure_prob = 100
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

    class Action
      def initialize
        @kind = 0
        @basic = 0
        @skill_id = 1
        @condition_turn_a = 0
        @condition_turn_b = 1
        @condition_hp = 100
        @condition_level = 1
        @condition_switch_id = 0
        @rating = 5
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
      @animation_id = 0
      @restriction = 0
      @nonresistance = false
      @zero_hp = false
      @cant_get_exp = false
      @cant_evade = false
      @slip_damage = false
      @rating = 5
      @hit_rate = 100
      @maxhp_rate = 100
      @maxsp_rate = 100
      @str_rate = 100
      @dex_rate = 100
      @agi_rate = 100
      @int_rate = 100
      @atk_rate = 100
      @pdef_rate = 100
      @mdef_rate = 100
      @eva = 0
      @battle_only = true
      @hold_turn = 0
      @auto_release_prob = 0
      @shock_release_prob = 0
      @guard_element_set = []
      @plus_state_set = []
      @minus_state_set = []
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
        @always_on_top = false
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
          @switch1_id = 1
          @switch2_id = 1
          @variable_id = 1
          @variable_value = 0
          @self_switch_ch = "A"
        end
      end

      class Graphic
        def initialize
          @tile_id = 0
          @character_name = ""
          @character_hue = 0
          @direction = 2
          @pattern = 0
          @opacity = 255
          @blend_type = 0
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

  class Map
    def initialize(width, height)
      @tileset_id = 1
      @width = width
      @height = height
      @autoplay_bgm = false
      @bgm = RPG::AudioFile.new
      @autoplay_bgs = false
      @bgs = RPG::AudioFile.new("", 80)
      @encounter_list = []
      @encounter_step = 30
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

  class MoveRoute
    def initialize
      @repeat = true
      @skippable = false
      @list = [RPG::MoveCommand.new]
    end
  end

  class MoveCommand
    def initialize(code = 0, parameters = [])
      @code = code
      @parameters = parameters
    end
  end

  class Animation
    def initialize
      @id = 0
      @name = ""
      @animation_name = ""
      @animation_hue = 0
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
        @condition = 0
      end
    end
  end

  class Tileset
    def initialize
      @id = 0
      @name = ""
      @tileset_name = ""
      @autotile_names = [""]*7
      @panorama_name = ""
      @panorama_hue = 0
      @fog_name = ""
      @fog_hue = 0
      @fog_opacity = 64
      @fog_blend_type = 0
      @fog_zoom = 200
      @fog_sx = 0
      @fog_sy = 0
      @battleback_name = ""
      @passages = Table.new(384)
      @priorities = Table.new(384)
      @priorities[0] = 5
      @terrain_tags = Table.new(384)
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
      @magic_number = 0
      @party_members = [1]
      @elements = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @windowskin_name = ""
      @title_name = ""
      @gameover_name = ""
      @battle_transition = ""
      @title_bgm = RPG::AudioFile.new
      @battle_bgm = RPG::AudioFile.new
      @battle_end_me = RPG::AudioFile.new
      @gameover_me = RPG::AudioFile.new
      @cursor_se = RPG::AudioFile.new("", 80)
      @decision_se = RPG::AudioFile.new("", 80)
      @cancel_se = RPG::AudioFile.new("", 80)
      @buzzer_se = RPG::AudioFile.new("", 80)
      @equip_se = RPG::AudioFile.new("", 80)
      @shop_se = RPG::AudioFile.new("", 80)
      @save_se = RPG::AudioFile.new("", 80)
      @load_se = RPG::AudioFile.new("", 80)
      @battle_start_se = RPG::AudioFile.new("", 80)
      @escape_se = RPG::AudioFile.new("", 80)
      @actor_collapse_se = RPG::AudioFile.new("", 80)
      @enemy_collapse_se = RPG::AudioFile.new("", 80)
      @words = RPG::System::Words.new
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @battleback_name = ""
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'elements' => dump_array(@elements),
        'switches' => dump_array(@switches),
        'variables' => dump_array(@variables),
        'words' => @words
      }.to_json(*a)
    end

    def translate(tran, info)
      @elements = translate_array("elements", @elements, tran, info)
      @switches = translate_array("switches", @switches, tran, info)
      @variables = translate_array("variables", @variables, tran, info)
      @words = @words.translate(tran["words"], info.add("words"))
      self
    end

    def update(tran, info)
      tran = update_array("elements", @elements, tran, info)
      tran = update_array("switches", @switches, tran, info)
      tran = update_array("variables", @variables, tran, info)
      tran["words"] = @words.update(tran["words"], info.add("words"))
      tran
    end
    class Words
      def initialize
        @gold = ""
        @hp = ""
        @sp = ""
        @str = ""
        @dex = ""
        @agi = ""
        @int = ""
        @atk = ""
        @pdef = ""
        @mdef = ""
        @weapon = ""
        @armor1 = ""
        @armor2 = ""
        @armor3 = ""
        @armor4 = ""
        @attack = ""
        @skill = ""
        @guard = ""
        @item = ""
        @equip = ""
      end

      def to_json(*a)
        {
          'gold' => dump_string(@gold),
          'hp' => dump_string(@hp),
          'sp' => dump_string(@sp),
          'str' => dump_string(@str),
          'dex' => dump_string(@dex),
          'agi' => dump_string(@agi),
          'int' => dump_string(@int),
          'atk' => dump_string(@atk),
          'pdef' => dump_string(@pdef),
          'mdef' => dump_string(@mdef),
          'weapon' => dump_string(@weapon),
          'armor1' => dump_string(@armor1),
          'armor2' => dump_string(@armor2),
          'armor3' => dump_string(@armor3),
          'armor4' => dump_string(@armor4),
          'attack' => dump_string(@attack),
          'skill' => dump_string(@skill),
          'guard' => dump_string(@guard),
          'item' => dump_string(@item),
          'equip' => dump_string(@equip)
        }.to_json(*a)
      end

      def translate(tran, info)
        @gold = translate_string("gold", @gold, tran, info)
        @hp = translate_string("hp", @hp, tran, info)
        @sp = translate_string("sp", @sp, tran, info)
        @str = translate_string("str", @str, tran, info)
        @dex = translate_string("dex", @dex, tran, info)
        @agi = translate_string("agi", @agi, tran, info)
        @int = translate_string("int", @int, tran, info)
        @atk = translate_string("atk", @atk, tran, info)
        @pdef = translate_string("pdef", @pdef, tran, info)
        @mdef = translate_string("mdef", @mdef, tran, info)
        @weapon = translate_string("weapon", @weapon, tran, info)
        @armor1 = translate_string("armor1", @armor1, tran, info)
        @armor2 = translate_string("armor2", @armor2, tran, info)
        @armor3 = translate_string("armor3", @armor3, tran, info)
        @armor4 = translate_string("armor4", @armor4, tran, info)
        @attack = translate_string("attack", @attack, tran, info)
        @skill = translate_string("skill", @skill, tran, info)
        @guard = translate_string("guard", @guard, tran, info)
        @item = translate_string("item", @item, tran, info)
        @equip = translate_string("equip", @equip, tran, info)
        self
      end

      def update(tran, info)
        tran = update_string("gold", @gold, tran, info)
        tran = update_string("hp", @hp, tran, info)
        tran = update_string("sp", @sp, tran, info)
        tran = update_string("str", @str, tran, info)
        tran = update_string("dex", @dex, tran, info)
        tran = update_string("agi", @agi, tran, info)
        tran = update_string("int", @int, tran, info)
        tran = update_string("atk", @atk, tran, info)
        tran = update_string("pdef", @pdef, tran, info)
        tran = update_string("mdef", @mdef, tran, info)
        tran = update_string("weapon", @weapon, tran, info)
        tran = update_string("armor1", @armor1, tran, info)
        tran = update_string("armor2", @armor2, tran, info)
        tran = update_string("armor3", @armor3, tran, info)
        tran = update_string("armor4", @armor4, tran, info)
        tran = update_string("attack", @attack, tran, info)
        tran = update_string("skill", @skill, tran, info)
        tran = update_string("guard", @guard, tran, info)
        tran = update_string("item", @item, tran, info)
        update_string("equip", @equip, tran, info)
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
      @volume = volume
      @pitch = pitch
    end
  end
end

# Table of what type of event command the event codes corresponds to.
EVENT_COMMAND_CODES = {
  0 => ["Empty", false],
  101 => ["Show Text", true],
  102 => ["Show Choices", true],
  103 => ["Input Number", false],
  104 => ["Change Text Options", false],
  105 => ["Button Input Processing", false],
  106 => ["Wait", false],
  108 => ["Comment", true],
  111 => ["Conditional Branch", false],
  112 => ["Loop", false],
  113 => ["Break Loop", false],
  115 => ["Exit Event Processing"],
  116 => ["Erase Event"],
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
  131 => ["Change Windowskin", false],
  132 => ["Change Battle BGM", false],
  132 => ["Change Battle End ME", false],
  133 => ["Change Battle End ME", false],
  134 => ["Change Save Access", false],
  135 => ["Change Menu Access", false],
  136 => ["Change Encounter", false],
  201 => ["Transfer Player", false],
  202 => ["Set Event Location", false],
  203 => ["Scroll Map", false],
  204 => ["Change Map Settings", false],
  205 => ["Change Fog Color Tone", false],
  206 => ["Change Fog Opacity", false],
  207 => ["Show Animation", false],
  208 => ["Change Transparent Flag", false],
  209 => ["Set Move Route", false],
  210 => ["Wait for Move's Completion", false],
  221 => ["Prepare for Transition", false],
  222 => ["Execute Transition", false],
  223 => ["Change Screen Color Tone", false],
  224 => ["Screen Flash", false],
  225 => ["Screen Shake", false],
  231 => ["Show Picture", false],
  232 => ["Move Picture", false],
  233 => ["Rotate Picture", false],
  234 => ["Change Picture Color Tone", false],
  235 => ["Erase Picture", false],
  236 => ["Set Weather Effects", false],
  241 => ["Play BGM", false],
  242 => ["Fade Out BGM", false],
  245 => ["Play BGS", false],
  246 => ["Fade Out BGS", false],
  247 => ["Memorize BGM/BGS", false],
  248 => ["Restore BGM/BGS", false],
  249 => ["Play ME", false],
  250 => ["Play SE", false],
  251 => ["Stop SE", false],
  301 => ["Battle Processing", false],
  302 => ["Shop Processing", false],
  303 => ["Name Input Processing", false],
  311 => ["Change HP", false],
  312 => ["Change SP", false],
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
  331 => ["Change Enemy HP", false],
  332 => ["Change Enemy SP", false],
  333 => ["Change Enemy State", false],
  334 => ["Enemy Recover All", false],
  335 => ["Enemy Appearance", false],
  336 => ["Enemy Transform", false],
  337 => ["Show Battle Animation", false],
  338 => ["Deal Damage", false],
  339 => ["Force Action", false],
  340 => ["Abort Battle", false],
  351 => ["Call Menu Screen", false],
  352 => ["Call Save Screen", false],
  353 => ["Game Over", false],
  354 => ["Return to Title Screen", false],
  355 => ["Script", true],
  401 => ["Show Text More", true],
  402 => ["When", false],
  403 => ["When Cancel", false],
  404 => ["Choices End", false],
  408 => ["Comment More", true],
  411 => ["Else", false],
  412 => ["Branch End", false],
  413 => ["Repeat Above", false],
  509 => ["Move Command", false],
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
      when 101 then 401  # Show Text
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
      when 101 then 401
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
