import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class Writing {
	public void schreiben (String name, String inhalt) {
		PrintWriter pWriter = null;
		try { 
            pWriter = new PrintWriter(new BufferedWriter(new FileWriter(name))); 
            pWriter.println(inhalt); 
        } catch (IOException ioe) { 
            ioe.printStackTrace(); 
        } finally { 
            if (pWriter != null){ 
                pWriter.flush(); 
                pWriter.close(); 
            } 
        }
	}
	
	public void schreibenWeiter (String name, String inhalt) {
		FileWriter writer ;
		File datei = new File(name);
		
		try {
			writer = new FileWriter(datei, true);
			writer.write(inhalt);
			writer.write(System.getProperty("line.separator"));
			writer.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
