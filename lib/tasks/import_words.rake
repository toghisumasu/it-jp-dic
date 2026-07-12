namespace :words do
  desc "italiano_utf8.txt を words テーブルへインポート"
  task import: :environment do
    path = Rails.root.join("data", "italiano_utf8.txt")
    lines = File.readlines(path, encoding: "UTF-8")
              .map { |l| l.chomp("\r\n").chomp("\n") }
              .reject(&:empty?)

    unless lines.size.even?
      raise "行数が奇数です（#{lines.size}行）。見出し語/定義のペアが崩れています。"
    end

    Word.transaction do
      Word.delete_all # 再インポート時は全消去してから入れ直す

      lines.each_slice(2) do |headword, def_line|
        pos, definition = parse_definition(def_line)
        base_form = pos == "変" ? extract_base_form(definition) : nil

        Word.create!(
          headword:   headword,
          pos:        pos,
          definition: definition,
          base_form:  base_form
        )
      end
    end

    puts "#{Word.count}件をインポートしました。"
  end

  def parse_definition(line)
    if (m = line.match(/\A\(([^)]+)\)(.*)\z/))
      [m[1], m[2]]
    else
      [nil, line]
    end
  end

  def extract_base_form(definition)
    m = definition.match(/\A([\p{L}']+)\s*の/)
    m && m[1]
  end
end
