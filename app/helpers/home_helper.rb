module HomeHelper
  include ApplicationHelper

  def t_toll(r)
    "#{r.to_i.to_s(:delimited)}円"
  end

  def t_time(r)
    h, m = r.to_i.divmod(60)
    d, h = h > 24 ? h.divmod(24) : 0, h
    ds = "#{d}日" unless d.zero?
    hs = "#{h}時間" unless h.zero?
    ms = "#{m}分" unless m.zero?
    "#{ds}#{hs}#{ms}"
  end

  def t_len(r)
    "#{r}km"
  end

  def to_arr(r)
    r = [r] unless r.is_a?(Array)
    r
  end
end
