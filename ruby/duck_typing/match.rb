class Player
  attr_reader :winner
  def initialize( player )
    @winner = player
  end
  def remove_winner
    nil
  end
end

class Match
  attr_reader :winner, :losers, :winners
  
  def initialize( top, bot )
    @winner, @winners, @losers = top.winner <= bot.winner ? [top.winner, top, bot] : [bot.winner, bot, top]
  end
  
  def remove_winner
    winners.is_a?( Match ) ? Match.new( losers, winners.remove_winner ) : losers;
  end
end

class Tournament
  def Tournament.extract_winner( t )
    [t.winner, t.remove_winner]
  end
  
  def Tournament.player( p )
    Player.new( p )
  end

  def Tournament.match( a, b )
    Match.new( a, b )
  end
end