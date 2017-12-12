class RustController < ApplicationController

  skip_before_filter :check_if_login_required
  layout false

  def index
    @timeline = Player.where(nil)
    if params[:player]
      @timeline = @timeline.where("name ilike ?", "%#{params[:player]}%")
    end
    wipes = [
      { from: '2017-09-07 18:00:00', to: '2017-10-05 18:00:00' },
      { from: '2017-10-05 18:00:00', to: '2017-11-02 22:13:00' },
      { from: '2017-11-02 22:13:00', to: '2017-12-07 18:00:00' },
      { from: '2017-12-07 18:00:00', to: '2018-01-04 18:00:00' }
    ]
    wipe = (wipes[params[:wipe].to_i] if params[:wipe].present?) rescue nil
    wipe ||= wipes.last

    @timeline = @timeline.where(login: (wipe[:from])..(wipe[:to]))
    @timeline = @timeline.collect {|player|
      [player.name.gsub(/"/,''), player.login.to_s, player.last_seen.to_s || Time.now.to_s]
    }
    @timeline = @timeline.sort {|a,b| a[0].casecmp(b[0]) }.collect { |entry|
      "[\"#{entry[0]}\", new Date(\"#{entry[1].gsub(/ UTC/,'Z')}\"), new Date(\"#{entry[2].gsub(/ UTC/,'Z')}\")]"
    }.join(",\n")
    @ticks = "["
    from = Time.parse(wipe[:from]).beginning_of_day
    while from < wipe[:to] and from < Time.now do
      @ticks += "new Date(#{from.to_f * 1000}),"
      from += 1.day
    end
    @ticks.gsub!(/,\Z/,'')
    @ticks += "]"
  end

end
