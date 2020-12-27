import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day21\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
//InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
ArrayList<String> masterList = new ArrayList<String>();

int key1=8987316;
int key2=14681524;

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  //input.printFile();
  
  int i=0,j=0;

  // Loop through each food...
  //for (i=0;i<input.lines.size();i++)
  //{
  
  //}
  
  //println("result:"+calcLoop(5764801));
  //println();
  //println("result:"+calcLoop(17807724));
  //println();
  //println("key:"+(long)calcKey(8,17807724));
  
  println("Key1:"+key1+" key2:"+key2);
  
  int result1, result2;
  result1=calcLoop(key1);
  println("result:"+result1);
  
  //result2=calcLoop(key2);
  //println();
  //println("result:"+key2);
  //println();
  println("key:"+(long)calcKey(2541700, key2));
}

double calcKey(int loops, int publicKey)
{
  double subjectNumber=publicKey;
  double value=1;
  int i=0;
  
  for (i=0;i<loops;i++)
  {
    value*=subjectNumber;
    value%=20201227;
    println("value:"+value);
  }
  
  return(value);
}

int calcLoop(int key)
{
  double subjectNumber=7;
  double value=1;
  int loops=0;
  
  while ((int)value!=key)
  {
    value*=subjectNumber;
    value%=20201227;
    println("loop:"+loops+" value:"+value);
    loops++;
  }
  
  return(loops);
}


void printMasterList()
{
  int i=0;
  for (i=0;i<masterList.size();i++)
  {
    println("Allergen ML:"+masterList.get(i));
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
