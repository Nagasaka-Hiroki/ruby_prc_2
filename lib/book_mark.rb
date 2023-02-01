#インスタンスを必要としない機能のまとまりを作る。
require "json"
module BookMarks
    #アクセスできるようにattrをつける。
    attr_reader :book_marks
    attr_accessor :file_path
    #ファイル名を固定する。
    @file_path=File.dirname(
                    File.dirname(
                        File.expand_path(__FILE__)
                    )
               )+"/data/data.json"
    #データの読み込み先をHashに指定する。
    @book_marks={}

    #ファイルを読み込む。
    def input_data
        @book_marks&.merge!(
            JSON.parse(
                File.open(@file_path,"r") do |f|
                    f.readlines #readlinesは配列を返す。
                end.join('')    #連結して一つの文字列にする。
            )                   #文字列をJSONとしてパースする。
        )                       #ファイルの読み込み先に連結する。
    end
    #ファイルに追加する。
    def add_url(name,url_attrs,url)
        data_list = { name => { attr: url_attrs, url: url } } #引数で指定した変数をhashに変換する。
        @book_marks&.merge!(data_list) #クラス側で保持している変数と連結
        write_json_file #ファイルに追記する
    end
    #属性を追加する。
    def add_attr(name,url_attrs)
        url_attrs.each do |ar|
            @book_marks[name]["attr"].push ar
        end
        write_json_file #ファイルに追記する
    end

    #属性で篩をかける。
    def attr_filter
    end
    private
    #ファイルに追記する。
    def write_json_file
        File.open(@file_path,"w",0664) do |f|
            f.print JSON.dump(@book_marks) #ファイルにjson形式で書き込む。
        end
    end
end