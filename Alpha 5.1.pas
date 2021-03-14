Program projeto_final;

var path: integer;
		key: char;
		xplayer,yplayer,xmovspeed,ymovspeed,objectcount,collidecheck: integer;
		xres,yres,x,y:integer;
		faceplayer: char;
		devmod: boolean;
		objectpos: array [1..50,1..4] of integer; 

//Testar Colisão

procedure collide;

var k: integer;

	Begin
		for k := 1 to objectcount do
		Begin	
			if(xplayer >= objectpos[k,3]) and (xplayer <= objectpos[k,1]) and (yplayer >= objectpos[k,4]) and (yplayer <= objectpos[k,2]) then
				begin
					collidecheck := 1;
				end;			
		End;
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
  
  objectcount := objectcount + 1;
  
  objectpos[objectcount,1] := xres+x-1;
  objectpos[objectcount,2] := yres+y-1;
  objectpos[objectcount,3] := x;
  objectpos[objectcount,4] := y;
				
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
		'w': begin yplayer := yplayer - ymovspeed; faceplayer := 'w'; end; 
		's': begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end; 
		'a': begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end; 
		'd': begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end; 
		#27: outplayer := true;		
	end;
	
	collide;

	if(collidecheck = 1) then
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
	
	gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet-1);
	write('       ');
	gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet);
  write('       ');
  gotoxy(xplayer+xplayerdelet,yplayer+yplayerdelet+1);
  write('       ');
	
  //Print Player
	
	textcolor(white);
	case(faceplayer)of
		'w':begin
					gotoxy(xplayer,yplayer-1);
					write('  ',#179,'',#136,'_');
					gotoxy(xplayer,yplayer);
  				write('  ',#197,'O',#206);
  				gotoxy(xplayer,yplayer+1);
  				write('  / \',' ');
				end;
					  
    's':begin
					gotoxy(xplayer,yplayer-1);
					write(' ',#179,' ',#136,' _');
					gotoxy(xplayer,yplayer);
  				write(' ',#197,'/O\',#206);
  				gotoxy(xplayer,yplayer+1);
  				write('  / \',#202,' ');
				end;	  
 		
    'a':begin
					gotoxy(xplayer,yplayer-1);
					write(' ',#179,' ',#136,'_');
					gotoxy(xplayer,yplayer);
  			 	write(' ',#197,'/O',#206);
  	 			gotoxy(xplayer,yplayer+1);
  				write('  ( ',#202,'');
				end;
					  
    'd':begin
						gotoxy(xplayer,yplayer-1);
					write('  ',#179,'',#136,' _');
					gotoxy(xplayer,yplayer);
  				write('  ',#197,'O\',#206);
  				gotoxy(xplayer,yplayer+1);
  				write('  / )',#202,' ');
				end;	  
  end;
	textcolor(cyan);
	
End;

//Game Procedure

procedure game;

var out: boolean;
		i,n,j: integer;
    		
Begin

	//Atribuições Iniciais
	
	out := false;
	ymovspeed := 2;
	xmovspeed := ymovspeed * 2;	
	xplayer := 20;	
  yplayer := 15;
	
	while(out = false) do
	Begin
	
	    collidecheck := 0;
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
		
  //Input
  
	key := readkey;
	
	player;
	
	//Dev

	textcolor(yellow);
	if(devmod = true) then
	Begin
  	gotoxy(2,2);
  	writeln(' / Object Count = ',objectcount,' / Collidecheck = ',collidecheck,' / Cords: x=',xplayer,' y=',yplayer);
		gotoxy(66,2);
		write('Objetos:');
		gotoxy(66,4);
		write('Xr  Yr  x   y');	
			for i := 1 to objectcount do
				begin
					j := 0;
					for n := 1 to 4 do
						begin
							j := j + 4;
							gotoxy(62+j,4+i); 
							write(objectpos[i,n]);
						end;
				end;				
			end;
	textcolor(cyan);		
		 
  
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