import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day18\\data\\example");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();

InputFile mathContents = new InputFile("input.txt");


void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  mathContents.printFile();
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
      String output=findSubEquations(lines.get(i),0);
      output=findSubEquations(output,0);
      println("FINAL ANSWER="+output);
      println();
    }
  }
  
  public String findSubEquations(String s, int d)
  {
    int i=0,j=0;
    int openBrackets=0;
    int startBracketLocation=0, endBracketLocation=0;
    boolean subEquationFound=false;
    boolean anySubsFound=false;
    char tempChar;
    String answer;
    
    String output = new String();
        
    for (i=0;i<d;i++)
    {
      print("-");
    }
    println("EQ["+s+"]");
    
    // Look for a start of equation
    for (i=0;i<s.length();i++)
    {
      tempChar=s.charAt(i);
      
      // So either resolve the sub equation *and* return the result to the string
      if (tempChar=='(')
      {
        startBracketLocation=i+1;
        
        // start bracket found - search for pairing close bracket.
        for (j=startBracketLocation;j<s.length();j++)
        {
          if (s.charAt(j)=='(')
          {
            openBrackets++;
          }
          if (s.charAt(j)==')')
          {

            if (openBrackets==0)
            {
              endBracketLocation=j;
              subEquationFound=true;
            }
            else
            {
              openBrackets--;
            }
          }
        }
        if (subEquationFound==true)
        {
          i=endBracketLocation;
          answer=findSubEquations(s.substring(startBracketLocation,endBracketLocation),d+1);          
          
          output=output.concat(answer);
          
          anySubsFound=true;
        }
        subEquationFound=false;
      }
      // continue to update the string with anything else
      else
      {
        output=output.concat(Character.toString(tempChar));
      }
    }
    
    if (anySubsFound==false)
    {
      int total=0;
      String operator="+";     
      String[] terms = s.split(" ");
      for (i=0;i<terms.length;i++)
      {
        print("{"+terms[i]+"}");
        if (terms[i].equals("+") || terms[i].equals("-") || terms[i].equals("/") || terms[i].equals("*"))
        {
          operator=terms[i];
        }
        else
        {
          if (operator.equals("+"))
          {
            total+= Integer.parseInt(terms[i]);
          }
          else if (operator.equals("-"))
          {
            total-= Integer.parseInt(terms[i]);
          }
          else if (operator.equals("/"))
          {
            total/= Integer.parseInt(terms[i]);
          }
          else if (operator.equals("*"))
          {
            total*= Integer.parseInt(terms[i]);
          }
        }
      }
      output=Integer.toString(total);
    }   
    println("O["+output+"]");
    return(output);
  }
}
