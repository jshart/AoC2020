import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day21\\data\\example");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


InputFile input = new InputFile("input.txt");
FoodList foodList = new FoodList();
HashMap<String, FoodList> map = new HashMap<String, FoodList>();
ArrayList<String> masterList = new ArrayList<String>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0;
  Food tempFood;
  FoodList newFoodList;
  FoodList tempFoodList;

  // Loop through each food...
  for (i=0;i<input.lines.size();i++)
  {
    tempFood=new Food(input.lines.get(i));
    //tempFood.printFood();
    foodList.foods.add(tempFood);
    
    // ... and for each food, check each allergen
    for (j=0;j<tempFood.alls.size();j++)
    {
      
      tempFoodList=map.get(tempFood.alls.get(j));

      // is this the first time we've seen this?
      if (tempFoodList==null)
      {
        newFoodList=new FoodList();
        newFoodList.foods.add(tempFood);
        map.put(tempFood.alls.get(j),newFoodList);
      }
      else
      {
        tempFoodList.foods.add(tempFood);
      }
    }
  }
  
  for (Map.Entry m : map.entrySet())
  {
    println("Key:"+m.getKey());
    tempFoodList=(FoodList)m.getValue();
    tempFoodList.printFoodList();
    tempFoodList.buildCommonList();
    tempFoodList.printAllergenList();
  }
  printMasterList();
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

public class FoodList
{
  ArrayList<Food> foods=new ArrayList<Food>();
  ArrayList<String> allergenList = new ArrayList<String>();
  
  public FoodList()
  {
  }
  
  void printFoodList()
  {
    int i=0;
    for (i=0;i<foods.size();i++)
    {
      foods.get(i).printFood();
    }
  }
  
  void printAllergenList()
  {
    int i=0;
    for (i=0;i<allergenList.size();i++)
    {
      println("suspected allergen;"+allergenList.get(i));
    }
  }
  
  void buildCommonList()
  {
    Food firstFood;
    firstFood=foods.get(0);
    int i=0,j=0;
    boolean found=true;
    String all;
    
    // for each ing in the first food, check for its existence in all other foods - if its there then its a likely allergen
    for (i=0;i<firstFood.ings.size();i++)
    {
      found=true;
      
      for (j=0;j<foods.size();j++)
      {
        found = foods.get(j).hasIng(firstFood.ings.get(i));
      }
      if (found==true)
      {
        all=firstFood.ings.get(i);
        allergenList.add(all);
        addToMaster(all);   // a bit hacky - but for quick work, I just copy every allergen into a master list to make life a bit easier later
      }
    }
  }
  
  void addToMaster(String s)
  {
    int i=0;
    for (i=0;i<masterList.size();i++)
    {
      if (masterList.get(i).equals(s)==true)
      {
        return;
      }
    }
    masterList.add(s);
  }
}


public class Food
{
  ArrayList<String> ings=new ArrayList<String>();
  ArrayList<String> alls=new ArrayList<String>();
  
  public Food(String s)
  {
    String temp[],temp2[];
    int i=0;
    
    temp=s.split(" contains "); 
    
    temp2=temp[0].split(" ");
    for (i=0;i<temp2.length;i++)
    {
      ings.add(temp2[i]);
    }
    
    temp2=temp[1].split(", ");
    for (i=0;i<temp2.length;i++)
    {
      alls.add(temp2[i]);
    }
  }
  
  void printFood()
  {
    int i=0;
    for (i=0;i<ings.size();i++)
    {
      println("I:["+ings.get(i)+"]");
    }
    for (i=0;i<alls.size();i++)
    {
      println("A:["+alls.get(i)+"]");
    }
  }
  
  boolean hasIng(String s)
  {
    int i=0;
    for (i=0;i<ings.size();i++)
    {
      if (ings.get(i).equals(s)==true)
      {
        return(true);
      }
    }
    return(false);
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
