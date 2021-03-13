Program projeto_final;

var path: integer;
		key: char;
		xplayer,yplayer,xmovspeed,ymovspeed,objectcount,collidecheck: integer;
		xres,yres,x,y:integer;
		faceplayer: char;
		devmod: boolean;

//Testar Colis�o

procedure collide;

	Begin	
	if(xplayer >= x) and (xplayer <= (x+xres)) and (yplayer >= y) and (yplayer <= (y+yres)) then
		begin
			collidecheck := 1;
		end;
	End;
		
		
//Settings Procedure

procedure settings;

Begin
	clrscr;
	//Settings
	gotoxy(2,2);
	write(' Dev mode: ');
	read(devmod);
	clrscr;
End;				
				
//Wall Procedure
										
procedure wall(xres,yres,x,y:integer);

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

  collide;
	objectcount := objectcount + 1;
	
				
End;

//Menu Procedure

procedure menu;

var select: array [1..3] of string; 
		i: integer;
		key: char;
		out: boolean;

Begin

	//Atribui��o
	
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
		writeln(' ',select[2],' Defini��es ');
		gotoxy(10,9);
		writeln(' ',select[3],' Sair ');
		
		key := readkey;
		
		//L�gica
		
		case (key) of              
			'w': path := path-1;
			's': path := path+1;
			#13: Begin out := true; clrscr; end;	
		end;
		
		case (path) of            		
			0: path := 3;
			4: path := 1;
		end;
		
		//Graph Sele��o
		
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

	//Apagar o Player

	case(faceplayer)of
		'w': yplayerdelet := 1*ymovspeed; 
    's': yplayerdelet := -1*ymovspeed;
    'a': xplayerdelet := 1*xmovspeed;
    'd': xplayerdelet := -1*xmovspeed;
  end;
	
	gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet);
	write('       ');
	gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet+1);
  write('       ');
  gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet+2);
  write('       ');
	
  //Print Player
	
	textcolor(white);
	case(faceplayer)of
		'w':begin
					gotoxy(xplayer,yplayer);
					write('  ',#179,'',#136,'_');
					gotoxy(xplayer,yplayer+1);
  				write('  ',#197,'O',#206);
  				gotoxy(xplayer,yplayer+2);
  				write('  / \',' ');
				end;
					  
    's':begin
					gotoxy(xplayer,yplayer);
					write(' ',#179,' ',#136,' _');
					gotoxy(xplayer,yplayer+1);
  				write(' ',#197,'/O\',#206);
  				gotoxy(xplayer,yplayer+2);
  				write('  / \',#202,' ');
				end;	  
 		
    'a':begin
					gotoxy(xplayer,yplayer);
					write(' ',#179,' ',#136,'_');
					gotoxy(xplayer,yplayer+1);
  			 	write(' ',#197,'/O',#206);
  	 			gotoxy(xplayer,yplayer+2);
  				write('  ( ',#202,'');
				end;
					  
    'd':begin
						gotoxy(xplayer,yplayer);
					write('  ',#179,'',#136,' _');
					gotoxy(xplayer,yplayer+1);
  				write('  ',#197,'O\',#206);
  				gotoxy(xplayer,yplayer+2);
  				write('  / )',#202,' ');
				end;	  
  end;
	textcolor(cyan);
	
	  
	//L�gica
	
	case(key)of
		'w': begin yplayer := yplayer - ymovspeed; faceplayer := 'w'; end;
		's': begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end;
		'a': begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end;
		'd': begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end;
		#27: outplayer := true;		
	end;
	
End;

//Game Procedure

procedure game;

var out: boolean;
		i: integer;
    		
Begin

	//Atribui��es Iniciais
	
	out := false;
	ymovspeed := 2;
	xmovspeed := ymovspeed * 2;	
	xplayer := 10;	
  yplayer := 5;
	
	while(out = false) do
	Begin
	
	    objectcount := 0;
	
			//Frame

			wall(50,1,10,5);
			wall(2,50,10,5);
			wall(50,1,10,55);
			wall(2,50,58,5);
	
			//Platforms
	
			wall(35,1,10,30);
			wall(15,1,38,40);
			wall(35,1,10,48);
		
  //Dev

	if(devmod = true) then
	Begin
  gotoxy(2,2);
  writeln(' / Object Count = ',objectcount,' / Collidecheck=',collidecheck,' / Cords: x=',xplayer,' y=',yplayer);
	end;
		 
  //Input
  
	key := readkey;
	
	player;
  
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

//Atribui��es Iniciais

path := 0;

//Main Loop

//Default Settings
	devmod := true;
	
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