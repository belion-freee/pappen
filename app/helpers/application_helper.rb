module ApplicationHelper
  def m(money)
    money = 0 if money.blank?
    "¥ #{money.to_s(:delimited)}"
  end

  def l(date)
    return "日付未定" if date.blank?
    date.strftime("%Y年%m月%d日")
  end

  def h(count)
    count = 0 if count.blank?
    "#{count}人"
  end

  def date_options
    (2019..2023).map {|year|
      (1..12).map {|month|
        [format("%02d年%02d月", year, month), format("%02d%02d", year, month)]
      }.to_h
    }.inject(:merge)
  end

  def tooltip_tag(content)
    return if content.blank?
    image_pack_tag "img/help.svg", width: 16, height: 16, data: { "tippy-content" => content }, style: "display: inline-block"
  end
end
