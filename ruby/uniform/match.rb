class Match
  attr_reader :winner, :losers, :winners

  def initialize( *args )
    args.size == 1 ? init_player( *args ) : init_match( *args )
  end
  
  def init_player( player )
    @winner = player
    @winners = @losers = nil
  end
  
  def init_match( top, bot )
    top_winner, bot_winner = top.winner,bot.winner
    @winner, @winners, @losers = top_winner <= bot_winner ? [top_winner, top, bot] : [bot_winner, bot, top]
  end

  def is_player?
    @winners.nil?
  end
  
  def remove_winner
    winners.is_player?() ? losers : Match.new( losers, winners.remove_winner );
  end
end

class Tournament
  def Tournament.player( p )
    Match.new( p )
  end
  
  def Tournament.match( a, b )
    Match.new( a, b )
  end

  def Tournament.extract_winner( t )
     [t.winner, (t.is_player?() ? nil : t.remove_winner)]
  end
end

