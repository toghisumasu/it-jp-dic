class Word < ApplicationRecord
  validates :headword,   presence: true
  validates :definition, presence: true

  # 活用形から原形を引く（例: debba -> dovere）
  def base_word
    return nil if base_form.blank?

    Word.find_by(headword: base_form)
  end

  # 見出し語・意味の両方を対象にした簡易検索
  # 完全一致 > 前方一致 > 部分一致・類似度 の順で並べる
  def self.search(query)
    return none if query.blank?

    exact_order = sanitize_sql_array(["(headword = ?)", query])

    where("headword ILIKE :prefix OR definition ILIKE :contains OR similarity(headword, :q) > 0.3",
          prefix: "#{query}%", contains: "%#{query}%", q: query)
      .order(Arel.sql("#{exact_order} DESC"), :headword)
      .limit(50)
  end
end
