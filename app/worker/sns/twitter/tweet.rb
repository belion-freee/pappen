class Sns::Twitter::Tweet < Sns::Twitter::Base
  def tweet(content)
    client.update(content)
  end

  def random_tweet(category)
    maxims = Maxim.where(category: category)
    maxim = choose_maxim(maxims)

    unless maxim.last_maxim_infos.count.zero?
      # get the top ten of maxims tweeted
      top_maxim_ids = LastMaximInfo.group(:maxim_id).count(:maxim_id).sort {|(_, v1), (_, v2)| v2 <=> v1 }.take(10).map(&:first)

      # roop max 30 times
      30.times do
        break unless top_maxim_ids.include?(maxim.id)
        maxim = choose_maxim(maxims)
      end
    end

    tweet format_tweet(maxim)

    LastMaximInfo.create(maxim_id: maxim.id)
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

    def choose_maxim(maxims)
      maxims.offset(rand(maxims.count)).first
    end
end
