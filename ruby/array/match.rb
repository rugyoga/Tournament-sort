class Tournament
  def Tournament.player( p )
    p
  end
  
  def Tournament.remove_winner( t )
    winner, winners, losers = t
    winners.is_a?( Array ) ? Tournament.match( losers, remove_winner( winners ) ) : losers;
  end
  
  def Tournament.match( top, bot )
    top_w = top.is_a?( Array ) ? top[0] : top
    bot_w = bot.is_a?( Array ) ? bot[0] : bot
    top_w <= bot_w ? [top_w, top, bot] : [bot_w, bot, top]
  end
  
  def Tournament.extract_winner( t )
    t.is_a?( Array ) ? [t[0], Tournament.remove_winner( t )] : [t, nil]
  end
end