require "docomoru"

module DocomoHelper
  class Docomo
    attr_accessor :client

    def initialize
      @client = Docomoru::Client.new(apy_key: Settings.account.docomo.apy_key)
    end

    def chatting(uid, msg)
      info = LastDialogueInfo.where(uid: uid).last

      if info.blank?
        res =  client.dialogue(msg)
        info = LastDialogueInfo.new(uid: uid, mode: res.body["mode"], context: res.body["context"])
      else
        res =  client.dialogue(msg, info.mode, info.context)
        info.mode    = res.body["mode"]
        info.context = res.body["context"]
      end
      info.save!
      res.body["utt"]
    end
  end
end
