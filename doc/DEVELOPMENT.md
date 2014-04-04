## 開発者向け資料

---

### 必須環境
- Ruby(2.0.0 以上)

### 依存ライブラリ
- [croudia-gem](https://github.com/wktk/croudia-gem)
- [Mechanize](http://mechanize.rubyforge.org/)
- [Sixamo](http://yowaken.dip.jp/sixamo/)

### 環境導入

$ gem install mechanize
$ gem install croudia
$ mkdir dict

### Croudia Developer Center
- ユーザ登録
- アプリケーション登録
- Consumer Key, Consumer Secret を取得

### 設定

$ vim config.yaml

> ---
> :client_id: "*** your App's Consumer Key ***"
> :cｌient_secret: "*** your App's Consumer Secret ***"
> :user_id: "*** your Bot's User-ID ***"
> :password: "*** your Bot's Password ***"
> 

$ vim ignore_ids.yaml

> ---
> - "Bot's User-ID"
> - "Bot's User-ID"
> ...
> 

### 使い方

事前に Sixamo 辞書を作成して下さい。

cron などで、
> $ ruby -C $PWD scripts/random_talk.rb
このように実行させることで動作します。


