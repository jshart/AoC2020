import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day19_part2\\data\\example2");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();

InputFile rules = new InputFile("rules_with_loops.txt");
//InputFile rules = new InputFile("rules_sorted.txt");
InputFile input = new InputFile("badInputSingle.txt");
// InputFile input = new InputFile("goodInputSingle.txt");
//InputFile input = new InputFile("input.txt");
ArrayList<ParsedRule> parsedRules = new ArrayList<ParsedRule>();


void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  rules.printFile();
  input.printFile();
  
  ParsedRule temp;
  
  int i=0,j=0,k=0;
  
  for (i=0;i<rules.numLines;i++)
  {
    temp=new ParsedRule(rules.lines.get(i));
    parsedRules.add(temp);
    temp.printRule();
  }
  
  println();
  
  int pLen=0;
  String s;
  int passed=0;
  
  for (i=0;i<input.numLines;i++)
  {
    s=input.lines.get(i);

    println("Testing line:"+input.lines.get(i)+" lenth="+s.length());
    
    parsedRules.get(0).testRule(s,0,0,"{TOP}");

    println();
    if (pLen<0 || pLen<s.length())
    {
      println("*** RULE:"+i+" failed"+" processed:"+pLen);
    }
    else
    {
      println("*** RULE:"+i+" passed"+" processed:"+pLen);
      passed++;
    }
    println(s);
  }
  println("FINAL TOTAL="+passed);
}



void draw() {  


}

public class ParsedRule
{
  char finalValue=0;
  
  // currently looks like there is a max of 2 subrules, each of which can be a max of 3 components long
  int[] left=new int[3];
  int leftCount=0;
  int[] right=new int[3];
  int rightCount=0;
  
  int ruleNumber=0; // pretty sure we can throw this away as we've pre-sorted the list
 
  public void printTree(int d)
  {
    int k=0;
    for (k=0;k<d;k++)
    {
      print("| ");
    }
    print("o-");
  }
  
  
  // TODO: Partially implemented - need to fix the position increment...  
  public boolean testRule(String s, int position,int d, String callingR)
  {
    int i=0;
    boolean passed=false;
    
    // tight loop/recursion protection
    if (d>10)
    {
      return(false);
    }

    printTree(d);
    print("Testing rule:"+ruleNumber+" "+getSubRules());
    
    // test to see if this matches a final value
    if (finalValue>0)
    {
      if (s.charAt(position)==finalValue)
      {
        // MATCH
        println("MATCH SUCCEED="+finalValue);
        passed=true;
        return(passed);
      }
      else
      {
        // Not a MATCH
        println("MATCH FAILED="+finalValue);
        passed=false;
        return(passed);
      }
    }
    
    println();
    
    passed=true;
    // test all left conditions
    if (leftCount>0)
    {
      for (i=0;i<leftCount && passed==true;i++)
      {
        passed=parsedRules.get(left[i]).testRule(s,position,d+1,callingR);  
      }
    }
    
    // Only execute the right hand side if the left hand failed
    if (passed==false)
    {
      passed=true;
      // test all right conditions if the left failed
      if (rightCount>0)
      {
        for (i=0;i<rightCount && passed==true;i++)
        {
          passed=parsedRules.get(right[i]).testRule(s,position,d+1,callingR);  
        }
      }
    }
    return(passed);
  }
  
  public ParsedRule(String s)
  {
    String[] temp;
    String[] temp2;
    int i=0,j=0;
    
    String leftStr=null;
    String rightStr=null;
    
    //println("Parsing:"+s);
    
    temp=s.split(": ");
    ruleNumber=Integer.parseInt(temp[0]);
    
    s=temp[1];
    println("parsing param string="+s);
    
    if (s.indexOf('a')>0 || s.indexOf('b')>0)
    {
      //println("Final value found");
      finalValue=s.charAt(1);
    }
    else if (s.indexOf('%')>0)    // if (this has subfields)
    {
      //println("optional params found");
      // has more than one optional component.
      temp=s.split(" % ");
      
      leftStr=temp[0];
      rightStr=temp[1];
    }
    else
    {
      leftStr=s;
    }
    
    if (leftStr!=null)
    {
      // for each optional subrule, lets parse each component
      temp2=leftStr.split(" ");
      for (j=0;j<temp2.length;j++)
      {
        left[j]=Integer.parseInt(temp2[j]);
      }
      leftCount=j;
    }
    
    if (rightStr!=null)
    {
      // for each optional subrule, lets parse each component
      temp2=rightStr.split(" ");
      for (j=0;j<temp2.length;j++)
      {
        right[j]=Integer.parseInt(temp2[j]);
      }
      rightCount=j;
    }
  }
  
  void printRule()
  {
    println("ID="+ruleNumber+" leftRules="+leftCount+" rightRules="+rightCount+" finalValue="+finalValue);
    println(getSubRules());
  }
  
  String getSubRules()
  {
    int i=0;
    String s="{";
    for (i=0;i<leftCount;i++)
    {
      s=s+"#"+left[i];
    }
    s=s+"}{";
    for (i=0;i<rightCount;i++)
    {
      s=s+"#"+right[i];
    }
    s=s+"}";
    
    return(s);
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
        print("loading:"+line);
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
