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
    (2018..2020).map {|year|
      (1..12).map {|month|
        "#{year}年#{month}月"
      }
    }.flatten
  end
end
