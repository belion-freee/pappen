class Docomo::Chat < Docomo::Base
  def chat(uid, msg)
    info = LastDialogueInfo.where(uid: uid).last

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
