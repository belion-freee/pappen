class Sns::Twitter::Tweet < Sns::Twitter::Base
  def tweet(content)
    client.update(content)
  end
end
