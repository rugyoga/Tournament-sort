import java.util.Comparator; import java.util.Random; import java.util.Arrays;

class Tournament
{
  Comparator<Object> comparator; Object tourney;

  Tournament( Comparator<Object> comparator, Object[] v )
  {
    this.comparator = comparator;
    this.tourney = knockout( v, 0, v.length-1 );
  }

  public Object pop()
  {
    Object result = Match.winner( tourney );
    tourney = tourney instanceof Match ? ((Match)tourney).remove_winner( comparator ) : null; return result;
  }

  public static void sort( Object[] v, Comparator<Object> comparator )
  {
    Tournament tourney = new Tournament( comparator, v );
    for (int i = 0; i < v.length; i++)
      v[i] = tourney.pop();
    }

  private Object knockout( Object[] v, int i, int k )
  {
    if (i == k) return v[i];
    int j = (i+k)/2;
    return new Match( comparator, knockout( v, i, j ), knockout( v, j+1, k ) );
  }

  static class Match
  {
    Object losers, winners, item;

    Match( Comparator<Object> comparator, Object a, Object b )
    {
      Object a_winner = winner( a ), b_winner = winner( b );
      boolean result = comparator.compare( a_winner, b_winner ) < 0;
      this.losers = result ? b : a;
      this.winners = result ? a : b;
      this.item = result ? a_winner : b_winner;
    }

    static Object winner( Object t )
    {
      return t instanceof Match ? ((Match)t).item : t;
    }

    public String toString() { return "([" + item + "]" + winners + losers + ")"; }

    public Object remove_winner( Comparator<Object> comparator )
    {
      return winners instanceof Match ? new Match( comparator, losers, ((Match)winners).remove_winner( comparator ) ) : losers;
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
    System.out.println( description + " took " + ((double)(finish-start)/1000.0) + " secs " + compare.count + " comparisons");
  }

  static class InstrumentedCompare implements Comparator<Object>
  {
    public int count = 0;  
    public int compare( Object a, Object b ) { count++; return ((Integer)a).compareTo( (Integer)b ); }
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