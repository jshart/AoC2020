import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day19\\data\\example2");

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
    
    pLen=parsedRules.get(0).testRule(s,0,0,"{TOP}");
    
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
  int[][] subRules=new int[2][3];
  int subRulesCount=0;
  int ruleNumber=0; // pretty sure we can throw this away as we've pre-sorte the list
 
  public void printTree(int d)
  {
    int k=0;
    for (k=0;k<d;k++)
    {
      print("| ");
    }
    print("o-");
  }
  
  public int testRule(String s, int position,int d, String callingR)
  {
    int consumed=position;
    int i=0,j=0,k=0;
    
    String r=new String("[R:"+ruleNumber+"D:"+d+"P:"+position+"]<"+callingR+"");
 
    //if (consumed==s.length())
    //{
    //  printTree(d);
    //  println(r+"string consumed - finalising at depth="+d+" called for rule:"+ruleNumber+" with c:"+consumed+" and strlen="+s.length());
    //  return(consumed);
    //}
    //else if (consumed>s.length())
    //{
    //  printTree(d);
    //  println(r+"string consumed - finalising at depth="+d+" called for rule:"+ruleNumber+" with c:"+consumed+" and strlen="+s.length());
    //  return(-1);
    //}
    
    
    // Final value?
    if (finalValue>0)
    {
      printTree(d);
      
      if (s.charAt(position)==finalValue)
      {
         println(r+" ==== MATCH FOUND at "+position+" char:"+s.charAt(position));
         
         if (position==s.length()-1)
         {
           println("COMPLETE STRING FOUND");
         }
         consumed++;
      }
      else
      {
        println(r+" **** FAILED FINAL VALUE CHECK:"+s.charAt(position)+"!="+finalValue);
        consumed=-1;
      }
      return(consumed);
    }
    
    // Save the current location - because if we fail an optional leg, we need to rewind
    // to here and re-run for other optional legs until we find a match of exhaust all options
    int savedPoint=consumed;

    // For each possible subrule...
    for (i=0;i<subRulesCount;i++)
    {
      int nonZero=0;
      
      // do we have enough characters left to execute rule set?
      for (j=0;j<3;j++)
      {
        if (subRules[i][j]!=0)
        {
          nonZero++;
        }
      }
      
      // ensure we're starting from the save point (unnecessary for first pass, but needed for subsequent)
      consumed=savedPoint;
      
      // if there is something to check - print it
      if (nonZero>0)
      {
        printTree(d);
        print("CHECK "+i+ " FOR rule:"+ruleNumber+" need="+nonZero+" consumed="+consumed+" strlen="+s.length());      
        print("["+r+"] checking  SUBRULE="+i+"[");
        print(subRules[i][0]+" "+subRules[i][1]+" "+subRules[i][2]);
        println("]");
      }
      
      // are there enough characters left to satisfy the subcomponents?
      if (s.length()>consumed+nonZero)
      {
      

        // for this rule - check every sub component passes...
        for (j=0;j<3;j++)
        { 
          // because sub rules maybe 2 *or* 3 elements long, we pad to 3 with a 0
          // as we know we cant loop, as 0's found means we're done and we should
          // bail on the loop.
          if (subRules[i][j]==0)
          {
            break;
          }
            
          //if (consumed>=s.length())
          //{
          //  printTree(d);
          //  println(r+"string consumed - finalising at depth="+d+" called for rule:"+ruleNumber+" with c:"+consumed+" and strlen="+s.length());
          //  return(-1);
          //}  
            
          // call rule checks recursively...
          consumed=parsedRules.get(subRules[i][j]).testRule(s,consumed,d+1,r);
          
          // if the rule failed, then assume this entire subset is invalid
          // jump to the next...
          if (consumed<0)
          {
            break;
          }
        }
      
      }
      else
      {
        // rulef failed - as not enough string left to satisfy remaining terms
        consumed=-1;
      }
      
      // if we get here and we've passed sub-rules, then this set is
      // ok, and we can skip checking any other sub-rules in this.
      if (consumed>0)
      {
        break;  
      }
      else
      {
        // if consumed is less than 0 at this point, it means something went wrong in one of the sub rules, so we need to check the next.
        printTree(d);
        println(r+"first rule failed, trying next");
      }
    }
    printTree(d);
    println("FINISHED RULESET="+ruleNumber+" with a consumed value of:"+consumed);
    return(consumed);
  }
  
  public ParsedRule(String s)
  {
    String[] temp;
    String[] temp2;
    int i=0,j=0;
    
    //println("Parsing:"+s);
    
    temp=s.split(": ");
    ruleNumber=Integer.parseInt(temp[0]);
    
    s=temp[1];
    //println("parsing param string="+s);
    
    // if (this has subfields)
    if (s.indexOf('%')>0)
    {
      //println("optional params found");
      // has more than one optional component.
      temp=s.split(" % ");
      
      // for each optional subrule
      subRulesCount=temp.length;
      
      for (i=0;i<subRulesCount;i++)
      {
        //println("testing="+temp[i]+" index="+i);

        // for each optional subrule, lets parse each component
        temp2=temp[i].split(" ");
        for (j=0;j<temp2.length;j++)
        {
          //println("parsing subcomponet="+temp2[j]);
          subRules[i][j]=Integer.parseInt(temp2[j]);
        }
      }
    }
    else if (s.indexOf('a')>0 || s.indexOf('b')>0)
    {
      //println("Final value found");
      finalValue=s.charAt(1);
    }
    else
    {
      subRulesCount=1;
      temp2=s.split(" ");
      for (j=0;j<temp2.length;j++)
      {
        //println("parsing subcomponet="+temp2[j]);
        subRules[0][j]=Integer.parseInt(temp2[j]);
      }
    }
  }
  
  void printRule()
  {
    int i=0;
    println("ID="+ruleNumber+" subrules="+subRulesCount+" finalValue="+finalValue);
    for (i=0;i<subRulesCount;i++)
    {
      println("->"+subRules[i][0]+"#"+subRules[i][1]);
    }
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
