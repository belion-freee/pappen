module ApplicationHelper

  def m(money)
    money = 0 if money.blank?
    "¥ #{money.to_s(:delimited)}"
  end

  def l(date)
    return "日付未定" if date.blank?
    date.strftime("%Y年%m月%d日")
  end
end
