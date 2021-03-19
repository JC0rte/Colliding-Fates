Program projeto_final;

var path: integer;
		key: char;
		xspawn,yspawn,xplayer,yplayer,xmovspeed,ymovspeed: integer;   //Player
		objectcount,tpcount,collidecheck,teleportcheck,xres,yres,x,y:integer;   //Objects
		faceplayer: char;
		devmod,rgbplayer: boolean;
		objectsave: array [1..100,1..5] of integer;
		teleportpos: array [1..100,1..6] of integer;
		turn: integer;

//Testar Colisão
                                    
function collide: integer;

var k: integer;

	Begin
		for k := 1 to objectcount do
		Begin	
			if(xplayer >= objectsave[k,1]) and (xplayer <= objectsave[k,3]) and (yplayer >= objectsave[k,2]) and (yplayer <= objectsave[k,4]) and (objectsave[k,5] = 1) then
				begin
					collide := 1;
				end;
		End;
	End;
	

//Testar Colisão Com Portal

function teleportcollide: integer;

var k: integer;

	Begin
		for k := 1 to tpcount do
		Begin	
			if(xplayer >= teleportpos[k,1]) and (xplayer <= teleportpos[k,3]) and (yplayer >= teleportpos[k,2]) and (yplayer <= teleportpos[k,4]) then
				begin
					teleportcollide := k;
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
										
procedure object(x,y,xres,yres: integer; texture:char; wall:integer);

var i,n: integer;

Begin
	
	//Regenerar
	
	for i := 1 to xres do
	begin                                     
		for n := 1 to yres do        
		begin
			gotoxy(x+i-1,y+n-1);                          
			write(texture);
		end;
	end;
  
  objectcount := objectcount + 1;
  
  objectsave[objectcount,1] := x;
  objectsave[objectcount,2] := y;
  objectsave[objectcount,3] := xres+x;
  objectsave[objectcount,4] := yres+y;
  objectsave[objectcount,5] := wall;
				
End;

//Teleport Procedure

procedure teleport(x,y,xres,yres,link: integer); 
Begin

	tpcount := tpcount + 1;
  
	teleportpos[tpcount,1] := x;
  teleportpos[tpcount,2] := y;
  teleportpos[tpcount,3] := xres+x;
  teleportpos[tpcount,4] := yres+y;
  teleportpos[tpcount,5] := link;

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
		temp: integer;

Begin

 
	//Apagar o Player
	
	gotoxy(xplayer,yplayer-2);
	write('       ');
	gotoxy(xplayer,yplayer-1);
  write('       ');
  gotoxy(xplayer,yplayer);
  write('       ');


  collide;	
	  
	//Lógica
	
	case(key)of
		'r': begin xplayer := xspawn; yplayer := yspawn; end;
		'w': begin yplayer := yplayer - ymovspeed; faceplayer := 'w'; end; 
		's': begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end; 
		'a': begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end; 
		'd': begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end; 
		#27: outplayer := true;		
	end;
	
	//Colisão
	
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
		
	//Tp
	
	teleportcheck := 0;
	teleportcheck := teleportcollide;
	
	if(teleportcheck <> 0) then
		begin
			temp := teleportpos[teleportcheck,5];
			xplayer := teleportpos[temp,1];
			yplayer := teleportpos[temp,2];
		end;	
	
	
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
		writeln('TeleportCheck = ',teleportcheck); 
		gotoxy(218,8);
		writeln('Cords: x=',xplayer,' y=',yplayer);
		gotoxy(218,10);
		writeln('Turn = ',turn);
		gotoxy(218,12);
		write('Objetos:');
		gotoxy(218,14);
		write('X   Y   Xr  Yr');
			
		for i := 1 to objectcount do
			begin
				j := 0;
				for n := 1 to 4 do
					begin
						j := j + 4;
						gotoxy(214+j,14+i); 
						write(objectsave[i,n]);
					end;
			end;
					
		textcolor(green);
	end;	
	
End;

//Game Procedure

procedure game;

var outmain,outturn: boolean;
		
Begin
	
	//Atribuições Iniciais do Jogo
	
	outturn := false;
	xspawn := 20;
	yspawn := 15;
	ymovspeed := 2;
	xmovspeed := ymovspeed * 2;
	
	while(outturn = false) do
	Begin

	//Atribuições Iniciais dos Turnos
	
	outturn := false;	
	xplayer := xspawn;	
  yplayer := yspawn;
  turn := 0;
	
	while(outturn = false) do
	Begin

			//Turn Reset

			turn := turn + 1;	
	    collidecheck := 0;
	    teleportcheck := 0;
	    objectcount := 0;
	    tpcount := 0;
	    
			//Frame

			textcolor(cyan);
			object(10,10,2,50,#178,1);
			object(12,10,200,1,#178,1);
			object(212,10,2,50,#178,1);
			object(12,59,200,1,#178,1);
		  textcolor(green);
		  
		  //Obstaculos
		  object(50,30,1,20,#178,1);
		  object(65,30,2,20,#160,1);
		  object(80,30,3,20,#178,1);
		  object(123,23,20,1,#170,1);
		  object(133,23,20,2,#173,1);
		  
		  //Tp´s
		  
		  teleport(30,14,5,5,2);
		  teleport(60,14,5,5,1);
		  object(30,14,5,5,#130,0);
		  object(60,14,5,5,#130,0);

  //Player Refresh
	
	player;

	if (devmod = true) then
	begin
		dev;
	end;
		
  //Input
  
	key := readkey;
  
	case (key) of
		#27: begin outturn := true; outturn := true; end;
	else
		path := 1;	
	end;
	
	path := 0;	
	end;
	
	End;	
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