import java.io.File;
import java.io.FileReader;
import java.io.IOException;

String[] lines;
int totalLines = 0;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day4\\data");

ArrayList<PassportData> passportList = new ArrayList<PassportData>();

int validPassports;

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);
  
  //lines = loadStrings("input.txt");
      System.out.println("Working Directory = " + System.getProperty("user.dir"));

  String passportString = new String();
  PassportData tempPassport;

  try {
    String line;
    
    File fl = new File(filebase+File.separator+"input.txt");
    FileReader frd = new FileReader(fl);
    BufferedReader brd = new BufferedReader(frd);
  
    while ((line=brd.readLine())!=null)
    {
      //print(line);
      passportString +=" "+line;
      
      if (line.length()==0)
      {
        //print("Calling with: {"+passportString+"}\n");
        tempPassport = new PassportData(passportString);
        passportList.add(tempPassport);
        
        if (tempPassport.validate()==true)
        {
          validPassports++;
          print("[VALID]");
        }
        else
        {
          print("[INVALID]");
        }
        passportString="";
        tempPassport.printRecord();
        println(); 
      }
    }
    brd.close();
    frd.close();

  } catch (IOException e) {
     e.printStackTrace();
  }
  
  println("Valid Passports:"+validPassports);
}

void draw() {
  noLoop();
}

public class PassportData
{
  String byr;
  String iyr;
  String eyr;
  String hgt;
  String hcl;
  String ecl;
  String pid;
  String cid;
  
  public PassportData(String s)
  {
    String[] tempPair=s.split(" ");
    //print(s+"\n");
    //print("fields:"+temp.length);
    
    //print(temp[0]+"#"+temp[1]);
    
    int j=0,i=0;
    
    for (j=0;j<tempPair.length;j++)
    {
      String[] temp=tempPair[j].split(":");
      i=0;
      //if (temp.length>1)
      //  println("Processing:"+tempPair[j]+"["+temp[0]+"]"+"["+temp[1]+"]");

      if (temp[i].equals("byr"))
      {
        byr=temp[i+1];
      }
      if (temp[i].equals("iyr"))
      {
        iyr=temp[i+1];
      }
      if (temp[i].equals("eyr"))
      {
        eyr=temp[i+1];
      }
      if (temp[i].equals("hgt"))
      {
        hgt=temp[i+1];
      }
      if (temp[i].equals("hcl"))
      {
        hcl=temp[i+1];
      }
      if (temp[i].equals("ecl"))
      {
        ecl=temp[i+1];
      }
      if (temp[i].equals("pid"))
      {
        pid=temp[i+1];
      }
      if (temp[i].equals("cid"))
      {
        cid=temp[i+1];
      }
    }
  }
  
  public void printRecord()
  {
    if (byr!=null)
    {
      print("[byr:"+byr+"]");
    }
    if (iyr!=null)
    {
      print("[iyr:"+iyr+"]");
    }
    if (eyr!=null)
    {
      print("[eyr:"+eyr+"]");
    }
    if (hgt!=null)
    {
      print("[hgt:"+hgt+"]");
    }
    if (hcl!=null)
    {
      print("[hcl:"+hcl+"]");
    }
    if (ecl!=null)
    {
      print("[ecl:"+hcl+"]");
    }
    if (pid!=null)
    {
      print("[pid:"+pid+"]");
    }
    if (cid!=null)
    {
      print("[cid:"+cid+"]");
    }
  }
  
  public boolean validate()
  { 
    int fieldCheck=0;
    
    if (byr!=null)
    {
      fieldCheck++;
    }
    if (iyr!=null)
    {
      fieldCheck++;
    }
    if (eyr!=null)
    {
      fieldCheck++;
    }
    if (hgt!=null)
    {
      fieldCheck++;
    }
    if (hcl!=null)
    {
      fieldCheck++;
    }
    if (ecl!=null)
    {
      fieldCheck++;
    }
    if (pid!=null)
    {
      fieldCheck++;
    }
    if (cid!=null)
    {
      // ignore, as this is optional
      //fieldCheck++;
    }
    if (fieldCheck==7)
    {
       return(true);
    }
    return(false);
  }
}
