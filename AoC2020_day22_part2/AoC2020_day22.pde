import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day22\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
InputFile player1 = new InputFile("player1.txt");
InputFile player2 = new InputFile("player2.txt");

ArrayList<Integer> p1 = new ArrayList<Integer>();
ArrayList<Integer> p2 = new ArrayList<Integer>();

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

  for (i=0;i<player1.lines.size();i++)
  {
    p1.add(Integer.parseInt(player1.lines.get(i)));
  }
  
  for (i=0;i<player2.lines.size();i++)
  {
    p2.add(Integer.parseInt(player2.lines.get(i)));
  }
  
  int p1c=0, p2c=0;
  
  while(p1.size()>0 && p2.size()>0)
  {
    p1c=p1.get(0); p1.remove(0);
    p2c=p2.get(0); p2.remove(0);
    println("Comparing ["+p1c+"] and ["+p2c+"]");
    if (p1c>p2c)
    {
      p1.add(p1c);
      p1.add(p2c);
    }
    else
    {
      p2.add(p2c);
      p2.add(p1c);
    }
  }
  
  int result;
  printDecks();
  // who won?
  if (p1.size()>0)
  {
    result=calculateScores(p1);
  }
  else
  {
    result=calculateScores(p2);
  }
  println("FINAL SCORE:"+result);
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

void printDecks()
{
  int i=0;
  for (i=0;i<p1.size();i++)
  {
    println("P1:"+p1.get(i));
  }

  for (i=0;i<p2.size();i++)
  {
    println("P2:"+p2.get(i));
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
