//int[] inputInts = new int[

String[] lines;
int totalLines = 0;



ArrayList<Day1Pair> Day1PairList = new ArrayList<Day1Pair>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);
  
  lines = loadStrings("day1_input_sorted.txt");
  totalLines=lines.length;
  
  Day1Pair tempPair;
    
  int i=0;
  print(totalLines);
  
  for (i=0;i<totalLines;i++)
  {
    print(lines[i]+",");
    //tempPair = new Day1Pair(trim(lines[i]));
    
    //print(tempPair.pair+" ");
  }
}

void draw() {
  noLoop();
}

public class Day1Pair
{
  int a;
  int b;
  String pair;
  
  public Day1Pair(String s)
  {
    print("s:"+s);
    a=Integer.parseInt(s);
    b=2020-a;
    pair = s+b;
  }
}
