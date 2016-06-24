class Resource < ActiveRecord::Base

  self.inheritance_column = nil

  belongs_to :item, class_name: 'Tool::Item', foreign_key: 'item_id'

  has_many :location_resources
  has_many :locations, through: :location_resources

  has_attached_file :image, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # generate scopes for a search: Resource.all.fishing, Resource.all.lumberjacking, etc.
  Player::CRAFT.each do |name|
    define_singleton_method name.to_sym do
      where(type: name)
    end
  end
end
