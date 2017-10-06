class RustController < ApplicationController

  skip_before_filter :check_if_login_required
  layout false

  def index
    @timeline = Player.where(nil)
    case params[:wipe]
    when '0'
      @timeline = @timeline.where("login < '2017-10-05 18:00:00' or last_seen < '2017-10-05 18:00:00'")
    else
      @timeline = @timeline.where("login >= '2017-10-05 18:00:00' or last_seen >= '2017-10-05 18:00:00'")
    end
    @timeline = @timeline.all
    start_tick = @timeline.first.login
    end_tick   = @timeline.last.last_seen

    @timeline = @timeline.collect {|player|
      [player.name, player.login.to_s, player.last_seen.to_s || Time.now.to_s]
    }
    @timeline = @timeline.sort {|a,b| a[0].casecmp(b[0]) }.collect { |entry|
      "[\"#{entry[0]}\", new Date(\"#{entry[1].gsub(/ UTC/,'Z')}\"), new Date(\"#{entry[2].gsub(/ UTC/,'Z')}\")]"
    }.join(",\n")
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
