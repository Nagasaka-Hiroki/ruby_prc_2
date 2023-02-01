#ロードする。
require 'minitest/autorun'
require 'debug'
require_relative '../lib/book_mark'

#モジュールを有効にする。
include BookMarks

#デバックをする場合は、  export RUBY_DEBUG=true を実行する。
#デバックをしない場合は、export -n RUBY_DEBUG 　を実行する。 
def debug_switch
    ENV.fetch('RUBY_DEBUG',false)
end

#テストクラスを定義する。
#ファイル関係のテスト
class BookMarksFileTest < Minitest::Test
#テストの順番を指定する。
    #test_のあとの文字でソートされる。優先順位は文字より数字の方が高い。
    def self.test_order
        :sorted
    end

    #書き込みのテスト、ファイルの存在の確認
    def test_1_1_add_url
        binding.break if debug_switch
        BookMarks.add_url("example1",["attr_1"],"example1.com")
        BookMarks.add_url("example2",["attr_2-1","attr_2-2"],"example2.com")
        assert_path_exists BookMarks.file_path
    end
    #データの読み込みのテスト。上記のテストで書き込んだ内容を正しく読み込めるか？
    def test_1_2_input_data
        binding.break if debug_switch
        assert_equal BookMarks.input_data,
        {"example1"=>{"attr"=>["attr_1"], "url"=>"example1.com"},
        "example2"=>{"attr"=>["attr_2-1","attr_2-2"], "url"=>"example2.com"}}
    end
    #urlに属性に追加する
    def test_1_3_add_attr
        binding.break if debug_switch
        BookMarks.add_attr("example1",["extra_attr1","extra_attr2"])
        assert_equal BookMarks.input_data,
        {"example1"=>{"attr"=>["attr_1","extra_attr1","extra_attr2"], "url"=>"example1.com"},
        "example2"=>{"attr"=>["attr_2-1","attr_2-2"], "url"=>"example2.com"}}
    end
end