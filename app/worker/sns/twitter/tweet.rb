class Sns::Twitter::Tweet < Sns::Twitter::Base
  def tweet(content)
    client.update(content)
  end

  def random_tweet(category)
    maxims = Maxim.where(category: category)
    maxim = maxims.offset(rand(maxims.count)).first
    tweet format_tweet(maxim)
  end

  private

    def format_tweet(maxim)
      raise "このカテゴリーでの名言が見つかりませんでした！" if maxim.blank?
      content = <<-BODY.strip_heredoc
        "#{maxim.remark}"
        - #{maxim.author}
      BODY
      content << "出典:#{maxim.source}" if maxim.source.present?
      content << maxim.url if maxim.url.present?
      content
    end
end
