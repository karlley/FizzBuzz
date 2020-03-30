class Value < ApplicationRecord

 # 空文字以外, 5文字以内, 数値のみ 
 validates :input, presence: true, length: {maximum: 5}, numericality: {only_integer: true} 
 
end
