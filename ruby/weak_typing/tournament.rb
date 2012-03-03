class Match
  attr_reader :winner, :losers, :winners
  @@count = 0
  
  def initialize( top, bot )
    @@count += 1
    top_winner, bot_winner = Match.get_winner( top ), Match.get_winner( bot )
    @winner, @winners, @losers = top_winner <= bot_winner ? [top_winner, top, bot] : [bot_winner, bot, top]
  end

  def to_s
    "([#{@winner}] #{@winners.to_s} #{@losers.to_s})"
  end
  
  def Match.get_winner( t )
    t.is_a?( Match ) ? t.winner : t
  end
  
  def Match.extract_winner( t )
    t.is_a?( Match ) ? [t.winner, t.remove_winner] : [t, nil]
  end
  
  def remove_winner
    winners.is_a?( Match ) ? Match.new( losers, winners.remove_winner ) : losers;
  end
  
  def Match.count
    @@count
  end
end

class Tournament
  def initialize( v )
    @tourney = knockout( v )
  end
  
  def pop
    winner, @tourney = Match.extract_winner( @tourney )
    winner
  end
  
  def knockout( v, i=0, k=v.size-1 )
    i == k ? v[i] : (j = (i+k)/2; Match.new( knockout( v, i, j ), knockout( v, j+1, k ) ))
  end
  
  def self.sort( v )
    tourney = Tournament.new( v )
    v.size.times{ |i| v[i] = tourney.pop }
  end
end

def log2( n )
  Math.log( n )/Math.log( 2 )
end

def log2fact( n )
  2.upto( n ).inject( 0 ){ |sum,i| sum + log2( i ) }.ceil
end

srand( 12345678 )
n = (ARGV.size >= 1 && ARGV[0].to_i) || 1024
m = n*n
test = Array.new( n ){ |i| rand( m ) }
puts test.inspect if test.size <= 64
start = Time.now
sorted = Tournament.sort( test )
elapsed = Time.now - start
puts sorted.sorted.inspect if test.size <= 64
puts Match::count.to_f/log2fact( n )
puts "#{elapsed} secs"

test = Array.new( n ){ |i| rand( m ) }
start = Time.now
sorted = test.sort
elapsed = Time.now - start
puts "#{elapsed} secs"