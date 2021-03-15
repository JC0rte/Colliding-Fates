Program projeto_final;

var path: integer;
		key: char;
		xplayer,yplayer,xmovspeed,ymovspeed,objectcount,collidecheck: integer;
		xres,yres,x,y:integer;
		faceplayer: char;
		devmod,rgbplayer: boolean;
		objectpos: array [1..100,1..4] of integer;
		turn: integer; 

//Testar Colisão

function collide: integer;

var k: integer;

	Begin
		for k := 1 to objectcount do
		Begin	
			if(xplayer >= objectpos[k,1]) and (xplayer <= objectpos[k,3]) and (yplayer >= objectpos[k,2]) and (yplayer <= objectpos[k,4]) then
				begin
					collide := 1;
				end;			
		End;
	End;	
		
//Settings Procedure

procedure settings;

var select: array [1..3] of string; 
		settingspath,i: integer;
		key: char;
		out: boolean;

Begin

	//Atribuição
	
	settingspath := 1;
	select[settingspath] := #62;
	out := false;
		
	//Menu das Settings	
																													
	while(out = false) do
	begin
		
		textcolor(cyan);
		
		// Display
		
		gotoxy(10,5);
		writeln(' Dev Mode: ');
		gotoxy(10,7);
		writeln(' ',select[1],' On ');
		gotoxy(10,9);
		writeln(' ',select[2],' Off ');
		gotoxy(10,20);
		writeln(' ',select[3],' Sair ');
		
		key := readkey;
		
		//Lógica
		
		case (key) of              
			'w': settingspath := settingspath-1;
			's': settingspath := settingspath+1;
			#13: Begin out := true; clrscr; end;	
		end;
		
		case (settingspath) of            		
			0: settingspath := 3;
			4: settingspath := 1;
		end;
		
		//Graph Seleção
		
		for i := 1 to 3 do
			begin                                  
				select[i] := #32
			end;
		select[settingspath] := #62;
		
		if(settingspath = 1) then
			begin
				devmod := true;
			end;
	  if(settingspath = 2) then
	  	begin
	  		devmod := false;
	  	end;	
			                  
	end;
	
End;
				
//Wall Procedure
										
procedure object(x,y,xres,yres:integer);

var i,n: integer;

