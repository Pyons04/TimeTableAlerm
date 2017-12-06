class Aguinfo

 def self.throw_tweet(t,get_no_class,get_1_class,get_2_class,get_3_class,get_4_class,get_5_class,info_1_class,info_2_class,info_3_class,info_4_class,info_5_class,get_information)

    require 'twitter'
    require 'dotenv'
    require 'rails'

#各時限に教科名が入っていなかった場合、改行コードだけを加える。
        get_1_class="\n" if get_1_class.blank?
        get_2_class="\n" if get_2_class.blank?
        get_3_class="\n" if get_3_class.blank?
        get_4_class="\n" if get_4_class.blank?
        get_5_class="\n" if get_5_class.blank?
#各時限に教科名が入っていなかった場合、改行コードだけを加える。終わり


#各テーブルに塗りつぶしがあった場合色から休講情報なのか教室変更情報なのか判断してメッセージかする
    if info_1_class=="bkgnd-kyuukou"
    message_1_class="1限に休講情報があります。"
    elsif info_1_class=="bkgnd-roomhenkou"
    message_1_class="1限に教室変更情報があります。"
    else
    message_1_class.to_s
    end

    if info_2_class=="bkgnd-kyuukou"
    message_2_class="2限に休講情報があります。"
    elsif info_2_class=="bkgnd-roomhenkou"
    message_2_class="2限に教室変更情報があります。"
    else
    message_2_class.to_s
    end

    if info_3_class=="bkgnd-kyuukou"
    message_3_class="3限に休講情報があります。"
    elsif info_3_class=="bkgnd-roomhenkou"
    message_3_class="3限に教室変更情報があります。"
    else
    message_3_class.to_s
    end

    if info_4_class=="bkgnd-kyuukou"
    message_4_class="4限に休講情報があります。"
    elsif info_4_class=="bkgnd-roomhenkou"
    message_4_class="4限に教室変更情報があります。"
    else
    message_4_class.to_s
    end

    if info_5_class=="bkgnd-kyuukou"
    message_5_class="5限に休講情報があります。"
    elsif info_5_class=="bkgnd-roomhenkou"
    message_5_class="5限に教室変更情報があります。"
    else
    message_5_class.to_s
    end
#各テーブルに塗りつぶしがあった場合色から休講情報なのか教室変更情報なのか判断してメッセージかする。終わり。

#アカウントのAPI承認
    client = Twitter::REST::Client.new do |config|
    Dotenv.load
    config.consumer_key        = ENV["consumer_key"]
    config.consumer_secret     = ENV["consumer_key_secret"]
    config.access_token        = ENV["access_token"]
    config.access_token_secret = ENV["access_token_secret"]
    end
#アカウントのAPI承認実行終わり。
#投稿する文面の作成
    puts("------------------------tweet_content----------------------------")
    tweet_message=("明日は"+get_information.to_s+get_no_class.to_s+"です。\n"+"一限目"+get_1_class.to_s+"二限目"+get_2_class.to_s+"三限目"+get_3_class.to_s+"四限目"+get_4_class.to_s+"五限目"+get_5_class.to_s+"\n"+message_1_class.to_s+message_2_class.to_s+message_3_class.to_s+message_4_class.to_s+message_5_class.to_s+"\n"+t.to_s+"にポータルより取得しました。")
    puts(tweet_message)
    puts("--------------------------tweet_contant--------------------------")
#投稿する文面の作成終わり
    client.update(tweet_message)
 end


     require 'mechanize'
     require 'rubygems'
     require 'pry'
     #require 'active_support/all'
     require 'rails'
     require 'dotenv'
     agent=Mechanize.new
     #証明書が必要なければコメントアウト
     #agent.ca_file = "./security.cer"
     #agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
     agent.ssl_version = 'TLSv1'
#ポータルサイトにログイン実行
     agent.get('https://aoyama-portal.aoyama.ac.jp/aogaku_auth/jsp/AUTH01.jsp?TYPE=33554433&REALMOID=06-2a27689c-587a-42e0-834c-7a6751c24219&GUID=0&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=W02MLRk5ZzW6lo1jgEk6cBozc3Jz0O9V2D3FFJOoCKp0KOwIGgLV9PDcb8W1gma1&TARGET=-SM-https%3a%2f%2faoyama--portal%2eaoyama%2eac%2ejp%2fprotect%2f') do |page|
     response = page.form_with(:name => 'Auth') do |form|
     Dotenv.load
     form.field_with(:name => 'USER').value = ENV["studentid"]
     Dotenv.load
     form.field_with(:name => 'PASSWORD').value = ENV["password"]
     login_page = agent.submit(form)
     t = Time.now
     puts(t)
     page=login_page
     ua = "Windows IE 9"
     agent.user_agent = ua
     #get_messages=page.search('title').inner_text
     #puts (get_messages)
