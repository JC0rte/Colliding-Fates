Program projeto_final;

var 

		//Core
		
		path,turn: integer;
		key: char;
    	devmod,rgbplayer: boolean;
		
		//Player Position
		
		xspawn,yspawn,xplayer,yplayer,xmovspeed,ymovspeed: integer;   
		faceplayer: char;

		//Player Stats

		playerClass: string;
		statPoints: integer;
		statMelee,statMagic,statRange: integer;
		
		//Objetos
		
		objectcount,tpcount,collidecheck,teleportcheck,xres,yres,x,y:integer;  
		objectpos: array [1..100,1..4] of integer;
		objecttexture: array [1..100] of char;
		teleportpos: array [1..100,1..6] of integer;
	
//Procedure Player Pick

procedure playerStats;

var statspath,i: integer;
	out: boolean;
	select: array [1..3] of char;
	key: char;

Begin

clrscr;

statspath := 1;

	while(out = false) do
	begin
		

        
		textcolor(cyan);
		
		// Display
		gotoxy(64,25); write('   ',#179,'',#136,' _');
		gotoxy(64,26); write('   ',#197,'O\',#206);
		gotoxy(64,27); write('   / )',#202,' ');
		gotoxy(64,30);
		writeln(select[1],' Warrior ');
		gotoxy(94,25); write('  ',#143,' ',#245);
		gotoxy(94,26); write(' /H\',#197);
		gotoxy(94,27); write(' /_\',#179);
		gotoxy(94,30);
		writeln(select[2],' Mage ');
		gotoxy(124,25); write('   õ');
		gotoxy(124,26); write(' '#170'/O\i');
		gotoxy(124,27); write('  / \ ');
		gotoxy(124,30);
		writeln(select[3],' Gun Slinger ');
		
		key := readkey;
		
		//Logica
		
		case (key) of              
			'a': statspath := statspath-1;
			'd': statspath := statspath+1;
			#13: Begin out := true; clrscr; end;	
		end;
		
		case (statspath) of            		
			0: statspath := 3;
			4: statspath := 1;
		end;

		//Graph Selecao
		
		for i := 1 to 3 do
			begin                                  
				select[i] := #32
			end;
		select[statspath] := #62;
		
		if(statspath = 1) then
			begin
				playerClass := 'Warrior';
			end;
	 	 if(statspath = 2) then
	  		begin
	  			playerClass := 'Mage';
	  		end;
		 if(statspath = 3) then
	  		begin
	  			playerClass := 'Gun Slinger';
	  		end;

		if(playerClass = 'Warrior') then
			begin
				statMelee := 10;
				statMagic := -2;
				statRange := 2;
			end;

		if(playerClass = 'Mage') then
			begin
				statMelee := -4;
				statMagic := 10;
				statRange := 4;
			end;

		if(playerClass = 'Gun Slinger') then
			begin
				statMelee := 2;
				statMagic := -4;
				statRange := 12;
			end;  	  

	end;

End;

//Testar Colisao Com Objetos
                                    
function collide: integer;

var k: integer;

	Begin
		for k := 1 to objectcount do                                                         
		Begin
			if ((yplayer >= objectpos[k,2]) and (yplayer <= objectpos[k,2]+objectpos[k,4]) and (xplayer >= objectpos[k,1]) and (xplayer <= objectpos[k,1]+objectpos[k,3])) then    
				begin
					collide := 1;
				end;						
		End;
	End;
	

//Testar Colisao Com Portal

function teleportcollide: integer;

var k: integer;

	Begin
		for k := 1 to tpcount do
		Begin	
			if(xplayer >= teleportpos[k,1]) and (xplayer <= teleportpos[k,1]+teleportpos[k,3]) and (yplayer >= teleportpos[k,2]) and (yplayer <= teleportpos[k,2]+teleportpos[k,4]) then
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

	//Atribuicao
	
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
		
		//Logica
		
		case (key) of              
			'w': settingspath := settingspath-1;
			's': settingspath := settingspath+1;
			#13: Begin out := true; clrscr; end;	
		end;
		
		case (settingspath) of            		
			0: settingspath := 3;
			4: settingspath := 1;
		end;
		
		//Graph Selecao
		
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
				
//Object Store Procedure
										
procedure object(x,y,xres,yres: integer; texture:char; color: integer);

var i,n: integer;

Begin
	
	//Print
	
	for i := 1 to xres do
	begin                                     
		for n := 1 to yres do        
		begin
			textcolor(color);
			gotoxy(x+i-1,y+n-1);                          
			write(texture);
		end;
	end;
  
  objectcount := objectcount + 1;
  
  objectpos[objectcount,1] := x;
  objectpos[objectcount,2] := y;
  objectpos[objectcount,3] := xres;
  objectpos[objectcount,4] := yres;
				
End;

//Teleport Procedure

procedure teleport(x,y,xres,yres: integer; texture:char; color,link: integer); 

var i,n: integer;

Begin

	//Print
	
	for i := 1 to xres do
	begin                                     
		for n := 1 to yres do        
		begin
			textcolor(color);
			gotoxy(x+i-1,y+n-1);                          
			write(texture);
		end;
	end;

	tpcount := tpcount + 1;
  
  teleportpos[tpcount,1] := x;
  teleportpos[tpcount,2] := y;
  teleportpos[tpcount,3] := xres;
  teleportpos[tpcount,4] := yres;
  teleportpos[tpcount,5] := color;
  teleportpos[tpcount,6] := link;

End;

//Menu Procedure

procedure menu;

var select: array [1..3] of string; 
		i: integer;
		key: char;
		out: boolean;

Begin

	//Atribuicao
	
	out := false;
	path := 1;
		
	//Menu	
																													
	while(out = false) do
	begin
		
		textcolor(cyan);
		
		//Graph Selecao
		
		for i := 1 to 3 do
			begin                                  
				select[i] := (' ');
			end;
			
        select[path]:= ('>');
			              
		
		// Display

		gotoxy(3,5);  write('     ,gggg,                                                                               ,gggggggggggggg                                 ');
		gotoxy(3,6);  write('   ,88"""Y8b,            ,dPYb, ,dPYb,               8I                                  dP""""""88""""""         I8                      ');
		gotoxy(3,7);  write('  d8"     `Y8            IP `Yb IP `Yb               8I                                  Yb,_    88               I8                      ');
		gotoxy(3,8);  write(' d8    8b  d8            I8  8I I8  8I  gg           8I   gg                              `""    88            88888888                   ');
		gotoxy(3,9);  write(',8I    "Y88P             I8  8  I8  8   ""           8I   ""                                  ggg88gggg           I8                      ');
		gotoxy(3,10); write('I8             ,ggggg,   I8 dP  I8 dP   gg     ,gggg,8I   gg    ,ggg,,ggg,     ,gggg,gg          88   8,gggg,gg   I8    ,ggg,     ,g,     ');
		gotoxy(3,11); write('d8            dP"  "Y8gggI8dP   I8dP    88    dP"  "Y8I   88   ,8" "8P" "8,   dP"  "Y8I          88   dP"  "Y8I   I8   i8" "8i   ,8 8,    ');
		gotoxy(3,12); write('Y8,          i8     ,8I  I8P    I8P     88   i8     ,8I   88   I8   8I   8I  i8     ,8I    gg,   88  i8     ,8I  ,I8,  I8, ,8I  ,8   Yb   ');
		gotoxy(3,13); write('`Yba,,_____,,d8,   ,d8  ,d8b,_ ,d8b,_ _,88,_,d8,   ,d8b,_,88,_,dP   8I   Yb,,d8,   ,d8I     "Yb,,8P ,d8,   ,d8b,,d88b, `YbadP  ,8 _   8)  ');
		gotoxy(3,14); write('  `"Y8888888P"Y8888P"   8P "Y888P "Y888P""Y8P"Y8888P"`Y88P""Y88P    8I   `Y8P"Y8888P"888      "Y8P  P"Y8888P"`Y88P""Y8888P"Y888P  "YY8P8P ');
    gotoxy(3,15); write('                                                                               ,d8I                                                       ');
    gotoxy(3,16); write('                                                                             ,dP 8I                                                       ');
    gotoxy(3,17); write('                                                                            ,8"  8I                                                       ');
    gotoxy(3,18); write('                                                                            I8   8I                                                       ');
    gotoxy(3,19); write('                                                                            `8, ,8I                                                       ');
    gotoxy(3,20); write('                                                                             `Y8P"                                                        ');
		
		gotoxy(5,22); write(select[1],' INICIAR');
		gotoxy(5,24); write(select[2],' DEFENIÇÕES');
		gotoxy(5,26); write(select[3],' SAIR');

		key := readkey;
		
		//Logica
		
		case (key) of              
			'w': path := path-1;
			's': path := path+1;
			#13: Begin out := true; clrscr; end;
		end;
		
		case (path) of            		
			0: path := 3;
			4: path := 1;
		end;		
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
	  
	//L?gica
	
	case(key)of
		'r': begin xplayer := xspawn; yplayer := yspawn; end;
		'w': begin yplayer := yplayer - ymovspeed; faceplayer := 'w'; end; 
		's': begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end; 
		'a': begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end; 
		'd': begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end; 
		#27: outplayer := true;		
	end;
	
	//Colis?o
	
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
			temp := teleportpos[teleportcheck,6];
			xplayer := teleportpos[temp,1];
			yplayer := teleportpos[temp,2];
		end;	
	
	
  //Print Player
	
	textcolor(white);
	
	if(rgbplayer = true) then
		begin
			textcolor(turn);
		end;

	if(playerClass = 'Warrior') then	
	begin

	case(faceplayer)of
		'w':begin
					gotoxy(xplayer,yplayer-2);
					write('  ',#179,#136,'_');
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
  end;

  if(playerClass = 'Mage') then	
	begin

	case(faceplayer)of
		'w':begin
					gotoxy(xplayer,yplayer-2);
					write('  ',#143,#245);
					gotoxy(xplayer,yplayer-1);
  				write(' (H',#197);
  				gotoxy(xplayer,yplayer);
  				write(' /_\');
				end;
					  
    's':begin
					gotoxy(xplayer,yplayer-2);
					write('  ',#143,' ',#245);
					gotoxy(xplayer,yplayer-1);
  				write(' /H\',#197);
  				gotoxy(xplayer,yplayer);
  				write(' /_\',#179);
				end;	  
 		
    'a':begin
					gotoxy(xplayer,yplayer-2);
					write(' ',#245,' ',#143);
					gotoxy(xplayer,yplayer-1);
  			 	write(' ',#197'/H)');
  	 			gotoxy(xplayer,yplayer);
  				write(' ',#179,'(_\');
				end;
					  
    'd':begin
						gotoxy(xplayer,yplayer-2);
					write('  ',#143,' ',#245);
					gotoxy(xplayer,yplayer-1);
  				write(' (H\',#197);
  				gotoxy(xplayer,yplayer);
  				write(' /_)',#179);
				end;	  
   end;
   end;

    if(playerClass = 'Gun Slinger') then	
	begin

	case(faceplayer)of
		'w':begin
					gotoxy(xplayer,yplayer-2);
					write('   õ');
					gotoxy(xplayer,yplayer-1);
  				write('  (O)');
  				gotoxy(xplayer,yplayer);
  				write('  / \ ');
				end;
					  
    's':begin
					gotoxy(xplayer,yplayer-2);
					write('   õ');
					gotoxy(xplayer,yplayer-1);
  				write(' '#170'/O\i');
  				gotoxy(xplayer,yplayer);
  				write('  / \ ');
				end;	  
 		
    'a':begin
					gotoxy(xplayer,yplayer-2);
					write('   õ');
					gotoxy(xplayer,yplayer-1);
  			 	write(' ',#170,'/O)');
  	 			gotoxy(xplayer,yplayer);
  				write('  ( \ ');
				end;
					  
    'd':begin
						gotoxy(xplayer,yplayer-2);
					write('  õ');
					gotoxy(xplayer,yplayer-1);
  				write(' (O\i');
  				gotoxy(xplayer,yplayer);
  				write(' / ) ');
				end;	  
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
  	writeln('Teleport Count = ',tpcount);
  	gotoxy(218,6);
		writeln('CollideCheck = ',collidecheck);
		gotoxy(218,8);
		writeln('TeleportCheck = ',teleportcheck); 
		gotoxy(218,10);
		writeln('Cords: x=',xplayer,' y=',yplayer);
		gotoxy(218,12);
		writeln('Turn = ',turn);
		gotoxy(218,14);
		write('Objetos:');
		gotoxy(218,16);
		write('X   Y   Xr  Yr');
			
		for i := 1 to objectcount do
			begin
				j := 0;
				for n := 1 to 4 do
					begin
						j := j + 4;
						gotoxy(214+j,17+i); 
						write(objectpos[i,n]);
					end;
			end;
					
		textcolor(green);
	end;	
	
End;

// Stats Calc Procedure

procedure statCalc(statIndex: integer);

Begin

if(statPoints > 0) then
	begin
		statPoints := statPoints - 1; 
		case (statIndex) of
			1: statMelee := statMelee + 1;
			2: statMagic := statMagic + 1; 
			3: statRange := statRange + 1;
		end;	  
	end;
	
End;

//Procedure Keybinds

procedure keybinds;

var key: char;
	out: boolean;


Begin
	while (out = false) do
	Begin
		textcolor(cyan);
		gotoxy(60,8); write('Controlos:');
		gotoxy(60,13); write('W - Andar para cima ');
		gotoxy(60,14); write('A - Andar para baixo');
		gotoxy(60,15); write('S - Andar para a esquerda');
		gotoxy(60,16); write('D - Andar para a direita');
		gotoxy(60,17); write('"Tab" - Abrir a loja de pontos');
		gotoxy(60,24); write('Pressione "p" para sair.');
		object(24, 6, 2, 22, #219, 8);
		object(128, 6, 2, 22, #219, 8);
		object(25, 6, 104, 1, #219, 8);
		object(25, 27, 104, 1, #219, 8);
		object(25, 27, 104, 1, #219, 8);
		textcolor(green);

		key := readkey;

		case(key) of
			'p': begin out := true; clrscr; end;
		end;
	End;	
End;

//Procedure Shop

procedure shop;

var select: array [1..5] of char; 
	i,shoppath: integer;
	key: char;
	out: boolean;

Begin
	clrscr;
	shoppath := 1;
	  object(24, 6, 2, 22, #219, 8);
    object(128, 6, 2, 22, #219, 8);
    object(25, 6, 104, 1, #219, 8);
    object(25, 27, 104, 1, #219, 8);
    object(25, 27, 104, 1, #219, 8);

	while (out = false) do
	Begin
		gotoxy(27,8); write(select[1],'Melee: ', statMelee);
		gotoxy(27,10); write(select[2],'Magic: ', statMagic);
		gotoxy(27,12); write(select[3],'Range: ', statRange);
		gotoxy(40,8); write('Points Avaible: ', statPoints);
	
	//Logica

		key := readkey;
		
		case (key) of              
			'w': shoppath := shoppath-1;
			's': shoppath := shoppath+1;
			#13: statCalc(shoppath);
			#9: Begin out := true; clrscr; end;	
		end;
		
		case (shoppath) of            		
			0: shoppath := 3;
			4: shoppath := 1;
		end;

		//Graph Selecao
		
		for i := 1 to 3 do
			begin                                  
				select[i] := #32
			end;
		select[shoppath] := #62;
	
	End;
End;

//Game Procedure

procedure game;

var outmain,outturn: boolean;
		
Begin
	
	//Atribuicoes Iniciais do Jogo
	
	outturn := false;
	xspawn := 26;
	yspawn := 21;
	ymovspeed := 2;
	xmovspeed := ymovspeed * 2;
	
	//Provisóerio

	statPoints := 5;
	
	while(outturn = false) do
	Begin

	//Atribuicoes Iniciais dos Turnos
	
	outturn := false;	
	xplayer := xspawn;	
    yplayer := yspawn;
    turn := 0; 
	
	while(outturn = false) do
	Begin

		//Tips 
		
			textcolor(yellow);	
			gotoxy(130,3); write('"P" - Controlos');
			
		 
		 
		
		
		//Life Bar   
		
		Object(5,2,45,1,#220,8);
		Object(5,3,1,1,#219,8);
		Object(49,3,1,1,#219,8);
		Object(5,4,45,1,#223,8);
		Object(6,3,43,1,#219,4);
		 
		//Stats Frame
			
			object(153, 1, 57, 1,#219, 8);
  		object(153, 1, 2, 6,#219, 8);
   		object(208, 2, 2, 6,#219, 8);

		//Turn Reset

		turn := turn + 1;	
	    collidecheck := 0;
	    teleportcheck := 0;
	    objectcount := 0;
	    tpcount := 0;
	    
		//Stats Update
		textcolor(yellow);
		gotoxy(156,3); write('Melee: ', statMelee); gotoxy(172,3); write('Points Avaible: ', statPoints); 
		gotoxy(156,4); write('Magic: ', statMagic); gotoxy(172,4); write('Class: ', playerClass);
		gotoxy(156,5); write('Range: ', statRange);  

		if(playerClass = 'Warrior') then
		begin
			gotoxy(195,3); write('   ',#179,'',#136,' _');
			gotoxy(195,4); write('   ',#197,'O\',#206);
			gotoxy(195,5); write('   / )',#202,' ');	
		end;

			if(playerClass = 'Mage') then
		begin
			gotoxy(195,3); write('  ',#143,' ',#245);
			gotoxy(195,4); write(' /H\',#197);
			gotoxy(195,5); write(' /_\',#179);	
		end;

			if(playerClass = 'Gun Slinger') then
		begin
			gotoxy(195,3); write('   õ');
			gotoxy(195,4); write(' '#170'/O\i');
			gotoxy(195,5); write('  / \ ');	
		end;

		//Main Frame
		object(2, 7, 3, 42,#219, 8);
 		object(4, 7, 203, 1,#219, 8);
  	    object(207, 7, 3, 42,#219, 8);
 		object(4, 48, 203, 1,#219, 8);

		//Tp's  
		teleport(30,14,2,2,'T',5,2);
		teleport(60,14,2,2,'T',5,1);

  //Player Refresh
	
	player;

	if (devmod = true) then
	begin
		dev;
	end;
		
  //Input
  
	key := readkey;
  
	case (key) of
		#9 : shop;
		#27: begin outturn := true; outturn := true; end;
		'p': begin  clrscr; keybinds; end;
	else
		path := 1;	
	end;
	
	path := 0;	
	end;
	
	End;	
	End;

//Main Program

Begin

//Atribuicoes Iniciais

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
			playerStats;
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