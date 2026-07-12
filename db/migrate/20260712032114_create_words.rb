class CreateWords < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pg_trgm" unless extension_enabled?("pg_trgm")

    create_table :words do |t|
      t.string :headword,   null: false   # イタリア語見出し語
      t.string :pos                        # 品詞タグ（前・女・男・変 等）
      t.text   :definition, null: false    # 日本語の意味・注記
      t.string :base_form                  # 活用形の場合、原形への参照（例：debba -> dovere）

      t.timestamps
    end

    add_index :words, :headword
    add_index :words, :base_form
    add_index :words, :headword,   using: :gin, opclass: :gin_trgm_ops, name: "index_words_on_headword_trgm"
    add_index :words, :definition, using: :gin, opclass: :gin_trgm_ops, name: "index_words_on_definition_trgm"
  end
end
