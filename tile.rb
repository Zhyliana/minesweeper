class Tile
  attr_accessor :bomb_count
  attr_accessor :flagged, :revealed, :bomb

  def initalize
    @bomb = false
    @flagged = false
    @revealed = false
    @bomb_count = nil
  end

  def set_flag
    @flagged = !@flagged
  end

  def flagged?
    @flagged
  end

  def reveal
    @revealed = true
  end

  def revealed?
    @revealed
  end

  def set_bomb
    @bomb = true
  end

  def bomb?
    @bomb
  end
end
