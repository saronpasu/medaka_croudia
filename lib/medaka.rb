#-*- encoding: utf-8 -*-
require 'sixamo'
require 'croudia'
require 'yaml'
require 'openssl'

# SSL証明書 一時的措置 直ったのでコメントアウト。
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

require 'mechanize'

class Medaka
   MY_ACCOUNT_ID = 'medaka'
   MY_NAME = /(medaka|めだか|saronpasu|サロンパス|サロ|(めだ|メダ)(か|ちょん))/
   CONFIG_FILE = 'config.yaml'
   IGNORE_IDS_FILE = 'ignore_ids.yaml'
   DICT = 'dict'
   LOGIN_URL = 'https://croudia.com/'
   BASE_URL = LOGIN_URL

   attr_accessor(
     :sixamo,
     :croudia,
     :config,
     :ignore_ids,
     :access_token,
     :agent
   )

  def load_ignore_ids
    result = nil
    open(IGNORE_IDS_FILE, 'r'){|f|result = YAML::load(f.read)}
    return result
  end

  def load_config
    result = nil
    open(CONFIG_FILE, 'r'){|f|result = YAML::load(f.read)}
    return result
  end

  def generate_auth_url
    "https://api.croudia.com/oauth/authorize?response_type=code&client_id="+@config[:client_id]
  end

  def get_auth_key
    login_url = LOGIN_URL
    @agent ||= Mechanize.new
    user_id = @config[:user_id]
    password = @config[:password]
    
    login_page = @agent.get(login_url)

    login_form = login_page.forms.find{|form|form.fields.find{|field|field.type.eql?("password")}}
    login_form.username = user_id
    login_form.password = password
    home = login_form.submit

    auth_url = generate_auth_url
    auth_page = @agent.get(auth_url)

    auth_form = auth_page.forms.find{|form|form.fields.find{|field|field.name.eql?("client_id")}}
    auth_button = auth_form.buttons.find{|button|button.name.eql?("accept")}
    last_page = auth_form.click_button(auth_button)

    last_url = last_page.uri.to_s
    auth_key = last_url.match(/(code=)(.+)/)[2]

    return auth_key
  end

  def initialize
    @sixamo = Sixamo.new(DICT)
    @config = load_config
    @ignore_ids = load_ignore_ids
    @croudia = Croudia::Client.new(
      client_id: @config[:client_id],
      client_secret: @config[:client_secret],
    )
    @agent = Mechanize.new
    @config[:auth_key] = get_auth_key
    @access_token = @croudia.get_access_token(@config[:auth_key])
    @croudia.instance_variable_set(:@access_token, @access_token.to_s)
  end

  def refresh_token
    new_token = @croudia.get_access_token(
      grant_type: :refresh_token,
      refresh_token: @access_token.refresh_token
    )
    @access_token = new_token
    return true
  end

  def get_home_timeline
  end

  def get_user_timeline
  end

  def get_public_timeline
    timeline = @croudia.public_timeline
    return timeline
  end

  def update(status, params = nil)
    @croudia.update(status, params)
  end

  def random_talk(source = nil)
    result = nil

    if source then
      result = @sixamo.talk(source)
    else
      result = @sixamo.talk
    end

    update(result)
    return true
  end

  def get_mentions
    mentions = @croudia.mentions
    return mentions
  end

  def get_status(status)
    status = @croudia.status(status)
    return status
  end

  def get_status_replyed_me?(status)
    status_id = status.id
    url = BASE_URL+'voices/show/'+status_id.to_s
    status_page = @agent.get(url)
    talk_elements = status_page.search("div.show_conversation")
    user_ids = talk_elements.search("div.contents/a")
    user_id = user_ids.first.attributes.first.last.value
    return user_id.match(@config[:user_id]) ? true : false
  end

  def is_ignore_id?(user_id)
    @ignore_ids.include?(user_id)
  end

  def get_favorite
  end

  def is_favorited?
  end

  def re_follow
  end

  def re_unfollow
  end

  def is_replyed?
  end

  def reply_to
  end

  def add_favorite
  end

  def inject_string
  end
end

