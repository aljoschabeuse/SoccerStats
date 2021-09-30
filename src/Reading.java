import java.io.*;
public class Reading {
	private LineNumberReader reader;
	
	public String[] reading(String filename) throws IOException {
		String dateiname = filename;
		BufferedReader br = new BufferedReader(new FileReader(dateiname));
		int anzahl = 0;
		String[] str = null;
		try { 
            String zeile = null; 
            while ((zeile = br.readLine()) != null) {
                anzahl++;
            } 
        } catch (IOException e) { 
            e.printStackTrace(); 
        } finally { 
            if (br != null) {
                try { 
                    br.close(); 
                } catch (IOException e) { 
                	System.out.println(e.getMessage());
                }
            }
        }
		str = new String[anzahl];
		for (int i = 0; i < anzahl; i++) {
			str[i] = getLineNumber(i + 1, dateiname);
		}
		return str;
	}
	
	public String getLineNumber(int num, String file) throws IOException {
	   reader = new LineNumberReader (new FileReader(file) );
	   for(int i = 0; i < num-1; i++)
	   reader.readLine();
	   return reader.readLine();	   
	}
}
