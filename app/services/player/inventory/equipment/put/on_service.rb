class Player::Inventory::Equipment::Put::OnService

  # put on an item in a slot
  
  attr_reader :player, :equipment, :new_item, :current_item, :slot

  def initialize(player, item)
    @player = player
    @equipment = player.equipment
    @new_item = item
    @slot = "#{item.category.slug}_slot"
    @current_item = player[slot]
  end

  def call
    if is_an_item_purchased? && level_required?
      put_the_current_item_in_inventory if slot_is_busy?
      put_the_new_item_in_the_slot
      update_stats
      player.save
      #start_repair_hp
    end
  end

  private

  def is_an_item_purchased?
    equipment.include?(new_item.id.to_s)
  end

  def level_required?
    player.level >= new_item.required_level
  end

  def slot_is_busy?
    current_item.present?
  end

  def put_the_new_item_in_the_slot
    equipment.delete(new_item.id.to_s)
    player[slot] = new_item.id.to_i
  end

  def put_the_current_item_in_inventory
    equipment << current_item.to_s
  end

  def update_stats
    # get all wearable items, then calculate all stats from those items
    wearable_equipment_ids = Player::Inventory::WearableItemsIdsService.new(player, Player::EQUIPMENT_SLOTS).call
    new_stats = Player::Stats::GetAllService.new(player, wearable_equipment_ids).call
    new_stats.each do |stat_name, stat_value|
      player[stat_name] = stat_value
    end
  end

  def start_repair_hp
    service = Player::RepairHpService.new(player)
    service.call
  end
end