Begin
	
	//Regenerar
	
	for i := 1 to xres do
	begin                                     
		for n := 1 to yres do        
		begin
			gotoxy(x+i-1,y+n-1);                          
			write(#178);
		end;
	end;
  
  objectcount := objectcount + 1;
  
  objectpos[objectcount,1] := x;
  objectpos[objectcount,2] := y;
  objectpos[objectcount,3] := xres+x;
  objectpos[objectcount,4] := yres+y;
				
End;

//Menu Procedure

procedure menu;

var select: array [1..3] of string; 
		i: integer;
		key: char;
		out: boolean;

Begin

	//Atribuição
	
	path := 1;
	select[path] := #62;
	out := false;
		
	//Menu	
																													
	while(out = false) do
	begin
		
		textcolor(cyan);
		
		// Display
		
		gotoxy(10,5);
		writeln(' ',select[1],' Iniciar ');
		gotoxy(10,7);
		writeln(' ',select[2],' Definições ');
		gotoxy(10,9);
		writeln(' ',select[3],' Sair ');
		
		key := readkey;
		
		//Lógica
		
		case (key) of              
			'w': path := path-1;
			's': path := path+1;
			#13: Begin out := true; clrscr; end;	
		end;
		
		case (path) of            		
			0: path := 3;
			4: path := 1;
		end;
		
		//Graph Seleção
		
		for i := 1 to 3 do
			begin                                  
				select[i] := #32
			end;
		select[path] := #62;
			                  
	end;
	
End;

//Player Procedure

procedure player;

var outplayer: boolean;
		xplayerdelet,yplayerdelet: integer; 

Begin

 collide;	
	  
	//Lógica
	
	case(key)of
		'r': begin xplayer := 15; yplayer := 15; end;
		'w': begin yplayer := yplayer - ymovspeed; faceplayer := 'w'; end; 
		's': begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end; 
		'a': begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end; 
		'd': begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end; 
		#27: outplayer := true;		
	end;
	
	collidecheck := collide;

	if((collidecheck = 1) or (xplayer < xmovspeed) or (yplayer < ymovspeed)) then
		begin
			case(key)of
				'w': begin yplayer := yplayer + ymovspeed; faceplayer := 'w'; end; 
				's': begin yplayer := yplayer - ymovspeed; faceplayer := 's'; end;
				'a': begin xplayer := xplayer + xmovspeed; faceplayer := 'a'; end;
				'd': begin xplayer := xplayer - xmovspeed; faceplayer := 'd'; end;	
			end;	
		end;	
	


	//Apagar o Player

	case(faceplayer)of
		'w': yplayerdelet := 1*ymovspeed; 
    's': yplayerdelet := -1*ymovspeed;
    'a': xplayerdelet := 1*xmovspeed;
    'd': xplayerdelet := -1*xmovspeed;
  end;
	
	gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet-2);
	write('       ');
	gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet-1);
  write('       ');
  gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet);
  write('       ');
	
  //Print Player
	
	textcolor(white);
	
	if(rgbplayer = true) then
		begin
			textcolor(turn);
		end;	
	case(faceplayer)of
		'w':begin
					gotoxy(xplayer,yplayer-2);
					write('  ',#179,'',#136,'_');
					gotoxy(xplayer,yplayer-1);
  				write('  ',#197,'O',#206);
  				gotoxy(xplayer,yplayer);
  				write('  / \',' ');
				end;
					  
    's':begin
					gotoxy(xplayer,yplayer-2);
					write(' ',#179,' ',#136,' _');
					gotoxy(xplayer,yplayer-1);
  				write(' ',#197,'/O\',#206);
  				gotoxy(xplayer,yplayer);
  				write('  / \',#202,' ');
				end;	  
 		
    'a':begin
					gotoxy(xplayer,yplayer-2);
					write(' ',#179,' ',#136,'_');
					gotoxy(xplayer,yplayer-1);
  			 	write(' ',#197,'/O',#206);
  	 			gotoxy(xplayer,yplayer);
  				write('  ( ',#202,'');
				end;
					  
    'd':begin
						gotoxy(xplayer,yplayer-2);
					write('  ',#179,'',#136,' _');
					gotoxy(xplayer,yplayer-1);
  				write('  ',#197,'O\',#206);
  				gotoxy(xplayer,yplayer);
  				write('  / )',#202,' ');
				end;	  
  end;
	textcolor(cyan);
	
End;
	
//Dev Procedure

procedure dev;

var i,n,j: integer;

Begin

textcolor(yellow);
	Begin
  	gotoxy(218,2);
  	writeln('Object Count = ',objectcount);
  	gotoxy(218,4);
		writeln('CollideCheck = ',collidecheck); 
		gotoxy(218,6);
		writeln('Cords: x=',xplayer,' y=',yplayer);
		gotoxy(218,8);
		write('Objetos:');
		gotoxy(218,10);
		write('X   Y   Xr  Yr');
			
		for i := 1 to objectcount do
			begin
				j := 0;
				for n := 1 to 4 do
					begin
						j := j + 4;
						gotoxy(214+j,10+i); 
						write(objectpos[i,n]);
					end;
			end;
					
		textcolor(green);
	end;	
	
End;

//Game Procedure

procedure game;

var out: boolean;
		
Begin

	//Atribuições Iniciais
	
	out := false;
	ymovspeed := 2;
	xmovspeed := ymovspeed * 2;	
	xplayer := 20;	
  yplayer := 15;
  turn := 0;
	
	while(out = false) do
	Begin

			//Turn Reset

			turn := turn + 1;	
	    collidecheck := 0;
	    objectcount := 0;
	
			//Frame

			textcolor(cyan);
			object(10,10,2,50);
			object(12,10,200,1);
			object(212,10,2,50);
			object(12,59,200,1);
		  textcolor(green);
		  
		  //Obstaculos
		  object(50,30,1,20);
		  object(65,30,2,20);
		  object(80,30,3,20);
		  object(123,23,20,1);
		  object(133,23,20,2);

  //Player Refresh
	
	player;

	if (devmod = true) then
	begin
		dev;
	end;
		
  //Input
  
	key := readkey;
  
	case (key) of
		#27: out := true;
	else
		path := 1;	
	end;
	
	path := 0;	
	end;
End;	


//Main Program

Begin

//Atribuições Iniciais

path := 0;
devmod := true;

//Main Loop

	cursoroff;
	repeat
		while(path = 0) do
		begin
			menu;
		end;	
		while(path = 1) do
		begin
			game;
			clrscr;
  	end;
    while(path = 2) do
   	begin
   		settings;
   		path := 0;
   	end;
   	
  until(path = 3);
End.