package sudoku20421689;

import java.io.IOException;

public class CoreOperations implements CoreInterface{

	
	ConstraintSolverInterface csin= null;
	FileInterface fi = null;
	//String[] args = null;
	
	public CoreOperations(/*String[] args*/)
	{
		//this.args =args;
	}
	
	@Override
	public int[][] read(String fileName, int inputType) throws IOException 
	{
		
		if(inputType == 1)
			fi = new CompactFile();
		else
			fi = new FullFile();
		
			return fi.readFile(fileName);
		

	}
	
	@Override
	public int[][][] SolveSudoku(int[][] puzzle, int solverId) {
		
		if(solverId == 1){
			csin = new ChocoSolver();
		}else{
			csin = new CreamSolver();
		}
		
		return csin.SolveSudoku(puzzle);
	}

	@Override
	public boolean validateSudoku(int[][][] puzzles) {
		// validate i�lemleri yap sadece her b�r cozum �c�n
		//arada hatal� cozum gorursen [i][0][0] = 0 bas
		//donustede [i][0][0] kontrol et 0 olanlar� es ge�icez
		int lenght = puzzles.length;
		int i=0,j=0,k=0,toplam=0;
		boolean result = true;
		for(k=0; k< lenght; k++) //her puzzle kontrol et
		{
			toplam =0;
			result=true;
			for(i=0; i<9; i++)
			{
				for(j=0; j<9; j++)
				{
					toplam += puzzles[k][i][j];
				}
				if(toplam !=45){
					result = false;
					break;
				}
			}
			if(!result)
			{
				puzzles[k][0][0] = 0;
			}
			
		}
		
		for(k=0; k< lenght; k++) //her puzzle kontrol et
		{
			toplam =0;
			result=true;
			if(puzzles[k][0][0] != 0)
			{
				for(i=0; i<9; i++)
				{
					for(j=0; j<9; j++)
					{
						toplam += puzzles[k][j][i];
					}
					if(toplam !=45){
						result = false;
						break;
					}
				}
				if(!result)
				{
					puzzles[k][0][0] = 0;
				}
			}
			
		}
		
		
		
		
		return false;
	}

	@Override
	public void writeSolutions(int[][][] puzzles,String fileName,int outputType) throws IOException {
		//yaz�lacak dosyay� dongude ac kac sonuc varsa o kadar dosya yaz�lcak
		//sudoku say�s�na gore dosyalar� solution-1.compact (mesela) numaraland�r
		
		try {
			if(outputType == 1)
				fi = new CompactFile();
			else
				fi = new FullFile();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		int lenght = puzzles.length;
		int count = 0;
		String file = "";
		System.out.println("yazd�rma i�indeyim puzzle uzunlugu = " + puzzles.length);
		for(int i=0; i< lenght; i++)
		{
			if(puzzles[i][0][0] != 0)
			{
				//count tut ona gore �s�mlend�r sudokuhard->count>.full g�b�
				count++;   //cou�ntu u dosya ad�na ekle
				
				   ///dosya ad� sudokuharsolutions.full
				//bunun donusmes� gereken sekl� = sudokuhardsolut�ons-1.hard
				//araya count un g�rmes� laz�m
				//val�date s�md�l�k kapal� 0 l�yor bosu bosuna 
				file = fileName + "-"  + count; 
				fi.writeFile(file, puzzles[i]);
			}

		}
	}



}
