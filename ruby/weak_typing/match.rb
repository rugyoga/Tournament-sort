class Match
  attr_reader :winner, :losers, :winners

  def initialize( top, bot )
    top_w = top.is_a?( Match ) ? top.winner : top
    bot_w = bot.is_a?( Match ) ? bot.winner : bot
    @winner, @winners, @losers =
      top_w <= bot_w ?
      [top_w, top, bot] :
      [bot_w, bot, top]
  end
  
  def remove_winner
    winners.is_a?( Match ) ? Match.new( losers, winners.remove_winner ) : losers;
  end
end

class Tournament
  def Tournament.player( p )
    p
  end
  
  def Tournament.match( a, b )
    Match.new( a, b )
  end
  
  def Tournament.extract_winner( t )
    t.is_a?( Match ) ? [t.winner, t.remove_winner] : [t, nil]
  end
end