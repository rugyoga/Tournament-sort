import java.util.Comparator;
import java.util.Random;
import java.util.Arrays;

class Tournament<T>
{
  Match<T> tourney;
  Comparator<T> comparator;
	
  Tournament( Comparator<T> comparator, T[] v )
  {
	this.comparator = comparator;
	this.tourney    = knockout( v, 0, v.length-1 );
  }
  
  public T pop()
  {
	T result = tourney.winner;
	tourney = tourney.isPlayer() ? null : tourney.rebuild( comparator );
	return result;
  }

  public static <T> void sort( T[] v, Comparator<T>  comparator )
  {
    Tournament<T> tourney = new Tournament<T>( comparator, v );
    for (int i = 0; i < v.length; i++)
		v[i] = tourney.pop();
  }

  private Match<T> knockout( T[] v, int i, int k )
  {
	if (i == k) return new Match<T>( v[i] );
    int j = (i+k)/2;
	return new Match<T>( comparator, knockout( v, i, j ), knockout( v, j+1, k ) );
  }

static class Match<Player>
{
  Match<Player> losers, winners;
  Player winner;

  Match( Player player )
  {
	 this.winner  = player;
  }

  Match( Comparator<Player> comparator, Match<Player> a, Match<Player> b )
  {
	boolean result  = comparator.compare( a.winner, b.winner ) < 0;
    this.losers     = result ? b : a;
	this.winners    = result ? a : b;
	this.winner     = result ? a.winner : b.winner;
  }

  public boolean isPlayer(){ return losers == null || winners == null; }

  public String toString()
  {
	return isPlayer() ? "([" + winner + "])" : "([" + winner + "]" + winners + " " + losers + ")";
  }

  public Match<Player> rebuild( Comparator<Player> comparator )
  {
    return winners.isPlayer() ? losers : new Match<Player>( comparator, losers, winners.rebuild( comparator ) ); 
  }
}
  static Integer[] randomInts( int n )
  {
	Random r = new Random( 12345678 );
    Integer[] v = new Integer[n];
    for (int i = 0; i < n; i++)
      v[i] = r.nextInt( 10*n );
    return v;
  }

  static void time( String description, Runnable action, InstrumentedCompare compare )
  {
    long start = System.currentTimeMillis();
    action.run();
	long finish = System.currentTimeMillis();
    System.out.println( description + " took " + ((double)(finish-start)/1000.0) +" secs " + compare.count + " comparisons" );	
  }

  static class InstrumentedCompare implements Comparator<Integer>
  {
    public int count = 0;
	public int compare( Integer a, Integer b )
	{
		count++;
		return a.compareTo( b );
	}     	
  }

  public static void main( String[] args )
  {
     int n = args.length >= 1 ? Integer.parseInt( args[0] ) : 100000;
     final InstrumentedCompare tournamentCompare = new InstrumentedCompare();
	 final Integer[] nums = randomInts( n );
	 time( "Tournament.sort", new Runnable(){ public void run(){ Tournament.sort( nums, tournamentCompare ); } }, tournamentCompare );
	 final Integer[] nums2 = randomInts( n );
     final InstrumentedCompare systemCompare = new InstrumentedCompare();
	 time( "Array.sort", new Runnable(){ public void run(){ Arrays.sort( nums2, systemCompare ); } }, systemCompare );
	 for (int i = 0; i < n; i++)
	   if (nums[i].compareTo( nums2[i] ) != 0)
	   {
	      System.err.println( "Arrays do not match at index: " + i );
          return;
	   }
  }
}