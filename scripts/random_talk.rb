#-*- encoding: utf-8 -*-
$LOAD_PATH << 'lib'

require 'medaka'

medaka = Medaka.new

tl = medaka.get_public_timeline

tl.reject!{|status|status.text.include?("@")}
text = tl.last.text
text.gsub!(/\n/, "")


medaka.random_talk(text)


