require "docomoru"

module DocomoHelper
  include ApplicationHelper

  class Docomo
    include DocomoHelper

    attr_accessor :client

    def initialize
      @client = Docomoru::Client.new(api_key: env(:docomo_api_key))
    end

    def chatting(uid, msg)
      info = LastDialogueInfo.where(uid: uid)

      if info.blank?
        res =  client.create_dialogue(msg)
        info = LastDialogueInfo.new(uid: uid, mode: res.body["mode"], context: res.body["context"])
      else
        res =  client.create_dialogue(msg, { mode: info.mode, context: info.context })
        info.mode    = res.body["mode"]
        info.context = res.body["context"]
      end
      info.save!
      res.body["utt"]
    end
  end
end
