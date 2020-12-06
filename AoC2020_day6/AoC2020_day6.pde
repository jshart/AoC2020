import java.io.File;
import java.io.FileReader;
import java.io.IOException;

String[] lines;
int totalLines = 0;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day6\\data");

ArrayList<CustomsData> customsList = new ArrayList<CustomsData>();

int validPassports;

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  String customsString = new String();
  CustomsData tempCustoms;
  int rollingTotal=0;
 
  try {
    String line;
    
    File fl = new File(filebase+File.separator+"input.txt");
    FileReader frd = new FileReader(fl);
    BufferedReader brd = new BufferedReader(frd);
  
    while ((line=brd.readLine())!=null)
    {
      customsString +="*"+line;
      
      if (line.length()==0)
      {
        tempCustoms = new CustomsData(customsString);
        customsList.add(tempCustoms);
        
        customsString="";
        rollingTotal+=tempCustoms.getAnswers();
        println(); 
      }
    }
    brd.close();
    frd.close();

  } catch (IOException e) {
     e.printStackTrace();
  }
  
  println("Total Answers:"+rollingTotal);
}

void draw() {
  noLoop();
}

public class CustomsData
{
  int[] answers= new int[26];
  int totalAnswers=0;
  
  public CustomsData(String s)
  {    
    int i=0;
    for (i=0;i<26;i++)
    {
      answers[i]=0;
    }
    
    int len=s.length();
    int ansIndex=0;
    int grpMembers=1;
    
    // skip the first and last characters for this run as it saves us dealing with extra field deliminators.
    for (i=1;i<len-1;i++)
    {
        if (s.charAt(i)=='*')
        {
          grpMembers++;
        }
        // 97 is ascii 'a', so this converts a-z in ascii to a decimal number 0-25
        ansIndex=((int)s.charAt(i))-97;
        
        if (ansIndex>=0 && ansIndex<=25)
        {
          answers[ansIndex]+=1;
        }
    }
    
    print("grpMember:"+grpMembers+" raw data:"+s+" "); 
    for (i=0;i<26;i++)
    {
      print(answers[i]);
      if (answers[i]==grpMembers)
      {
         totalAnswers++;
      }
    }
    

    
  }
  
  public int getAnswers()
  { 
    return(totalAnswers);
  }
}
