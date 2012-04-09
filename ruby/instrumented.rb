class Match
  @@count = 0
  
  alias original_initialize initialize
  def initialize( *args )
    @@count += 1 if args.size == 2
    original_initialize( *args )
  end

  def to_s
    "([#{@winner}] #{@winners.to_s} #{@losers.to_s})"
  end
  
  def Match.count
    @@count
  end
end

def log2( n )
  Math.log( n )/Math.log( 2 )
end

def log2fact( n )
  2.upto( n ).inject( 0 ){ |sum,i| sum + log2( i ) }.ceil
end

def mkRandom( n )
  m = 10*n
  srand( 12345678 )
  Array.new( n ){ |i| rand( m ) }
end

def benchmark( description, n, &block )
  v = mkRandom( n )
  puts "before: " + v.inspect if v.size <= 64
  start = Time.now
  block.call( v )
  elapsed = Time.now - start
  puts "after: " + v.inspect if v.size <= 64
  puts "#{description}: #{elapsed} secs"  
end
  
n = (ARGV.size >= 1 && ARGV[0].to_i) || 1024
benchmark( "tournament", n ) do |v|
  Tournament.sort!( v )
end
benchmark( "array", n ) do |v|
  v.sort!
end
puts "ratio to optimal comparisons: #{Match::count.to_f/log2fact( n ).to_f}"