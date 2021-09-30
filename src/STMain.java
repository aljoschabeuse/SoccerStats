import java.io.*;
import java.util.ArrayList;
public class STMain {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Reading r = new Reading();
		Writing w = new Writing();
		String readed = null;
		
		String[] spieler = new String[] {
				"Jonas Rotthues",
				"Sebastian Schlueter",
				"Bernhard Stennecken",
				"Bill Smidt",
				"Daniel Lorecchio",
				"Dominik Zellien",
				"Fabian Zellien",
				"Falko Elikmann",
				"Farssan Forodifard",
				"Julius Risau",
				"Luca WÃ¼nnemann",
				"Max Reuter",
				"Maximilian Achnitz",
				"Moritz Rotthues",
				"Philipp Zellien",
				"Sebastian Dircks",
				"Severin Pieper",
				"Tristan Kruse",
				"Enrico Can Descher",
				"Kai Knop",
				"Leon Hermening",
				"Laurin Daniel Pieper"
			};
		
		//Teilnahmen total ohne Spiele
		try {
			readed = r.reading("participationTotalWithoutGames.html")[2];
		} catch(IOException e) {
			System.out.println(e.getMessage());
		}		
		
		for (int i = 0; i < spieler.length; i++) {
			
			ArrayList<Character> numbersAsString = new ArrayList<Character>();
			String[] readedWords = readed.split(spieler[i]);
			try {
				String finalString = "";
				String c = "";
				if (((String) readedWords[1].subSequence(400, 1500)).contains("%/")) {
					c = (String) readedWords[1].subSequence(400,1500);
					c = c.split("&amp")[0];
					finalString = c.split("span>")[c.split("span>").length - 1];
				} else {
					c = (String) readedWords[1].subSequence(420, 790);
					finalString = c.split("span>")[1];
				}
				
				
				for (int j = 0; j < finalString.length(); j++) {
					if((int) finalString.charAt(j) > 47 && (int) finalString.charAt(j) < 58) {
						numbersAsString.add(finalString.charAt(j));
					} else {
						break;
					}
				}
				w.schreiben(".txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü"));
				System.out.print(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": ");
				String number = "";
				for (Character a : numbersAsString) {
					System.out.print(a);
					number += a;
				}
				try {
					if (i == 0) {
						w.schreiben("TrainingsteilnahmenTotalWithoutGames.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					} else {
						w.schreibenWeiter("TrainingsteilnahmenTotalWithoutGames.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					}
				} catch(Exception e) {
					System.out.println(e.getMessage());
				}
				System.out.println("");
			} catch(ArrayIndexOutOfBoundsException e) {
				System.out.println(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": 0e");
			}
		}
		
		//Teilnahmen total
		try {
			readed = r.reading("participationTotal.html")[2];
		} catch(IOException e) {
			System.out.println(e.getMessage());
		}
		for (int i = 0; i < spieler.length; i++) {
			
			ArrayList<Character> numbersAsString = new ArrayList<Character>();
			String[] readedWords = readed.split(spieler[i]);
			try {
				String finalString = "";
				String c = "";
				if (((String) readedWords[1].subSequence(400, 1500)).contains("%/")) {
					c = (String) readedWords[1].subSequence(400,1500);
					c = c.split("&amp")[0];
					finalString = c.split("span>")[c.split("span>").length - 1];
				} else {
					c = (String) readedWords[1].subSequence(420, 790);
					finalString = c.split("span>")[1];
				}
				
				
				for (int j = 0; j < finalString.length(); j++) {
					if((int) finalString.charAt(j) > 47 && (int) finalString.charAt(j) < 58) {
						numbersAsString.add(finalString.charAt(j));
					} else {
						break;
					}
				}
				w.schreiben(".txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü"));
				System.out.print(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": ");
				String number = "";
				for (Character a : numbersAsString) {
					System.out.print(a);
					number += a;
				}
				try {
					if (i == 0) {
						w.schreiben("TrainingsteilnahmenTotal.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					} else {
						w.schreibenWeiter("TrainingsteilnahmenTotal.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					}
				} catch(Exception e) {
					System.out.println(e.getMessage());
				}
				System.out.println("");
			} catch(ArrayIndexOutOfBoundsException e) {
				System.out.println(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": 0e");
			}
		}
		
		//Teilnahmen letzten Monat
		try {
			readed = r.reading("participationLastMonth.html")[2];
		} catch(IOException e) {
			System.out.println(e.getMessage());
		}
		for (int i = 0; i < spieler.length; i++) {
			
			ArrayList<Character> numbersAsString = new ArrayList<Character>();
			String[] readedWords = readed.split(spieler[i]);
			try {
				String finalString = "";
				String c = "";
				if (((String) readedWords[1].subSequence(400, 1500)).contains("%/")) {
					c = (String) readedWords[1].subSequence(400,1500);
					c = c.split("&amp")[0];
					finalString = c.split("span>")[c.split("span>").length - 1];
				} else {
					c = (String) readedWords[1].subSequence(420, 790);
					finalString = c.split("span>")[1];
				}
				
				
				for (int j = 0; j < finalString.length(); j++) {
					if((int) finalString.charAt(j) > 47 && (int) finalString.charAt(j) < 58) {
						numbersAsString.add(finalString.charAt(j));
					} else {
						break;
					}
				}
				w.schreiben(".txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü"));
				System.out.print(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": ");
				String number = "";
				for (Character a : numbersAsString) {
					System.out.print(a);
					number += a;
				}
				try {
					if (i == 0) {
						w.schreiben("TrainingsteilnahmenLastMonth.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					} else {
						w.schreibenWeiter("TrainingsteilnahmenLastMonth.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					}
				} catch(Exception e) {
					System.out.println(e.getMessage());
				}
				System.out.println("");
			} catch(ArrayIndexOutOfBoundsException e) {
				System.out.println(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": 0e");
			}
		}
		
		//Teilnahmen letzten Monat ohne Spiele
		try {
			readed = r.reading("participationLastMonthWithoutGames.html")[2];
		} catch(IOException e) {
			System.out.println(e.getMessage());
		}
		for (int i = 0; i < spieler.length; i++) {
			
			ArrayList<Character> numbersAsString = new ArrayList<Character>();
			String[] readedWords = readed.split(spieler[i]);
			try {
				String finalString = "";
				String c = "";
				if (((String) readedWords[1].subSequence(400, 1500)).contains("%/")) {
					c = (String) readedWords[1].subSequence(400,1500);
					c = c.split("&amp")[0];
					finalString = c.split("span>")[c.split("span>").length - 1];
				} else {
					c = (String) readedWords[1].subSequence(420, 790);
					finalString = c.split("span>")[1];
				}
				
				
				for (int j = 0; j < finalString.length(); j++) {
					if((int) finalString.charAt(j) > 47 && (int) finalString.charAt(j) < 58) {
						numbersAsString.add(finalString.charAt(j));
					} else {
						break;
					}
				}
				w.schreiben(".txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü"));
				System.out.print(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": ");
				String number = "";
				for (Character a : numbersAsString) {
					System.out.print(a);
					number += a;
				}
				try {
					if (i == 0) {
						w.schreiben("TrainingsteilnahmenLastMonthWithoutGames.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					} else {
						w.schreibenWeiter("TrainingsteilnahmenLastMonthWithoutGames.txt", spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+","+number);
					}
				} catch(Exception e) {
					System.out.println(e.getMessage());
				}
				System.out.println("");
			} catch(ArrayIndexOutOfBoundsException e) {
				System.out.println(spieler[i].replace("Ã¶", "ö").replace("Ã¼", "ü")+": 0e");
			}
		}
	}

}
