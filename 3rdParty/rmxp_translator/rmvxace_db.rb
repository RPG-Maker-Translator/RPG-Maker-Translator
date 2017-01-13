require_relative 'tran_util'
require_relative 'common_db'

# This file contains all the RPG data structures for RPG Maker VX Ace.

module RPG
  class BaseItem
    def initialize
      @id = 0
      @name = ''
      @icon_index = 0
      @description = ''
      @features = []
      @note = ''
    end

    class Feature
      def initialize(code = 0, data_id = 0, value = 0)
        @code = code
        @data_id = data_id
        @value = value
      end
    end
  end

  class Actor < BaseItem
    def initialize
      super
      @nickname = ''
      @class_id = 1
      @initial_level = 1
      @max_level = 99
      @character_name = ''
      @character_index = 0
      @face_name = ''
      @face_index = 0
      @equips = [0,0,0,0,0]
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'nickname' => dump_string(@nickname),
        'description' => dump_string(@description),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @nickname = translate_string("nickname", @nickname, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("nickname", @nickname, tran, info)
      tran = update_string("description", @description, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class Class < BaseItem
    def initialize
      super
      @exp_params = [30,20,30,30]
      @params = Table.new(8,100)
      (1..99).each do |i|
        @params[0,i] = 400+i*50
        @params[1,i] = 80+i*10
        (2..5).each {|j| @params[j,i] = 15+i*5/4 }
        (6..7).each {|j| @params[j,i] = 30+i*5/2 }
      end
      @learnings = []
      @features.push(RPG::BaseItem::Feature.new(23, 0, 1))
      @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
      @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
      @features.push(RPG::BaseItem::Feature.new(22, 2, 0.04))
      @features.push(RPG::BaseItem::Feature.new(41, 1))
      @features.push(RPG::BaseItem::Feature.new(51, 1))
      @features.push(RPG::BaseItem::Feature.new(52, 1))
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'note' => dump_string(@note),
        'learnings' => @learnings
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
      @learnings = translate_list("learnings", @learnings, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      tran = update_string("note", @note, tran, info)
      update_list("learnings", @learnings, tran, info)
    end

    class Learning
      def initialize
        @level = 1
        @skill_id = 1
        @note = ''
      end

      def to_json(*a)
        {
          'json_class' => self.class.name,
          'note' => dump_string(@note)
        }.to_json(*a)
      end

      def translate(tran, info)
        @note = translate_string("note", @note, tran, info)
        self
      end

      def update(tran, info)
        update_string("note", @note, tran, info)
      end
    end
  end

  class UsableItem < BaseItem
    def initialize
      super
      @scope = 0
      @occasion = 0
      @speed = 0
      @success_rate = 100
      @repeats = 1
      @tp_gain = 0
      @hit_type = 0
      @animation_id = 0
      @damage = RPG::UsableItem::Damage.new
      @effects = []
    end

    class Damage
      def initialize
        @type = 0
        @element_id = 0
        @formula = '0'
        @variance = 20
        @critical = false
      end
    end

    class Effect
      def initialize(code = 0, data_id = 0, value1 = 0, value2 = 0)
        @code = code
        @data_id = data_id
        @value1 = value1
        @value2 = value2
      end
    end
  end

  class Skill < UsableItem
    def initialize
      super
      @scope = 1
      @stype_id = 1
      @mp_cost = 0
      @tp_cost = 0
      @message1 = ''
      @message2 = ''
      @required_wtype_id1 = 0
      @required_wtype_id2 = 0
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'message1' => dump_string(@message1),
        'message2' => dump_string(@message2),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @message1 = translate_string("message1", @message1, tran, info)
      @message2 = translate_string("message2", @message2, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      tran = update_string("message1", @message1, tran, info)
      tran = update_string("message2", @message2, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class Item < UsableItem
    def initialize
      super
      @scope = 7
      @itype_id = 1
      @price = 0
      @consumable = true
    end
    def key_item?
      @itype_id == 2
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class EquipItem < BaseItem
    def initialize
      super
      @price = 0
      @etype_id = 0
      @params = [0] * 8
    end
  end

  class Weapon < EquipItem
    def initialize
      super
      @wtype_id = 0
      @animation_id = 0
      @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
      @features.push(RPG::BaseItem::Feature.new(22, 0, 0))
    end
    def performance
      params[2] + params[4] + params.inject(0) {|r, v| r += v }
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class Armor < EquipItem
    def initialize
      super
      @atype_id = 0
      @etype_id = 1
      @features.push(RPG::BaseItem::Feature.new(22, 1, 0))
    end
    def performance
      params[3] + params[5] + params.inject(0) {|r, v| r += v }
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      update_string("note", @note, tran, info)
    end
  end

  class Enemy < BaseItem
    def initialize
      super
      @battler_name = ''
      @battler_hue = 0
      @params = [100,0,10,10,10,10,10,10]
      @exp = 0
      @gold = 0
      @drop_items = Array.new(3) { RPG::Enemy::DropItem.new }
      @actions = [RPG::Enemy::Action.new]
      @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
      @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
      @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'name' => dump_string(@name),
        'description' => dump_string(@description),
        'note' => dump_string(@note)
      }.to_json(*a)
    end

    def translate(tran, info)
      @name = translate_string("name", @name, tran, info)
      @description = translate_string("description", @description, tran, info)
      @note = translate_string("note", @note, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("name", @name, tran, info)
      tran = update_string("description", @description, tran, info)
      update_string("note", @note, tran, info)
    end

    class DropItem
      def initialize
        @kind = 0
        @data_id = 1
        @denominator = 1
      end
    end

    class Action
      def initialize
        @skill_id = 1
        @condition_type = 0
        @condition_param1 = 0
        @condition_param2 = 0
        @rating = 5
      end
    end
  end

  class State < BaseItem
    def initialize
      super
      @restriction = 0
      @priority = 50
      @remove_at_battle_end = false
      @remove_by_restriction = false
      @auto_removal_timing = 0
      @min_turns = 1
      @max_turns = 1
      @remove_by_damage = false
      @chance_by_damage = 100
      @remove_by_walking = false
      @steps_to_remove = 100
      @message1 = ''
      @message2 = ''
      @message3 = ''
      @message4 = ''
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

  class Map
    def initialize(width, height)
      @display_name = ''
      @tileset_id = 1
      @width = width
      @height = height
      @scroll_type = 0
      @specify_battleback = false
      @battleback_floor_name = ''
      @battleback_wall_name = ''
      @autoplay_bgm = false
      @bgm = RPG::BGM.new
      @autoplay_bgs = false
      @bgs = RPG::BGS.new('', 80)
      @disable_dashing = false
      @encounter_list = []
      @encounter_step = 30
      @parallax_name = ''
      @parallax_loop_x = false
      @parallax_loop_y = false
      @parallax_sx = 0
      @parallax_sy = 0
      @parallax_show = false
      @note = ''
      @data = Table.new(width, height, 4)
      @events = {}
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'display_name' => dump_string(@display_name),
        'note' => dump_string(@note),
        'events' => dump_array(@events.sort),
      }.to_json(*a)
    end

    def translate(tran, info)
      @display_name = translate_string("display_name", @display_name, tran, info)
      @note = translate_string("note", @note, tran, info)
      @events = translate_hash("events", @events, tran, info)
      self
    end

    def update(tran, info)
      tran = update_string("display_name", @display_name, tran, info)
      tran = update_string("note", @note, tran, info)
      update_hash("events", @events, tran, info)
    end

    class Encounter
      def initialize
        @troop_id = 1
        @weight = 10
        @region_set = []
      end
    end
  end

  class MapInfo
    def initialize
      @name = ''
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

  class Event
    def initialize(x, y)
      @id = 0
      @name = ''
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
          @self_switch_ch = 'A'
          @item_id = 1
          @actor_id = 1
        end
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
          @self_switch_ch = 'A'
          @item_id = 1
          @actor_id = 1
        end
      end

      class RPG::Event::Page::Graphic
        def initialize
          @tile_id = 0
          @character_name = ''
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
      (type, is_text) = get_event_type(@code, @parameters)

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
      (_, is_text) = get_event_type(@code, @parameters)

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

  class Troop
    def initialize
      @id = 0
      @name = ''
      @members = []
      @pages = [RPG::Troop::Page.new]
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

  class Animation
    def initialize
      @id = 0
      @name = ''
      @animation1_name = ''
      @animation1_hue = 0
      @animation2_name = ''
      @animation2_hue = 0
      @position = 1
      @frame_max = 1
      @frames = [RPG::Animation::Frame.new]
      @timings = []
    end
    def to_screen?
      @position == 3
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
        @se = RPG::SE.new('', 80)
        @flash_scope = 0
        @flash_color = Color.new(255,255,255,255)
        @flash_duration = 5
      end
    end
  end

  class Tileset
    def initialize
      @id = 0
      @mode = 1
      @name = ''
      @tileset_names = Array.new(9).collect{''}
      @flags = Table.new(8192)
      @flags[0] = 0x0010
      (2048..2815).each {|i| @flags[i] = 0x000F}
      (4352..8191).each {|i| @flags[i] = 0x000F}
      @note = ''
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
      @name = ''
      @trigger = 0
      @switch_id = 1
      @list = [RPG::EventCommand.new]
    end
    def autorun?
      @trigger == 1
    end
    def parallel?
      @trigger == 2
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
      @list = merge_event_commands(@list)
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
      @game_title = ''
      @version_id = 0
      @japanese = true
      @party_members = [1]
      @currency_unit = ''
      @elements = [nil, '']
      @skill_types = [nil, '']
      @weapon_types = [nil, '']
      @armor_types = [nil, '']
      @switches = [nil, '']
      @variables = [nil, '']
      @boat = RPG::System::Vehicle.new
      @ship = RPG::System::Vehicle.new
      @airship = RPG::System::Vehicle.new
      @title1_name = ''
      @title2_name = ''
      @opt_draw_title = true
      @opt_use_midi = false
      @opt_transparent = false
      @opt_followers = true
      @opt_slip_death = false
      @opt_floor_death = false
      @opt_display_tp = true
      @opt_extra_exp = false
      @window_tone = Tone.new(0,0,0)
      @title_bgm = RPG::BGM.new
      @battle_bgm = RPG::BGM.new
      @battle_end_me = RPG::ME.new
      @gameover_me = RPG::ME.new
      @sounds = Array.new(24) { RPG::SE.new }
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @terms = RPG::System::Terms.new
      @battleback1_name = ''
      @battleback2_name = ''
      @battler_name = ''
      @battler_hue = 0
      @edit_map_id = 1
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'game_title' => dump_string(@game_title),
        'currency_unit' => dump_string(@currency_unit),
        'elements' => dump_array(@elements),
        'skill_types' => dump_array(@skill_types),
        'weapon_types' => dump_array(@weapon_types),
        'armor_types' => dump_array(@armor_types),
        'terms' => @terms
      }.to_json(*a)
    end
    
    def translate(tran, info)
      @game_title = translate_string("game_title", @game_title, tran, info)
      @currency_unit = translate_string("currency_unit", @currency_unit, tran, info)
      @elements = translate_array("elements", @elements, tran, info)
      @skill_types = translate_array("skill_types", @skill_types, tran, info)
      @weapon_types = translate_array("weapon_types", @weapon_types, tran, info)
      @armor_types = translate_array("armor_types", @armor_types, tran, info)
      @terms = @terms.translate(tran["terms"], info.add("terms"))
      self
    end

    def update(tran, info)
      tran = update_string("game_title", @game_title, tran, info)
      tran = update_string("currency_unit", @currency_unit, tran, info)
      tran = update_array("elements", @elements, tran, info)
      tran = update_array("skill_types", @skill_types, tran, info)
      tran = update_array("weapon_types", @weapon_types, tran, info)
      tran = update_array("armor_types", @armor_types, tran, info)
      tran["terms"] = @terms.update(tran["terms"], info.add("terms"))
      tran
    end

    class Vehicle
      def initialize
        @character_name = ''
        @character_index = 0
        @bgm = RPG::BGM.new
        @start_map_id = 0
        @start_x = 0
        @start_y = 0
      end
    end

    class Terms
      def initialize
        @basic = Array.new(8) {''}
        @params = Array.new(8) {''}
        @etypes = Array.new(5) {''}
        @commands = Array.new(23) {''}
      end

      def to_json(*a)
        {
          'json_class' => self.class.name,
          'basic' => dump_array(@basic),
          'parameters' => dump_array(@params),
          'equipment types' => dump_array(@etypes),
          'commands' => dump_array(@commands)
        }.to_json(*a)
      end

      def translate(tran, info)
        @basic = translate_array("basic", @basic, tran, info)
        @params = translate_array("parameters", @params, tran, info)
        @etypes = translate_array("equipment types", @etypes, tran, info)
        @commands = translate_array("commands", @commands, tran, info)
        self
      end

      def update(tran, info)
        tran = update_array("basic", @basic, tran, info)
        tran = update_array("parameters", @params, tran, info)
        tran = update_array("equipment types", @etypes, tran, info)
        update_array("commands", @commands, tran, info)
      end
    end

    class TestBattler
      def initialize
        @actor_id = 1
        @level = 1
        @equips = [0,0,0,0,0]
      end
    end
  end

  class AudioFile
    def initialize(name = '', volume = 100, pitch = 100)
      @name = name
      @volume = volume
      @pitch = pitch
    end
  end

  class BGM < AudioFile
    @@last = BGM.new
    def play(pos = 0)
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
      else
        Audio.bgm_play('Audio/BGM/' + @name, @volume, @pitch, pos)
        @@last = self.clone
      end
    end
    def replay
      play(@pos)
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
      @@last.pos = Audio.bgm_pos
      @@last
    end
  end

  class BGS < AudioFile
    @@last = BGS.new
    def play(pos = 0)
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
      else
        Audio.bgs_play('Audio/BGS/' + @name, @volume, @pitch, pos)
        @@last = self.clone
      end
    end
    def replay
      play(@pos)
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
      @@last.pos = Audio.bgs_pos
      @@last
    end
  end

  class ME < AudioFile
    def play
      if @name.empty?
        Audio.me_stop
      else
        Audio.me_play('Audio/ME/' + @name, @volume, @pitch)
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
        Audio.se_play('Audio/SE/' + @name, @volume, @pitch)
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
  104 => ["Select Key Item", false],
  105 => ["Show Scrolling Text Attributes", false],
  108 => ["Comment", true],
  111 => ["Conditional Branch", false],
  112 => ["Loop", false],
  113 => ["Break Loop", false],
  115 => ["Exit Event Processing", false],
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
  137 => ["Change Formation Access", false],
  138 => ["Change Window Color", false],
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
  216 => ["Change Player Followers", false],
  217 => ["Gather Followers", false],
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
  243 => ["Save BGM", false],
  244 => ["Replay BGM", false],
  245 => ["Play BGS", false],
  246 => ["Fadeout BGS", false],
  249 => ["Play ME", false],
  250 => ["Play SE", false],
  251 => ["Stop SE", false],
  261 => ["Play Movie", false],
  281 => ["Change Map Display", false],
  282 => ["Change Tileset", false],
  283 => ["Change Battle Back", false],
  284 => ["Change Parallax Back", false],
  285 => ["Get Location Info", false],
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
  324 => ["Change Actor Nickname", true],
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
  405 => ["Show Scrolling Text", true],
  408 => ["Comment More", true],
  411 => ["Else", false],
  412 => ["Branch End", false],
  413 => ["Repeat Above", false],
  601 => ["If Win", false],
  602 => ["If Escape", false],
  603 => ["If Lose", false],
  604 => ["Battle Processing End", false],
  605 => ["Shop Item", false],
  655 => ["Script More", true]
}

# Given an event code, returns the type of the event and whether it can contain
# something translatable.
def get_event_type(code, params)
  type = EVENT_COMMAND_CODES[code]

  # Control variables can be assigned scripts:
  if code == 122 and params[3] == 4 then
    type[1] = true
  end

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
