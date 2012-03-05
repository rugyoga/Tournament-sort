class Tournament
  def initialize( v )
    @tourney = knockout( v )
  end
  
  def pop
    winner, @tourney = Tournament.extract_winner( @tourney )
    winner
  end
  
  def knockout( v, i=0, k=v.size-1 )
    return Tournament.player( v[i] ) if i == k
    j = (i+k)/2
    Tournament.match( knockout( v, i, j ), knockout( v, j+1, k ) )
  end
  
  def self.sort!( v )
    tourney = Tournament.new( v )
    v.size.times{ |i| v[i] = tourney.pop }
  end

  def self.sort( v )
    tourney = Tournament.new( v )
    Array.new( v.size ){ |i| tourney.pop }
  end
end