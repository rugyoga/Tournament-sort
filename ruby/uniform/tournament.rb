class Match
  attr_reader :winner, :losers, :winners
  @@count = 0
  
  def init_player( player )
    @winner = player
    @winners = @losers = nil
  end
  
  def initialize( *args )
    args.size == 1 ? init_player( *args ) : init_match( *args )
  end
  
  def init_match( top, bot )
    @@count += 1
    top_winner, bot_winner = top.winner,bot.winner
    @winner, @winners, @losers = top_winner <= bot_winner ? [top_winner, top, bot] : [bot_winner, bot, top]
  end

  def to_s
    is_player?() ? "[#{@winner}]" : "(#{@winner} #{@winners.to_s} #{@losers.to_s})"
  end
  
  def is_player?
    @winners.nil?
  end

  def Match.extract_winner( t )
     [t.winner, (t.is_player?() ? nil : t.remove_winner)]
  end
  
  def remove_winner
    winners.is_player?() ? losers : Match.new( losers, winners.remove_winner );
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
    i == k ? Match.new( v[i] ): (j = (i+k)/2; Match.new( knockout( v, i, j ), knockout( v, j+1, k ) ))
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
puts test.inspect if test.size <= 64
puts Match::count.to_f/log2fact( n )
puts "#{elapsed} secs"

test = Array.new( n ){ |i| rand( m ) }
start = Time.now
sorted = test.sort
elapsed = Time.now - start
puts "#{elapsed} secs"