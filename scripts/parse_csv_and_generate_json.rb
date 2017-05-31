# -*- encoding: utf-8 -*-
require 'csv'
require 'json'
require 'fileutils'
require 'pathname'

class ParseCsvAndGenerateJson
  class ZipCodeVo < Struct.new(:zip_code)
    def initialize(*argv)
      super
      freeze

      check_zip_code!
    end

    def check_zip_code!
      if zip_code.to_s !~ /\A[0-9]{7}\z/
        raise "[#{line_no}] Invalid zip code: #{zip_code.pretty_inspect}"
      end
    end

    def zip_code_prefix
      zip_code[0...3]
    end
  end

  # >> ["01101", "060  ", "0600000", "ﾎｯｶｲﾄﾞｳ", "ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ", "", "北海道", "札幌市中央区", "", "0", "0", "0", "0", "0", "0"]
  class ZipCodeRow < Struct.new(
    :line_no,
    :city_jis_code, :old_zip_code, :zip_code, :prefecture_name_kana, :city_name_kana, :town_name_kana, :prefecture_name, :city_name, :town_name,
    :has_some_zip_codes, :banti_by_koaza, :has_chome, :has_some_towns, :update_reason_code, :change_reason_code)
    def initialize(*argv)
      super
      freeze

      check_values!
    end

    def check_values!
      check_jis_code!
      check_zip_code!
      check_prefecture_present!
      check_city_present!
    end

    def check_jis_code!
      if city_jis_code.to_s !~ /\A[0-9]{5}\z/
        raise "[#{line_no}] Invalid JIS code: #{city_jis_code.pretty_inspect}"
      end
    end

    def check_zip_code!
      if zip_code.to_s !~ /\A[0-9]{7}\z/
        raise "[#{line_no}] Invalid zip code: #{zip_code.pretty_inspect}"
      end
    end

    def check_prefecture_present!
      if prefecture_name.to_s.empty?
        raise "[#{line_no}] Prefecture name is not present."
      end
    end

    def check_city_present!
      if city_name.to_s.empty?
        raise "[#{line_no}] City name is not present."
      end
    end

    def obsolete?
      change_reason_code.to_i == 6
    end

    def zip_code_vo
      ZipCodeVo.new(zip_code)
    end

    def prefecture_jis_code
      city_jis_code[0..1]
    end
  end

  def main(filename, data_dir)
    rows = load_zip_code_rows(filename)
    rows = rows.sort_by {|row| [row.zip_code.to_s, row.prefecture_name_kana.to_s, row.city_name_kana.to_s, row.town_name_kana.to_s, row.prefecture_name.to_s, row.city_name.to_s, row.town_name.to_s]}
    rows = rows.reject {|row|
      row.obsolete?
    }

    rows_hash = rows.group_by(&:zip_code_vo)

    zip_code_dir = Pathname.new(data_dir) + 'zip_code'
    FileUtils.rm_rf(zip_code_dir, secure: true)

    rows_hash.each {|zip_code_vo, rows_of_zip_code|
      json = make_zip_json(rows_of_zip_code)
      write_json_to_file(zip_json_path(zip_code_dir, zip_code_vo), json)
    }
  end

  def zip_json_path(zip_code_dir, zip_code_vo)
    zip_code_dir + zip_code_vo.zip_code_prefix + "#{zip_code_vo.zip_code}.json"
  end

  def make_zip_json(rows)
    zip_code_params = rows.map {|row|
      {
        'prefecture_jis_code'  => row.prefecture_jis_code            ,
        'city_jis_code'        => row.city_jis_code            ,
        'zip_code'             => row.zip_code            ,
        'prefecture_name_kana' => row.prefecture_name_kana,
        'city_name_kana'       => row.city_name_kana      ,
        'town_name_kana'       => row.town_name_kana      ,
        'prefecture_name'      => row.prefecture_name     ,
        'city_name'            => row.city_name           ,
        'town_name'            => row.town_name           ,
      }
    }
    JSON.dump(zip_code_params)
  end

  def write_json_to_file(json_path, json)
    dirname = File.dirname(json_path)
    FileUtils.mkdir_p(dirname)

    open(json_path, 'w') {|f|
      f.write(json)
    }
  end

  def load_zip_code_rows(filename)
    line_no = 0
    rows = []
    CSV.foreach(filename, encoding: "Shift_JIS:UTF-8") do |fields|
      line_no += 1
      rows << ZipCodeRow.new(line_no, *fields)
    end
    rows
  end
end

case $PROGRAM_NAME
when __FILE__
  if ARGV.size < 2
    STDERR.puts "ruby parse_csv_and_generate_json.rb <path_to_x-ken-all.csv> <path_to_data_dir>"
    exit 1
  end
  ParseCsvAndGenerateJson.new.main(ARGV[0], ARGV[1])
when /spec[^\/]*$/
  # {spec of the implementation}
end


