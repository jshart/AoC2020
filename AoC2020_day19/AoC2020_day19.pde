import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day19\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();

InputFile rules = new InputFile("rules_with_loops.txt");
InputFile input = new InputFile("input.txt");
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
    
    pLen=parsedRules.get(0).testRule(s,0);
    
    if (pLen<0 || pLen<s.length())
    {
      println("*** RULE:"+i+" failed"+" processed:"+pLen);
    }
    else
    {
      println("*** RULE:"+i+" passed"+" processed:"+pLen);
      passed++;
    }
    println();
  }
  println("FINAL TOTAL="+passed);
}



void draw() {  
  //if (ferry.pc>=numLines)
  //{
  //  noLoop();
  //  return;
  //}
  //else
  //{
  //  //background(0);
  //  //stroke(255);
  
  //  stroke(255,0,0);
  //  ferry.update(insList.get(ferry.pc));
  //  line(ferry.oldX,ferry.oldY,ferry.x,ferry.y);
  //  ferry.printBoat();
  //}
  //for (x=0;x<noCols;x++)
  //{
  //  for (y=0;y<noLines;y++)
  //  {
  //    if (state1Active==true)
  //    {
  //      currentCell=state1[x][y];
  //    }
  //    else
  //    {
  //      currentCell=state2[x][y];
  //    }
      
  //    if (currentCell>=1)
  //    {
  //      stroke(255,0,0);
  //      fill(255,255,255);
  //      rect(xoffset+(x*cellSize),yoffset+(y*cellSize),cellSize,cellSize);
  //      seats++;
  //    }
  //    if (currentCell==2)
  //    {
  //      stroke(0,244,0);
  //      fill(0,244,0);
  //      circle(xoffset+(x*cellSize)+(cellSize/2),yoffset+(y*cellSize)+(cellSize/2),cellSize);
  //      people++;
  //    }
  //  }
  //}

}

public class ParsedRule
{
  char finalValue=0;
  
  // currently looks like there is a max of 2 subrules, each of which can be a max of 3 components long
  int[][] subRules=new int[2][3];
  int subRulesCount=0;
  int ruleNumber=0; // pretty sure we can throw this away as we've pre-sorte the list
  
  public int testRule(String s, int position)
  {
    int consumed=position;
    int i=0,j=0;
    
    print("["+ruleNumber+"]");
    for (i=0;i<position;i++)
    {
      print("-");
    }


    if (consumed>=s.length())
    {
      print("string consumsed - finalising");
      return(consumed);
    }
    
    
    // Final value?
    if (finalValue>0)
    {
      if (s.charAt(position)==finalValue)
      {
         println("MATCH FOUND");
         consumed++;
      }
      else
      {
        println("FAILED FINAL VALUE CHECK:"+s.charAt(position)+"!="+finalValue);
        consumed=-1;
      }
    }
    
    // Save the current location - because if we fail an optional leg, we need to rewind
    // to here and re-run for other optional legs until we find a match of exhaust all options
    int savedPoint=consumed;

    for (i=0;i<subRulesCount;i++)
    {
      print("TESTING SUBRULE="+i+"[");
      print(subRules[i][0]+" "+subRules[i][1]+" "+subRules[i][2]);
      println("]");
      consumed=savedPoint;
      
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
        

        
        // call rule checks recursively...
        consumed=parsedRules.get(subRules[i][j]).testRule(s,consumed);
        
        // if the rule failed, then assume this entire subset is invalid
        // jump to the next...
        if (consumed<0)
        {
          break;
        }
      }
      
      // if we get here and we've passed sub-rules, then this set is
      // ok, and we can skip checking any other sub-rules in this.
      if (consumed>0)
      {
        break;  
      }
    }
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
