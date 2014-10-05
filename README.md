# ニートの友達 ~動画編~
[Jubatus Hackathon](http://connpass.com/event/8233/)にて作成した
「似てるようで似てない少し似てるレコメンドシステム」
のソースコード

## 仕組み
jubarecommenderを利用して、レコメンドされた結果を更にjubarecommenderに与えるという操作を繰り返すことで
元のコンテンツに対して少し距離の離れたコンテンツの推薦を行います

このシステムでは[ニコニコデータセット](http://www.nii.ac.jp/cscenter/idr/nico/nico.html)
の動画のタグを離礁してレコメンドを行っています

システムはこのデータセットおよびjubatusに依存していますが、
仕組み自体は任意のレコメンドシステムで利用可能かと思います

## 必要なパッケージ
以下のパッケージをインストールしてください
* jubatus
* ruby
* junatus ruby client
* ruby on rails

## 動かし方
lib/jubatusのconfig.jsonを利用してjubarecommenderを起動します
```
$ cd lib/jubatus
$ jubarecommender -f config.json
```

バッチ処理で学習データを作成します  
jubatusはオンライン学習を行うため、
ニコニコ動画であれば動画の投稿やタグの編集にあわせてリアルタイムに学習することが可能ですが、
今回はシステムを動かすためにモデル構築をバッチ処理的に行っています
```
$ cd lib/jubatus
$ ruby learn_nico.rb
```

DBに必要なデータの投入
動画情報をDataBaseに保持するためにシードとして投入します
```
$ rake db:create
$ rake db:migrate
$ rake db:seed
```

railsを起動します
```
$ rails s
```
5. ブラウザから
http://\<hostname\>:3000/videos/index  
にアクセスして確認してください

## 挙動について
最初の画面ではDBに登録したコンテンツが表示されます
この画面で好きな動画を選択するとそれに対するレコメンド動画一覧が表示されます
実装があまり綺麗ではないため、レコメンドコンテンツ取得に数秒かかります
クリック後は気長にお待ちください

遷移後の画面では好きなコンテンツを選択すれば実際のニコニコ動画へと遷移します

検索ウインドウなどもございますが、こちらは動作しません

## その他
個人的に作成した物で、公開や要望の募集などの予定は現在のところございません
使用したい場合は勝手にどうぞ

本システムは、hackathonのレギュレーションに基づきMITライセンスとなります
