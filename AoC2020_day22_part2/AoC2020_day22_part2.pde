import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day22_part2\\data\\example");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
InputFile player1 = new InputFile("player1.txt");
InputFile player2 = new InputFile("player2.txt");



void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  player1.printFile();
  player2.printFile();

  int i=0,j=0;
  ArrayList<Integer> player1Ints = new ArrayList<Integer>();
  ArrayList<Integer> player2Ints = new ArrayList<Integer>();

  for (i=0;i<player1.lines.size();i++)
  {
    player1Ints.add(Integer.parseInt(player1.lines.get(i)));
  }
  
  for (i=0;i<player2.lines.size();i++)
  {
    player2Ints.add(Integer.parseInt(player2.lines.get(i)));
  }
  

  
  int result=play(player1Ints,player2Ints);
  printDeck(player1Ints,0);
  printDeck(player1Ints,0);

  println("FINAL SCORE:"+result);
}

ArrayList<Integer> copyHand(ArrayList<Integer> p)
{
  ArrayList<Integer> c = new ArrayList<Integer>();
  int l=p.size();
  int i=0;
  
  for (i=0;i<l;i++)
  {
    c.add(p.get(i));
  }
  return(c);
}

int play(ArrayList<Integer> p1, ArrayList<Integer> p2)
{
  int result=0;
  
  int p1c=0, p2c=0;
  ArrayList<Integer> player1Ints = copyHand(p1);
  ArrayList<Integer> player2Ints = copyHand(p2);
  
  while(player1Ints.size()>0 && player2Ints.size()>0)
  {
    p1c=player1Ints.get(0); player1Ints.remove(0);
    p2c=player2Ints.get(0); player2Ints.remove(0);
    println("Comparing ["+p1c+"] and ["+p2c+"]");
    
    if (p1c<=player1Ints.size() && p2c<=player2Ints.size())
    {
      println("-> SUB GAME condition met");
      printDeck(player1Ints,1);
      printDeck(player1Ints,1);
    }
    
    if (p1c>p2c)
    {
      player1Ints.add(p1c);
      player1Ints.add(p2c);
    }
    else
    {
      player2Ints.add(p2c);
      player2Ints.add(p1c);
    }
  }
  
  // who won?
  if (player1Ints.size()>0)
  {
    result=calculateScores(player1Ints);
  }
  else
  {
    result=calculateScores(player2Ints);
  }
  
  return(result);
}

int calculateScores(ArrayList<Integer> p)
{
  int l=p.size();
  int i=0,j=l-1;
  int result=0;
  for (i=1;j>=0;j--,i++)
  {
    result+=(p.get(j)*i);
  }
  return(result);
}

void printDeck(ArrayList<Integer> p,int d)
{
  int i=0,j=0;
  for (i=0;i<p.size();i++)
  {
    for (j=0;j<d;j++)
    {
      print("-");
    }
    println("P1:"+p.get(i));
  }
}


void draw() {  

}





public class InputFile
{
  ArrayList<String> lines = new ArrayList<String>();
  int numLines=0;
  String fileName;
  
  public InputFile(String fname)
  {
    fileName=fname;
    
    try {
      String line;
      
      File fl = new File(filebase+File.separator+fileName);
  
      FileReader frd = new FileReader(fl);
      BufferedReader brd = new BufferedReader(frd);
    
      while ((line=brd.readLine())!=null)
      {
        println("loading:"+line);
        lines.add(line);
      }
      brd.close();
      frd.close();
  
    } catch (IOException e) {
       e.printStackTrace();
    }
    
    numLines=lines.size();
  }
  
  public void printFile()
  {
    println("CONTENTS FOR:"+fileName);
    int i=0;
    for (i=0;i<numLines;i++)
    {
      println("L"+i+": "+lines.get(i));
    }
  }
}
