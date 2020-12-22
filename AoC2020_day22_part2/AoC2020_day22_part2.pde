import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day22_part2\\data\\mydata");

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
  

  
  int result=play(0,player1Ints,player2Ints);

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

ArrayList<Integer> copyHand(ArrayList<Integer> p, int max)
{
  ArrayList<Integer> c = new ArrayList<Integer>();
  int i=0;
  
  for (i=0;i<max;i++)
  {
    c.add(p.get(i));
  }
  return(c);
}

int play(int d, ArrayList<Integer> p1, ArrayList<Integer> p2)
{
  int result=0;
  
  int p1c=0, p2c=0;
  ArrayList<Integer> player1Ints = copyHand(p1);
  ArrayList<Integer> player2Ints = copyHand(p2);
  
  ArrayList<SaveState> ss = new ArrayList<SaveState>();
  int i=0;
  
  println("NEW GAME SPAWNED");
  
  while(player1Ints.size()>0 && player2Ints.size()>0)
  {
    // check states
    printTree(d);
    println("Checking all previous states ["+ss.size()+"]");
    for (i=0;i<ss.size();i++)
    {
      if (ss.get(i).checkState(player1Ints, player2Ints)==true)
      {
        printTree(d);
        println("existing state found at index="+i);
        return(1);
      }
    }
    // save state
    ss.add(new SaveState(player1Ints, player2Ints));
    
    p1c=player1Ints.get(0); player1Ints.remove(0);
    p2c=player2Ints.get(0); player2Ints.remove(0);
    printTree(d);
    println("Comparing ["+p1c+"] and ["+p2c+"]");
    
    
    if (p1c<=player1Ints.size() && p2c<=player2Ints.size())
    {
      printTree(d);
      println("-> SUB GAME condition met, creating subdeck...");
      
      ArrayList<Integer> player1NewGame = copyHand(player1Ints,p1c);
      ArrayList<Integer> player2NewGame = copyHand(player2Ints,p2c);
      
      printDeck("P1 NG",player1NewGame,d);
      printDeck("P2 NG",player2NewGame,d);
      result=play(d+1,player1NewGame,player2NewGame);
      if (result==1)
      {
        player1Ints.add(p1c);
        player1Ints.add(p2c);
      }
      else
      {
        player2Ints.add(p2c);
        player2Ints.add(p1c);
      }
      
      printTree(d);
      println("-> SUB GAME COMPLETE, new deck;");
      printDeck("P1",player1Ints,d);
      printDeck("P2",player2Ints,d);
    }
    else
    {
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
  }
  
  // who won?
  if (player1Ints.size()>0)
  {
    printDeck("P1",player1Ints,d);
    printTree(d);
    println("GAME RESULT:"+calculateScores(player1Ints));
    result=1;
  }
  else
  {
    printDeck("P2",player2Ints,d);
    printTree(d);
    println("GAME RESULT:"+calculateScores(player2Ints));
    result=2;
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

void printTree(int d)
{
  int j=0;
  for (j=0;j<d;j++)
  {
    print("-");
  }
}

void printDeck(String t, ArrayList<Integer> p, int d)
{
  int i=0,j=0;
  for (j=0;j<d;j++)
  {
    print("-");
  }
  print(t+" ");
  for (i=0;i<p.size();i++)
  {

    print(","+p.get(i));
  }
  println();
}


void draw() {  

}


public class SaveState
{
  int[] p1;
  int[] p2;
  
  public SaveState(ArrayList<Integer> player1Ints, ArrayList<Integer> player2Ints)
  {
    int i=0,l=0;
    l=player1Ints.size();
    p1=new int[l];
    for (i=0;i<l;i++)
    {
      p1[i]=player1Ints.get(i);
    }
    
    l=player2Ints.size();
    p2=new int[l];
    for (i=0;i<l;i++)
    {
      p2[i]=player2Ints.get(i);
    }
  }
  
  boolean checkState(ArrayList<Integer> player1Ints, ArrayList<Integer> player2Ints)
  {
    int i=0,l=0;
    
    l=player1Ints.size();
    if (l!=p1.length)
    {
      return(false);
    }
    for (i=0;i<l;i++)
    {
      if (p1[i]!=player1Ints.get(i))
      {
        return(false);
      }
    }
    
    l=player2Ints.size();
    if (l!=p2.length)
    {
      return(false);
    }
    for (i=0;i<l;i++)
    {
      if (p2[i]!=player2Ints.get(i))
      {
        return(false);
      }
    }
    return(true);
  }
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
