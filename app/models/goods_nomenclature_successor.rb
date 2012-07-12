class GoodsNomenclatureSuccessor < ActiveRecord::Base
  self.primary_keys =  [:goods_nomenclature_sid, :absorbed_goods_nomenclature_item_id,
                        :absorbed_productline_suffix, :goods_nomenclature_item_id,
                        :productline_suffix]

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :absorbed_goods_nomenclature, primary_key: [:goods_nomenclature_item_id,
                                                         :producline_suffix],
                                           foreign_key: [:absorbed_goods_nomenclature_item_id,
                                                         :absorbed_productline_suffix],
                                           class_name: 'GoodsNomenclature'
end

# == Schema Information
#
# Table name: goods_nomenclature_successors
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  goods_nomenclature_sid              :integer(4)
#  absorbed_goods_nomenclature_item_id :string(255)
#  absorbed_productline_suffix         :string(255)
#  goods_nomenclature_item_id          :string(255)
#  productline_suffix                  :string(255)
#  created_at                          :datetime
#  updated_at                          :datetime
#

