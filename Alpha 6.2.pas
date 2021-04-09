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

		playerHealth: integer;
		playerName: string;
		playerClass: string;
		statPoints: integer;
		statMelee,statMagic,statRange: integer;
		
		//Objetos
		
		objectcount,tpcount,bosscount,collidecheck,teleportcheck,bosscheck,xres,yres,x,y:integer;  
		objectpos: array [1..100,1..4] of integer;
		objecttexture: array [1..100] of char;
		teleportpos: array [1..100,1..6] of integer;
		bossPos: array [1..100,1..6] of integer;

	
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
		writeln(select[1],' Knight ');
		gotoxy(94,25); write('  ',#143,' ',#245);
		gotoxy(94,26); write(' /H\',#197);
		gotoxy(94,27); write(' /_\',#179);
		gotoxy(94,30);
		writeln(select[2],' Mage ');
		gotoxy(124,25); write('   O');
		gotoxy(124,26); write(' '#170'/O\i');
		gotoxy(124,27); write('  / \ ');
		gotoxy(124,30);
		writeln(select[3],' Gun Slinger ');
		
		key := readkey;
		
		//Logica
		
		case (key) of              
			'a': statspath := statspath-1;
			'd': statspath := statspath+1;
			#13: Begin gotoxy(94,21); write('Nome: '); read(playerName); out := true; clrscr; end;	
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
				playerClass := 'Knight';
			end;
	 	 if(statspath = 2) then
	  		begin
	  			playerClass := 'Mage';
	  		end;
		 if(statspath = 3) then
	  		begin
	  			playerClass := 'Gun Slinger';
	  		end;

		if(playerClass = 'Knight') then
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

//Testar Colisao Com Boss

function bosscollide: integer;

var k: integer;

	Begin
		for k := 1 to bossCount do
		Begin	
			if(xplayer >= bossPos[k,1]) and (xplayer <= bossPos[k,1]+bossPos[k,3]) and (yplayer >= bossPos[k,2]) and (yplayer <= bossPos[k,2]+bossPos[k,4]) then
				begin
					bosscollide := k;
				end;		
		End;
	End;	

//Fight Procedure

procedure fightObject(x,y,xres,yres: integer; texture:char; color,bossHealth: integer);

var i,n: integer;

Begin

	//Print Boss
	
	for i := 1 to xres do
	begin                                     
		for n := 1 to yres do        
		begin
			textcolor(color);
			gotoxy(x+i-1,y+n-1);                          
			write(texture);
		end;
	end;

	bossCount := bossCount + 1;
  
  bossPos[bossCount,1] := x;
  bossPos[bossCount,2] := y;
  bossPos[bossCount,3] := xres;
  bossPos[bossCount,4] := yres;
  bossPos[bossCount,5] := color;
  bossPos[bossCount,6] := bossHealth;

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
										
procedure object(x,y,xres,yres,color: integer; texture:char);

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

//Fight Procedure Screen

procedure fightScreen(bossHealth: integer);

var out: boolean;
	key: char;
	fightpath,i,n: integer;
	select: array [1..4] of string;
	atacks: array [1..3,1..3] of string;

Begin
	clrscr;

	//Atribuicao Inicial do Nome dos Ataques

	//Knight

	atacks[1,1] := 'Espadada';
	atacks[1,2] := 'Pregaminho';
	atacks[1,3] := 'Pedrada';

	//Mage

	atacks[2,1] := 'Tacada';
	atacks[2,2] := 'Bola de Fogo';
	atacks[2,3] := 'Flechada';

	//Gun Slinger

	atacks[3,1] := 'Placagem';
	atacks[3,2] := 'Rezar';
	atacks[3,3] := 'Disparar';

	
	//Main Frame
		object(2, 6, 3, 42, 8, #219);
 		object(4, 6, 203, 1, 8, #219);
  	    object(205, 6, 3, 42, 8, #219);
		object(4, 40, 203, 1, 8, #219);
 		object(4, 47, 203, 1, 8, #219);

	//Life Bar Player  
		
		Object(8,36,45,1,8, #220);
        Object(8,37,1,1,8,#219);
        Object(52,37,1,1,8,#219);
        Object(8,38,45,1,8,#223);

	//Health Display Player

        Object(9,37,playerHealth,1,4,#219);	

	//Life Bar Boss  
		
		Object(156,26,45,1,8, #220);
        Object(156,27,1,1,8,#219);
        Object(200,27,1,1,8,#219);
        Object(156,28,45,1,8,#223);

	//Health Display Boss

        Object(157,27,bossHealth,1,4,#219);		

	//Atribuicoes	 
	
		fightpath := 1;

	//Player Sprite

		textcolor(white);

		if(playerClass = 'Knight') then
		begin
			gotoxy(27,33); write('   ',#179,'',#136,' _');
			gotoxy(27,34); write('   ',#197,'O\',#206);
			gotoxy(27,35); write('   / )',#202,' ');	
		end;

		if(playerClass = 'Mage') then
		begin
			gotoxy(27,33); write('  ',#143,' ',#245);
			gotoxy(27,34); write(' /H\',#197);
			gotoxy(27,35); write(' /_\',#179);	
		end;

	    if(playerClass = 'Gun Slinger') then
		begin
			gotoxy(27,33); write('   O');
			gotoxy(27,34); write(' '#170'/O\i');
			gotoxy(27,35); write('  / \ ');	
		end;

	while (out = false) do
	Begin
	
	textcolor(white);
								
	if (playerClass = 'Knight') then n := 1;

	if (playerClass = 'Mage') then 	n := 2;

	if (playerClass = 'Gun Slinger') then n := 3;

	gotoxy(10,43);  write(select[1],atacks[n,1]);
	gotoxy(48,43);  write(select[2],atacks[n,2]);
	gotoxy(88,43);  write(select[3],atacks[n,3]);
	gotoxy(160,43);  write(select[4],'Fugir ');			
	
	textcolor(white);

	//Logica

		key := readkey;
		
		case (key) of              
			'a': fightpath := fightpath-1;
			'd': fightpath := fightpath+1;
			#13: begin

					//Sair

					if(fightpath = 4) then
						begin
							out := true;
							clrscr;
						end;

					//Mele Atack

					if(fightpath <> 4) then
						begin
							gotoxy(8,8); write('                                       ');
							gotoxy(8,8); write(playerName, ' usou ', atacks[n,fightpath]);
						end;

				end;			 
		end;
		
		case (fightpath) of            		
			0: fightpath := 4;
			5: fightpath := 1;
		end;

		//Graph Selecao
		
		for i := 1 to 4 do
			begin                                  
				select[i] := #32
			end;
		select[fightpath] := #62;
	
	End;	
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
		gotoxy(5,24); write(select[2],' DEFENICOES');
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
	
	//Colisoes
	
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
	
	//Boss

	bosscheck := 0;
	bosscheck := bosscollide;

	if(bosscollide <> 0) then
		begin
			fightScreen(bossPos[bosscheck,6]);
		end;

  //Print Player
	
	textcolor(white);
	
	if(rgbplayer = true) then
		begin
			textcolor(turn);
		end;

	if(playerClass = 'Knight') then	
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
					write('   O');
					gotoxy(xplayer,yplayer-1);
  				write('  (O)');
  				gotoxy(xplayer,yplayer);
  				write('  / \ ');
				end;
					  
    's':begin
					gotoxy(xplayer,yplayer-2);
					write('   O');
					gotoxy(xplayer,yplayer-1);
  				write(' '#170'/O\i');
  				gotoxy(xplayer,yplayer);
  				write('  / \ ');
				end;	  
 		
    'a':begin
					gotoxy(xplayer,yplayer-2);
					write('   O');
					gotoxy(xplayer,yplayer-1);
  			 	write(' ',#170,'/O)');
  	 			gotoxy(xplayer,yplayer);
  				write('  ( \ ');
				end;
					  
    'd':begin
						gotoxy(xplayer,yplayer-2);
					write('  O');
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
		object(24, 6, 2, 22,8, #219);
		object(128, 6, 2, 22,8, #219);
		object(25, 6, 104, 1,8, #219);
		object(25, 27, 104, 1,8, #219);
		object(25, 27, 104, 1,8, #219);
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
	  object(24, 6, 2, 22, 8, #219);
    object(128, 6, 2, 22, 8, #219);
    object(25, 6, 104, 1, 8, #219);
    object(25, 27, 104, 1, 8, #219);
    object(25, 27, 104, 1, 8, #219);

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
	xspawn := 13;
	yspawn := 13;
	ymovspeed := 1;
	xmovspeed := ymovspeed * 2;
	playerHealth := 40;
	
	//Provisorio

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
			
		 
		//Main Frame
		object(2, 6, 3, 42, 8, #219);
 		object(4, 6, 203, 1, 8, #219);
  	    object(205, 6, 3, 42, 8, #219);
 		object(4, 47, 203, 1, 8, #219);
		
		//Life Bar   
		
		Object(5,2,45,1,8, #220);
        Object(5,3,1,1,8,#219);
        Object(49,3,1,1,8,#219);
        Object(5,4,45,1,8,#223);

        Object(6,3,playerHealth,1,4,#219);
		 
		//Stats Frame
			
		object(153, 1, 55, 1, 8, #219);
  		object(153, 1, 2, 6, 8, #219);
   		object(206, 2, 2, 6, 8, #219);

		//Turn Reset

		turn := turn + 1;	
	    collidecheck := 0;
	    teleportcheck := 0;
	    objectcount := 0;
	    tpcount := 0;
		bosscount := 0;
	    
		//Stats Update
		textcolor(yellow);
		gotoxy(156,2); write('Stats:');				 gotoxy(172,2); write('Classe:');
		gotoxy(156,3); write('Melee - ', statMelee); gotoxy(172,3); write('Points Avaible - ', statPoints); 
		gotoxy(156,4); write('Magic - ', statMagic); gotoxy(172,4); write('Class - ', playerClass);
		gotoxy(156,5); write('Range - ', statRange);  

		if(playerClass = 'Knight') then
		begin
			gotoxy(195,2); write('   ',#179,'',#136,' _');
			gotoxy(195,3); write('   ',#197,'O\',#206);
			gotoxy(195,4); write('   / )',#202,' ');	
		end;

			if(playerClass = 'Mage') then
		begin
			gotoxy(195,2); write('  ',#143,' ',#245);
			gotoxy(195,3); write(' /H\',#197);
			gotoxy(195,4); write(' /_\',#179);	
		end;

			if(playerClass = 'Gun Slinger') then
		begin
			gotoxy(195,2); write('   O');
			gotoxy(195,3); write(' '#170'/O\i');
			gotoxy(195,4); write('  / \ ');	
		end;

		{Mundo 1
		 object(5,    7, 201, 3 , 3, #219);
  		 object(5,   44, 201, 3 , 3, #219);
  		 object(5,   10, 7,   34, 3, #219);
  		 object(199, 10, 7,   34, 3, #219);
  		 object(179, 10, 10,  29, 3, #219);
  		 object(189, 10, 10,  5 , 3, #219);
  		 object(159, 15, 20,  29, 3, #219);
  		 object(129, 15, 20,  24, 3, #219);
  		 object(149, 15, 10,  5 , 3, #219);
  		 object(119, 10, 10,  29, 3, #219);
  		 object(109, 15, 10,  24, 3, #219);
  		 object(89,  15, 10,  24, 3, #219);
  		 object(79,  15, 10,  24, 3, #219);
  		 object(69,  39, 20,  5 , 3, #219);
  		 object(69,  34, 10,  5 , 3, #219);
  		 object(59,  34, 10,  10, 3, #219);
  		 object(69,  15, 10,  19, 3, #219);
  		 object(22,  15, 47,  14, 3, #219);
  		 object(12,  34, 37,  5 , 3, #219);
  		 object(12,  34, 37,  5 , 3, #219);}

		//Mundo 2

		object(9  , 9 ,  2 ,  36,  3,   #219);
   		object(200, 9 ,  2 ,  36,  3,   #219);
   		object(11 , 9 ,  189, 1 ,  3,   #219);
   		object(11 , 44,  189, 1 ,  3,   #219);
   		object(180, 38,  10,  1 ,  3,   #219);
   		object(178, 38,  2 ,  6 ,  3,   #219);
   		object(188, 16,  2 ,  22,  3,   #219);
   		object(188, 15,  12,  1 ,  3,   #219);
   		object(160, 20,  2 ,  24,  3,   #219);
   		object(148, 20,  2 ,  19,  3,   #219);
   		object(150, 20,  10,  1 ,  3,   #219);
   		object(148, 15,  34,  1 ,  3,   #219);
   		object(138, 15,  10,  1 ,  3,   #219);
   		object(128, 15,  10,  1 ,  3,   #219);
   		object(128, 10,  2 ,  5 ,  3,   #219);
   		object(180, 10,  2 ,  5 ,  3,   #219);
   		object(120, 10,  2 ,  5 ,  3,   #219);
   		object(110, 15,  12,  1 ,  3,   #219);
   		object(110, 16,  2 ,  23,  3,   #219);
   		object(112, 38,  36,  1 ,  3,   #219);
   		object(90 , 38,  10,  1 ,  3,   #219);
   		object(88 , 38,  2 ,  6 ,  3,   #219);
   		object(98 , 15,  2 ,  23,  3,   #219);
   		object(60 , 34,  2 ,  10,  3,   #219);
   		object(62 , 34,  10,  1 ,  3,   #219);
   		object(70 , 29,  2 ,  5 ,  3,   #219);
   		object(21 , 28,  51,  1 ,  3,   #219);
   		object(11 , 34,  39,  1 ,  3,   #219);
   		object(11 , 38,  39,  1 ,  3,   #219);
   		object(48 , 35,  2 ,  3 ,  3,   #219);
   		object(21 , 15,  2 ,  13,  3,   #219);
   		object(23 , 15,  75,  1 ,  3,   #219);
		object(90 , 39,  1 ,  4 , 2 ,   #219);
		object(130 , 10,  1 ,  4 , 2 ,  #219); 
		object(180 , 39,  1 ,  4 , 2 ,  #219); 
 
		//Tps

   		teleport(90 , 43,  1 ,  1 , #219,  2, 1);
   		teleport(130, 14,  1 ,  1 , #219,  2, 2);
   		teleport(180, 43,  1 ,  1 , #219,  2, 3);
   		teleport(158, 39,  1 ,  5 , #219,  5, 3);
   		teleport(178, 10,  1 ,  5 , #219,  5, 1);
   		teleport(68 , 29,  1 ,  5 , #219,  5, 2);   

		//Boss  
 
		fightObject(30,10,5,5,'N',4,34);

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