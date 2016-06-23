class UserObserver < ActiveRecord::Observer

  def after_create(user)
    player_create(user)
  end

  private

  def player_create(user)
    Player.create(user_id: user.id, image: File.new("#{Rails.root}/app/assets/images/players/warrior.jpg"))
  end
end