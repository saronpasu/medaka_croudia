#-*- encoding: utf-8 -*-
$LOAD_PATH << 'lib'

require 'medaka'

medaka = Medaka.new

mentions = medaka.get_mentions

mentions.reverse.each do |status|

  # 既に返信済みであるか、相手がBOTの場合は次を処理する
  if medaka.get_status_replyed_me?(status) || medaka.is_ignore_id?(status.user.screen_name) then
    next
  end

  # p :reply
  text = status.text
  author_screen_name = status.user.name
  author_name = status.user.screen_name
  in_reply_to_status_id = status.id

  text.gsub!(/\n/, "")
  text.gsub!(/SP/, "")
  text.gsub!(/@.+ /, "")
  text = medaka.sixamo.talk(text)
  text.gsub!(Medaka::MY_NAME, author_screen_name)
  text = "@"+author_name+" "+text
  params = {:in_reply_to_status_id => in_reply_to_status_id}

  p [author_name, author_screen_name]
  p [text, params]
  #medaka.update(text, params)
  break

end

#p :end

