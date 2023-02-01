# 作業記録
　作業記録をつける。

## モジュールの作成とテストの作成
　モジュールについては以下。
- [class Module (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/class/Module.html)

ファイルに関しては以下。
- [class File (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/3.2/class/File.html)
- [Kernel.#open (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/3.2/method/Kernel/m/open.html)
- [class IO (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/class/IO.html)

とりあえず、確認よりも先にコードを実装する。その後にデバッグコマンドで挙動を確認していく。  
並行してテストを使ってコードを動かしていく。

テストコードの一部にデバックコードを挿入し、デバッガを起動。デバッグコマンドで実行状況を確認する。

Hashについては以下を参照。
- [class Hash (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/class/Hash.html#I_MERGE)

Hashの結合はmerge。（arrayのように`push`などは使えないようだ）

JSONファイル形式は以下。
- [JSON の操作 - ウェブ開発を学ぶ｜MDN](https://developer.mozilla.org/ja/docs/Learn/JavaScript/Objects/JSON#json_%E3%81%AE%E9%85%8D%E5%88%97)

また、binding.breakをいちいち取り除くのが面倒なので環境変数で対応する。

```bash
$ ruby -h
  -d              set debugging flags (set $DEBUG to true)
```

しかし、`-d`オプションで起動するとエラーがいっぱい出る。また`rdbg`で使えないといった問題がある。

環境変数に関しては以下。
- [object ENV (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/class/ENV.html)
- [Linuxコマンド【 export 】環境変数を定義・リスト表示する - Linux入門 - Webkaru](https://webkaru.net/linux/export-command/)
- [Linuxコマンド【 env 】環境変数を設定してプログラムを実行 - Linux入門 - Webkaru](https://webkaru.net/linux/env-command/)

以下のコマンドを実行する。

```bash
$ export RUBY_DEBUG=true
```

環境変数を削除するには以下を実行。
```bsh
$ export -n RUBY_DEBUG
```

テストスクリプトに以下を追加する。

```ruby
binding.break if ENV.fetch('RUBY_DEBUG',false)
```

`export RUBY_DEBUG=true`と`export -n RUBY_DEBUG`でデバックの切り替えができるようになった。

状態を確認するコマンドは`printenv RUBY_DEBUG`でOKだと思う。

テストの順番を制御したいので設定を見る。

- [minitest/test.rb at master · minitest/minitest · GitHub](https://github.com/minitest/minitest/blob/master/lib/minitest/test.rb)

以下のようにクラスに追加すると末尾から実行される様になった。

```ruby
#テストの順番を指定する。
    def self.test_order
        :sorted
    end
```

また、順序を制御するコードを読むと、Array#sortが使われていた。以下に示す。
- [Array#sort (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/method/Array/i/sort.html)
- [module Comparable (Ruby 3.2 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/class/Comparable.html)

なので、sortの順番で並び替えされるように名前を変える。irbで確認。

```ruby
["1","a","2","b"].sort
=> ["1", "2", "a", "b"]
```

文字列としての数字が優先される？比較には`<=>`が使われているそうだ。

以下確認。

```ruby
["1","a","1-2","1-1","b"].sort
=> ["1", "1-1", "1-2", "a", "b"]
```

数字は0~9で判断？２桁以上は判定されている。

上記に注意して名前を変更する。