#ポータルサイトへのログイン実行終わり。
#時間割のページに飛ぶ
     page = agent.get('https://aguinfo.jm.aoyama.ac.jp/AGUInfo/jikanwari.aspx?')
     get_information=page.search('#cph_content_rptJikanwari_hyp_date2').inner_text  #明日の日付取得
     puts("明日、"+ get_information +"の時間割情報。")

     get_no_class=page.search('#cph_content_rptJikanwari_Item2_0').inner_text.gsub("  ",'')  #休日か授業日か取得
     puts("明日は"+ get_no_class)

     if get_no_class.include?("授業日")#翌日が授業日の場合


tags=[]
target_tags=[]
tags_raw=page.body
tags_raw.each_line {|line| tags<<line }
target_tags_1=tags.select{|item| item.include? ('cph_content_rptJikanwari_Linkbutton2_1')}
target_tags_2=tags.select{|item| item.include? ('cph_content_rptJikanwari_Linkbutton2_2')}
target_tags_3=tags.select{|item| item.include? ('cph_content_rptJikanwari_Linkbutton2_3')}
target_tags_4=tags.select{|item| item.include? ('cph_content_rptJikanwari_Linkbutton2_4')}
target_tags_5=tags.select{|item| item.include? ('cph_content_rptJikanwari_Linkbutton2_5')}

  target_tags_1=target_tags_1.join.force_encoding("UTF-8").match(/\>(.*?)\</).to_s
  get_1_class=target_tags_1.gsub(">","").gsub("<","").encode("UTF-8")

   target_tags_2=target_tags_2.join.force_encoding("UTF-8").match(/\>(.*?)\</).to_s
  get_2_class=target_tags_2.gsub(">","").gsub("<","").encode("UTF-8")

   target_tags_3=target_tags_3.join.force_encoding("UTF-8").match(/\>(.*?)\</).to_s
  get_3_class=target_tags_3.gsub(">","").gsub("<","").encode("UTF-8")

   target_tags_4=target_tags_4.join.force_encoding("UTF-8").match(/\>(.*?)\</).to_s
  get_4_class=target_tags_4.gsub(">","").gsub("<","").encode("UTF-8")

   target_tags_5=target_tags_5.join.force_encoding("UTF-8").match(/\>(.*?)\</).to_s
  get_5_class=target_tags_5.gsub(">","").gsub("<","").encode("UTF-8")

  get_1_class="#{get_1_class}\n"
  get_2_class="#{get_2_class}\n"
  get_3_class="#{get_3_class}\n"
  get_4_class="#{get_4_class}\n"
  get_5_class="#{get_5_class}\n"

        puts("一限目:"+get_1_class) if get_1_class.present?
        puts("二限目："+get_2_class) if get_2_class.present?
        puts("三限目:"+get_3_class) if get_3_class.present?
        puts("四限目:"+get_4_class) if get_4_class.present?
        puts("五限目:"+get_5_class) if get_5_class.present?

#表に色がついてる場合だけスクレイピング（休講・教室変更情報)
        info_1_class = page.at('#cph_content_rptJikanwari_Item2_1')[:class] if page.at('#cph_content_rptJikanwari_Item2_1')[:class].present?
        info_2_class = page.at('#cph_content_rptJikanwari_Item2_2')[:class] if page.at('#cph_content_rptJikanwari_Item2_2')[:class].present?
        info_3_class = page.at('#cph_content_rptJikanwari_Item2_3')[:class] if page.at('#cph_content_rptJikanwari_Item2_3')[:class].present?
        info_4_class = page.at('#cph_content_rptJikanwari_Item2_4')[:class] if page.at('#cph_content_rptJikanwari_Item2_4')[:class].present?
        info_5_class = page.at('#cph_content_rptJikanwari_Item2_5')[:class] if page.at('#cph_content_rptJikanwari_Item2_5')[:class].present?
#表に色がついてる場合だけスクレイピング（休講・教室変更情報)終わり
      else #明日が授業日でない場合
        puts("明日は休みです。")
      end

#取得時間、1～５限目までの科目名、１～５限目までの表の塗りつぶしの色をthrow_tweetメソッドに引数として渡す。
    throw_tweet(t,get_no_class,get_1_class,get_2_class,get_3_class,get_4_class,get_5_class,info_1_class,info_2_class,info_3_class,info_4_class,info_5_class,get_information)
    end


end

end