class RustController < ApplicationController

  skip_before_filter :check_if_login_required
  layout false

  def index
    @timeline = []
    @timeline = Player.all.collect {|player|
      [player.name, player.login.to_s, player.logout.to_s || Time.now.to_s]
    }
    @timeline = @timeline.sort {|a,b| a[0].casecmp(b[0]) }.collect { |entry|
      "[\"#{entry[0]}\", new Date(\"#{entry[1].gsub(/ UTC/,'Z')}\"), new Date(\"#{entry[2].gsub(/ UTC/,'Z')}\")]"
    }.join(",\n")
    start_tick = Player.first.login
    end_tick   = Player.last.last_seen
    diff_ticks = (end_tick - start_tick).to_i / 8.0
    @ticks = "["
    8.times do
      @ticks += "new Date(\"#{start_tick.to_s.gsub(/ UTC/,'Z')}\"),"
      start_tick += diff_ticks
    end
    @ticks.gsub!(/,\Z/,'')
    @ticks += "]"
  end

end
