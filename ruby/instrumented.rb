require 'qsort'

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

srand( 12345678 )
n = (ARGV.size >= 1 && ARGV[0].to_i) || 1024
m = n*n
test = Array.new( n ){ |i| rand( m ) }
puts test.inspect if test.size <= 64
start = Time.now
sorted = Tournament.sort( test )
elapsed = Time.now - start
puts sorted.inspect if test.size <= 64
puts Match::count.to_f/log2fact( n )
puts "#{elapsed} secs"

test = Array.new( n ){ |i| rand( m ) }
start = Time.now
sorted = quicksort( test )
elapsed = Time.now - start
puts "#{elapsed} secs"