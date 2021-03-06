module DebugHelpers
  def actors(type=nil)
    matching_actors = []
    ObjectSpace.each_object do |obj|
      if obj.class == Actor 
        if type.nil? || obj.actor_type == type
          matching_actors << obj 
        end
      end
    end
    log "found #{matching_actors.size} actors"
    matching_actors
  end

  def current_stage
    game.stage_manager.current_stage
  end

  def reload_behavior(behavior_name)
    behavior = behavior_name.to_sym
    log "reloading behavior: [#{behavior}]"
    load "behaviors/#{behavior}.rb"

    actors.each do |act|

      if act.has_behavior?(behavior)
        behaviors = act.instance_variable_get('@behaviors')
        beh_opts = behaviors[behavior].opts

        factory = act.this_object_context[:behavior_factory]
        act.remove_behavior behavior

        factory.add_behavior(act, behavior, beh_opts)
      end
    end
  end

  def load_actor(actor_type)
    type = actor_type.to_sym
    log "loading actor: [#{type}]"
    load "actors/#{type}.rb"
  end

  module_function :reload_behavior, :actors, :load_actor

end
