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
		statDinheiro: integer;
		statMelee,statMagic,statRange: integer;

		//Items

		itemCura,itemDano: integer;
		
		//Objetos
		
		objectcount,tpcount,bosscount,collidecheck,teleportcheck,xres,yres,x,y:integer;  
		objectpos: array [1..9000,1..4] of integer;
		objecttexture: array [1..9000] of char;
		teleportpos: array [1..100,1..6] of integer;
		bossPos: array [1..100,1..6] of integer;
		bossState: array [1..100] of string;
		bosscheck: integer;

		k: integer;


//Texto do Inicio

procedure conversa;

Begin

	clrscr;
	textcolor(13);
	gotoxy(5,2); write('-Colliding Fates-');
	delay(5000);
	textcolor(14);
	gotoxy(5,5); write('Episódio 1:');
	gotoxy(5,6); write('A vida é escura, o caminho é longo. A luz é a imaginação.');
	textcolor(15);
	delay(6000);
	gotoxy(5,8); write('Bem vindo.');
	delay(3000);
	textcolor(3);
	gotoxy(5,9); write('Onde é que estou?');
	delay(3000);
	textcolor(15);
	gotoxy(5,10); write('O que é que sentes?');
	delay(3000);
	textcolor(3);
	gotoxy(5,11); write('Nada.');
	delay(3000);
	textcolor(15);
	gotoxy(5,12); write('O que é que vês?');
	delay(3000);
	textcolor(3);
	gotoxy(5,13); write('Não tenho a certeza...');
	delay(3000);
	textcolor(15);
	gotoxy(5,14); write('Estás pronto?');
	delay(3000);
	textcolor(3);
	gotoxy(5,15); write('Pronto para quê?');
	delay(3000);
	textcolor(15);
	gotoxy(5,16); write('Para a aventura que te espera.');
	delay(3000);
	textcolor(3);
	gotoxy(5,17); write('Não... ');
	delay(2000);
	write('não estou pronto... ');
	delay(2000);
	write('nem sequer sei quem sou, ou onde estou.');
	delay(3000);
	textcolor(15);
	gotoxy(5,18); write('E porque é que isso deveria importar?');
	delay(3000);
	textcolor(3);
	gotoxy(5,19); write('Não sei.');
	delay(3000);
	textcolor(15);
	gotoxy(5,22); write('Pressiona "ENTER" para continuar.');
	readln;
	clrscr;

End;

//Instrutions Procedure

procedure instructions;

Begin

		textcolor(cyan);
		gotoxy(3,2); write('Controlos:');
		delay(1000);
		gotoxy(3,4); write('W / ↑ - Andar para cima ');
		gotoxy(3,5); write('S / ↓ - Andar para baixo');
		gotoxy(3,6); write('A / ← - Andar para a esquerda');
		gotoxy(3,7); write('D / → - Andar para a direita');
		delay(2000);
		gotoxy(3,9); write('"Tab" - Abrir a loja de pontos');
		delay(2000);
		gotoxy(3,11); write('"P" - Para aceder aos comandos durante o jogo');
		delay(2000);
		gotoxy(3,15); write('"ENTER" - Para continuar');

		readln;

End;		

	
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
		
		textcolor(yellow);
		gotoxy(88,19); write('- Selecione a Classe -');
        
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
      #75: statspath := statspath-1;
			'd': statspath := statspath+1;
      #77: statspath := statspath+1;
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
				statMelee := 8;
				statMagic := 0;
				statRange := 2;
			end;

		if(playerClass = 'Mage') then
			begin
				statMelee := 0;
				statMagic := 6;
				statRange := 4;
			end;

		if(playerClass = 'Gun Slinger') then
			begin
				statMelee := 2;
				statMagic := 0;
				statRange := 8;
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

procedure fightObject(x,y,xres,yres: integer; texture:char; color: integer);

var i,n: integer;

Begin

  bossCount := bossCount + 1;

  if(bossState[bossCount] <> 'dead') then
  begin

  	//Print Boss

    bossPos[bossCount,1] := x;
    bossPos[bossCount,2] := y;
    textcolor(color);
    gotoxy(x,y);
    writeln('  /|  /\ ');
    gotoxy(x,(y+1));
    writeln(' |o) (o |');
    gotoxy(x,(y+2));
    writeln(' //| / /');
    gotoxy(x,(y+3));
    writeln(' (^ ^)/ |');
    gotoxy(x,(y+4));
    writeln(' |__ /');

    bossPos[bossCount,3] := xres;
    bossPos[bossCount,4] := yres;
    bossPos[bossCount,5] := color;

  end
  else
  begin
    bossPos[bossCount,1] := 0;
    bossPos[bossCount,2] := 0;
    bossPos[bossCount,3] := 0;
    bossPos[bossCount,4] := 0;
    bossPos[bossCount,5] := 0;
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

//Settings Procedure

procedure settings;

var select: array [1..5] of string; 
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

    object(24, 6, 2, 22, 14, #219);
    object(128, 6, 2, 22, 14, #219);
    object(25, 6, 104, 1, 14, #219);
    object(25, 27, 104, 1, 14, #219);
    object(25, 27, 104, 1, 14, #219);
		
    textcolor(white);
		gotoxy(28,8);
		writeln(' Dev Mode: ');
		gotoxy(28,10);
    if(devmod = true) then textcolor(cyan);
		writeln(' ',select[1],' On ');
    if(devmod = true) then textcolor(white);
		gotoxy(28,11);
    if(devmod = false) then textcolor(cyan);
		writeln(' ',select[2],' Off ');
    if(devmod = false) then textcolor(white);
    gotoxy(28,13);
		writeln(' RGB Player: ');
    gotoxy(28,15);
    if(rgbplayer = true) then textcolor(cyan);
		writeln(' ',select[3],' On ');
    if(rgbplayer = true) then textcolor(white);
    gotoxy(28,16);
    if(rgbplayer = false) then textcolor(cyan);
		writeln(' ',select[4],' Off ');
    if(rgbplayer = false) then textcolor(white);
    if(devmod = false) then textcolor(white);
		gotoxy(28,25);
		writeln(' ',select[5],' Sair ');
		
		key := readkey;
		
		//Logica
		
		case (key) of              
			'w': settingspath := settingspath-1;
      #72: settingspath := settingspath-1;
			's': settingspath := settingspath+1;
      #80: settingspath := settingspath+1;
			#13: Begin 
              if(settingspath = 5) then 
                begin 
                  out := true; clrscr; 
                end;

              if(settingspath = 1) then
			          begin
				          devmod := true;
		            end;
	            if(settingspath = 2) then
	            	begin
	  	          	devmod := false;
	            	end;
              if(settingspath = 3) then
	            	begin
	  	          	rgbplayer := true;
	            	end;
               if(settingspath = 4) then
	            	begin
	  	          	rgbplayer := false;
	            	end;	   	   	   
           end;	
		end;
		
		case (settingspath) of            		
			0: settingspath := 5;
			6: settingspath := 1;
		end;
		
		//Graph Selecao
		
		for i := 1 to 5 do
			begin                                  
				select[i] := #32
			end;
		select[settingspath] := #62;
			                  
	end;
	
End;

//Cobra

procedure cobraSprite;

Begin
   object(169, 29,  4 ,  1,   2 ,  #219);
   object(176, 28,  4 ,  1,   2 ,  #219);
   object(182, 27,  1 ,  1,   2 ,  #219);
   object(177, 26,  2 ,  1,   2 ,  #219);
   object(171, 25,  4 ,  1,   2 ,  #219);
   object(174, 27,  8 ,  1,   10,  #219);
   object(166, 28,  10,  1,   10,  #219);
   object(165, 27,  5 ,  1,   10,  #219);
   object(179, 26,  5 ,  1,   10,  #219);
   object(175, 25,  6 ,  1,   10,  #219);
   object(171, 24,  5 ,  1,   10,  #219);
   object(178, 23,  5 ,  1,   10,  #219);
   object(185, 22,  1 ,  1,   10,  #219);
   object(184, 21,  1 ,  1,   10,  #219);
   object(183, 20,  1 ,  1,   10,  #219);
   object(182, 19,  1 ,  1,   10,  #219);
   object(164, 26,  3 ,  1,   10,  #219);
   object(164, 25,  2 ,  1,   10,  #219);
   object(165, 23,  1 ,  2,   10,  #219);
   object(166, 21,  1 ,  2,   10,  #219);
   object(167, 20,  1 ,  2,   10,  #219);
   object(168, 17,  1 ,  4,   10,  #219);
   object(167, 22,  1 ,  2,   2 ,  #219);
   object(166, 23,  1 ,  3,   2 ,  #219);
   object(167, 26,  1 ,  1,   2 ,  #219);
   object(184, 22,  1 ,  1,   2 ,  #219);
   object(183, 21,  1 ,  1,   2 ,  #219);
   object(169, 17,  1 ,  2,   2 ,  #219);
   object(170, 16,  1 ,  1,   2 ,  #219);
   object(171, 15,  2 ,  1,   2 ,  #219);
   object(172, 14,  2 ,  1,   2 ,  #219);
   object(173, 12,  2 ,  2,   2 ,  #219);
   object(172, 12,  1 ,  1,   2 ,  #219);
   object(167, 11,  7 ,  1,   2 ,  #219);
   object(159, 11,  7 ,  1,   2 ,  #219);
   object(158, 12,  2 ,  1,   2 ,  #219);
   object(158, 13,  1 ,  1,   2 ,  #219);
   object(159, 14,  1 ,  1,   2 ,  #219);
   object(160, 15,  1 ,  1,   2 ,  #219);
   object(163, 12,  1 ,  2,   2 ,  #219);
   object(164, 14,  1 ,  1,   2 ,  #219);
   object(165, 15,  1 ,  1,   2 ,  #219);
   object(167, 15,  1 ,  1,   2 ,  #219);
   object(168, 14,  1 ,  1,   2 ,  #219);
   object(169, 12,  1 ,  2,   2 ,  #219);
   object(166, 12,  1 ,  1,   2 ,  #219);
   object(166, 13,  1 ,  1,   10,  #219);
   object(164, 13,  1 ,  1,   10,  #219);
   object(168, 13,  1 ,  1,   10,  #219);
   object(162, 16,  1 ,  1,   10,  #219);
   object(163, 17,  2 ,  1,   10,  #219);
   object(164, 18,  1 ,  1,   10,  #219);
   object(166, 15,  1 ,  1,   4 ,  #219);
   object(167, 16,  1 ,  1,   4 ,  #219);
   object(165, 17,  3 ,  3,   14,  #219);
   object(164, 20,  3 ,  1,   14,  #219);
   object(163, 22,  3 ,  1,   14,  #219);
   object(162, 23,  3 ,  1,   14,  #219);
   object(162, 24,  3 ,  1,   14,  #219);
   object(161, 25,  3 ,  1,   14,  #219);
   object(161, 26,  3 ,  1,   14,  #219);
   object(162, 27,  3 ,  1,   14,  #219);
   object(164, 28,  2 ,  1,   14,  #219);
   object(164, 21,  2 ,  1,   14,  #219);
   object(164, 16,  3 ,  1,   14,  #219);
   object(168, 16,  1 ,  1,   14,  #219);
   object(168, 15,  1 ,  1,   14,  #219);
   object(169, 14,  1 ,  1,   14,  #219);
   object(164, 15,  1 ,  1,   14,  #219);
   object(163, 14,  1 ,  1,   14,  #219);
   object(183, 18,  1 ,  1,   6 ,  #219);
   object(160, 12,  3 ,  3,   10,  #219);
   object(170, 12,  2 ,  3,   10,  #219);
   object(169, 15,  2 ,  1,   10,  #219);
   object(161, 15,  3 ,  1,   10,  #219);
   object(163, 16,  1 ,  1,   10,  #219);
   object(159, 13,  1 ,  1,   10,  #219);
   object(172, 13,  1 ,  1,   10,  #219);
   object(169, 16,  1 ,  1,   10,  #219);
   object(163, 10,  1 ,  1,   2 ,  #220);
   object(162, 10,  1 ,  1,   2 ,  #220);
   object(161, 10,  1 ,  1,   2 ,  #220);
   object(166, 11,  1 ,  1,   2 ,  #220);
   object(169, 10,  1 ,  1,   2 ,  #220);
   object(170, 10,  1 ,  1,   2 ,  #220);
   object(171, 10,  1 ,  1,   2 ,  #220);
   object(165, 13,  1 ,  1,   2 ,  #220);
   object(167, 13,  1 ,  1,   2 ,  #220);
   object(164, 12,  1 ,  1,   4 ,  #220);
   object(168, 12,  1 ,  1,   4 ,  #220);
   object(166, 14,  1 ,  1,   4 ,  #220);
   object(183, 22,  1 ,  1,   2 ,  #220);
   object(170, 24,  1 ,  1,   2 ,  #220);
   object(169, 24,  1 ,  1,   2 ,  #220);
   object(174, 11,  1 ,  1,   2 ,  #220);
   object(158, 11,  1 ,  1,   2 ,  #220);
   object(177, 23,  1 ,  1,   10,  #220);
   object(176, 23,  1 ,  1,   10,  #220);
   object(175, 23,  1 ,  1,   10,  #220);
   object(174, 23,  1 ,  1,   10,  #220);
   object(182, 22,  1 ,  1,   10,  #220);
   object(176, 24,  1 ,  1,   10,  #223);
   object(177, 24,  1 ,  1,   10,  #223);
   object(178, 24,  1 ,  1,   10,  #223);
   object(184, 23,  1 ,  1,   10,  #223);
   object(182, 20,  1 ,  1,   10,  #223);
   object(162, 17,  1 ,  1,   10,  #223);
   object(161, 16,  1 ,  1,   2 ,  #223);
   object(170, 17,  1 ,  1,   2 ,  #223);
   object(171, 16,  1 ,  1,   2 ,  #223);
   object(167, 12,  1 ,  1,   2 ,  #223);
   object(165, 12,  1 ,  1,   10,  #223);
   object(165, 12,  1 ,  1,   2 ,  #223);
   object(167, 14,  1 ,  1,   15,  #223);
   object(165, 14,  1 ,  1,   15,  #223);
   object(180, 28,  1 ,  1,   2 ,  #223);
   object(181, 28,  1 ,  1,   2 ,  #223);
   object(183, 27,  1 ,  1,   2 ,  #223);
   object(176, 29,  1 ,  1,   2 ,  #223);
   object(175, 29,  1 ,  1,   2 ,  #223);
   object(174, 29,  1 ,  1,   2 ,  #223);
   object(173, 29,  1 ,  1,   2 ,  #223);
   object(168, 29,  1 ,  1,   2 ,  #223);
   object(167, 29,  1 ,  1,   2 ,  #223);
   object(163, 28,  1 ,  1,   14,  #223);
   object(166, 29,  1 ,  1,   14,  #223);
   object(165, 29,  1 ,  1,   14,  #223);
   object(176, 26,  1 ,  1,   2 ,  #223);
   object(175, 26,  1 ,  1,   2 ,  #223);
   object(174, 26,  1 ,  1,   2 ,  #223);
   object(170, 25,  1 ,  1,   2 ,  #223);
   object(169, 25,  1 ,  1,   2 ,  #223);
   object(183, 23,  1 ,  1,   10,  #223);
   object(183, 23,  1 ,  1,   2 ,  #223);
   object(181, 25,  1 ,  1,   2 ,  #220);
   object(182, 25,  1 ,  1,   2 ,  #220);
   object(182, 25,  1 ,  1,   10,  #220);
   object(181, 25,  1 ,  1,   10,  #220);
   object(184, 17,  1 ,  1,   6 ,  #220);
   object(173, 27,  1 ,  1,   10,  #220);
   object(172, 27,  1 ,  1,   10,  #220);
   object(171, 27,  1 ,  1,   10,  #220);
   object(170, 27,  1 ,  1,   10,  #220);
   object(163, 21,  1 ,  1,   14,  #220);

End;   

//Minotauro

procedure minotauroSprite;

Begin
   object(167, 29,  2,   1,   8,   #219);
   object(169, 27,  1,   2,   8,   #219);
   object(170, 26,  1,   1,   8,   #219);
   object(168, 25,  2,   1,   8,   #219);
   object(169, 23,  2,   2,   8,   #219);
   object(168, 22,  2,   1,   8,   #219);
   object(168, 21,  1,   1,   8,   #219);
   object(167, 23,  1,   1,   8,   #219);
   object(166, 24,  1,   2,   8,   #219);
   object(167, 26,  1,   1,   8,   #219);
   object(174, 26,  1,   1,   8,   #219);
   object(175, 27,  1,   2,   8,   #219);
   object(177, 22,  1,   5,   8,   #219);
   object(175, 25,  1,   1,   8,   #219);
   object(174, 24,  1,   1,   8,   #219);
   object(176, 23,  1,   1,   8,   #219);
   object(175, 22,  2,   1,   8,   #219);
   object(176, 21,  1,   1,   8,   #219);
   object(178, 24,  1,   1,   8,   #219);
   object(178, 25,  1,   1,   8,   #219);
   object(176, 29,  2,   1,   8,   #219);
   object(168, 18,  1,   1,   8,   #219);
   object(167, 17,  1,   1,   8,   #219);
   object(167, 15,  1,   1,   8,   #219);
   object(165, 16,  2,   1,   8,   #219);
   object(164, 18,  2,   1,   8,   #219);
   object(165, 17,  1,   1,   8,   #219);
   object(162, 19,  2,   1,   8,   #219);
   object(161, 20,  2,   1,   8,   #219);
   object(163, 16,  1,   2,   8,   #219);
   object(164, 15,  1,   1,   8,   #219);
   object(165, 14,  1,   1,   8,   #219);
   object(178, 20,  1,   1,   8,   #219);
   object(179, 19,  2,   1,   8,   #219);
   object(181, 18,  1,   1,   8,   #219);
   object(182, 17,  1,   1,   8,   #219);
   object(182, 16,  2,   1,   8,   #219);
   object(181, 15,  2,   1,   8,   #219);
   object(179, 14,  2,   1,   8,   #219);
   object(176, 13,  2,   1,   8,   #219);
   object(167, 13,  2,   1,   8,   #219);
   object(170, 12,  1,   1,   8,   #219);
   object(174, 12,  1,   1,   8,   #219);
   object(169, 11,  3,   1,   8,   #219);
   object(173, 11,  3,   1,   8,   #219);
   object(169, 10,  1,   1,   8,   #219);
   object(170, 9 ,  2,   1,   8,   #219);
   object(173, 9 ,  2,   1,   8,   #219);
   object(175, 10,  1,   1,   8,   #219);
   object(168, 16,  1,   1,   8,   #219);
   object(170, 16,  1,   1,   8,   #219);
   object(171, 15,  1,   2,   8,   #219);
   object(173, 15,  1,   2,   8,   #219);
   object(174, 16,  1,   1,   8,   #219);
   object(176, 16,  1,   1,   8,   #219);
   object(177, 16,  3,   1,   8,   #219);
   object(177, 15,  1,   1,   8,   #219);
   object(180, 17,  1,   1,   8,   #219);
   object(179, 18,  1,   1,   8,   #219);
   object(177, 19,  1,   1,   8,   #219);
   object(176, 17,  2,   1,   8,   #219);
   object(174, 18,  3,   1,   8,   #219);
   object(175, 19,  1,   1,   8,   #219);
   object(174, 17,  1,   1,   8,   #219);
   object(172, 17,  1,   3,   8,   #219);
   object(170, 17,  1,   2,   8,   #219);
   object(166, 22,  1,   2,   12,  #219);
   object(167, 20,  1,   2,   12,  #219);
   object(168, 20,  1,   1,   12,  #219);
   object(169, 21,  3,   1,   12,  #219);
   object(173, 21,  3,   1,   12,  #219);
   object(170, 22,  5,   1,   12,  #219);
   object(171, 23,  3,   1,   12,  #219);
   object(172, 24,  2,   1,   12,  #219);
   object(172, 25,  1,   1,   12,  #219);
   object(177, 21,  1,   1,   12,  #219);
   object(178, 22,  1,   1,   12,  #219);
   object(177, 20,  1,   1,   6,   #219);
   object(176, 20,  1,   1,   6,   #219);
   object(169, 20,  1,   1,   6,   #219);
   object(168, 19,  1,   1,   6,   #219);
   object(172, 21,  1,   1,   14,  #219);
   object(172, 20,  1,   1,   14,  #219);
   object(173, 24,  1,   1,   4,   #219);
   object(173, 23,  1,   1,   4,   #219);
   object(172, 25,  1,   1,   4,   #219);
   object(172, 24,  1,   1,   4,   #219);
   object(173, 22,  1,   1,   4,   #219);
   object(174, 22,  1,   1,   4,   #219);
   object(174, 21,  1,   1,   4,   #219);
   object(175, 21,  1,   1,   4,   #219);
   object(177, 21,  1,   1,   4,   #219);
   object(178, 22,  1,   1,   4,   #219);
   object(170, 22,  1,   1,   4,   #219);
   object(169, 21,  1,   1,   4,   #219);
   object(166, 23,  1,   1,   4,   #219);
   object(167, 21,  1,   1,   4,   #219);
   object(167, 22,  1,   1,   7,   #219);
   object(168, 23,  1,   2,   7,   #219);
   object(167, 24,  1,   2,   7,   #219);
   object(168, 27,  1,   2,   7,   #219);
   object(176, 27,  1,   2,   7,   #219);
   object(175, 23,  1,   2,   7,   #219);
   object(176, 24,  1,   2,   7,   #219);
   object(175, 26,  2,   1,   7,   #219);
   object(168, 26,  2,   1,   7,   #219);
   object(174, 23,  1,   1,   7,   #219);
   object(172, 14,  1,   1,   14,  #219);
   object(166, 14,  6,   1,   7,   #219);
   object(173, 14,  6,   1,   7,   #219);
   object(174, 15,  3,   1,   7,   #219);
   object(168, 15,  3,   1,   7,   #219);
   object(165, 15,  2,   1,   7,   #219);
   object(178, 15,  3,   1,   7,   #219);
   object(180, 16,  2,   1,   7,   #219);
   object(170, 19,  2,   1,   7,   #219);
   object(173, 19,  2,   1,   7,   #219);
   object(171, 17,  1,   2,   7,   #219);
   object(173, 17,  1,   2,   7,   #219);
   object(172, 15,  1,   2,   7,   #219);
   object(175, 16,  1,   2,   7,   #219);
   object(169, 17,  1,   2,   7,   #219);
   object(168, 17,  1,   1,   7,   #219);
   object(167, 16,  1,   1,   7,   #219);
   object(164, 16,  1,   2,   7,   #219);
   object(163, 18,  1,   1,   7,   #219);
   object(161, 19,  1,   1,   7,   #219);
   object(180, 18,  1,   1,   7,   #219);
   object(181, 17,  1,   1,   7,   #219);
   object(172, 12,  1,   1,   7,   #219);
   object(172, 11,  1,   1,   7,   #219);
   object(172, 10,  1,   1,   7,   #219);
   object(169, 9 ,  1,   1,   6,   #219);
   object(168, 8 ,  1,   1,   6,   #219);
   object(167, 8 ,  1,   1,   6,   #219);
   object(167, 7 ,  1,   1,   6,   #219);
   object(166, 7 ,  1,   1,   6,   #219);
   object(168, 6 ,  1,   1,   6,   #219);
   object(175, 9 ,  1,   1,   6,   #219);
   object(176, 8 ,  1,   1,   6,   #219);
   object(177, 8 ,  1,   1,   6,   #219);
   object(177, 7 ,  1,   1,   6,   #219);
   object(178, 7 ,  1,   1,   6,   #219);
   object(176, 6 ,  1,   1,   6,   #219);
   object(161, 18,  1,   1,   6,   #219);
   object(160, 17,  1,   1,   6,   #219);
   object(160, 16,  1,   1,   6,   #219);
   object(160, 15,  1,   1,   8,   #219);
   object(159, 14,  1,   3,   8,   #219);
   object(158, 15,  1,   3,   8,   #219);
   object(157, 15,  1,   2,   8,   #219);
   object(156, 15,  1,   2,   7,   #219);
   object(156, 17,  2,   1,   7,   #219);
   object(155, 16,  1,   1,   7,   #219);
   object(158, 18,  1,   1,   7,   #219);
   object(155, 15,  1,   1,   7,   #220);
   object(154, 15,  1,   1,   7,   #220);
   object(171, 12,  1,   1,   7,   #220);
   object(173, 12,  1,   1,   7,   #220);
   object(174, 10,  1,   1,   4,   #220);
   object(170, 10,  1,   1,   4,   #220);
   object(168, 10,  1,   1,   8,   #220);
   object(172, 9 ,  1,   1,   8,   #220);
   object(176, 10,  1,   1,   8,   #220);
   object(168, 12,  1,   1,   8,   #220);
   object(176, 12,  1,   1,   8,   #220);
   object(169, 16,  1,   1,   8,   #220);
   object(175, 16,  1,   1,   8,   #220);
   object(178, 18,  1,   1,   8,   #220);
   object(181, 14,  1,   1,   8,   #220);
   object(178, 13,  1,   1,   8,   #220);
   object(179, 13,  1,   1,   8,   #220);
   object(177, 28,  1,   1,   8,   #220);
   object(178, 29,  1,   1,   8,   #220);
   object(166, 29,  1,   1,   8,   #220);
   object(167, 28,  1,   1,   8,   #220);
   object(162, 18,  1,   1,   8,   #220);
   object(166, 13,  1,   1,   8,   #220);
   object(167, 19,  1,   1,   6,   #220);
   object(170, 20,  1,   1,   6,   #220);
   object(175, 20,  1,   1,   6,   #220);
   object(174, 20,  1,   1,   6,   #220);
   object(173, 20,  1,   1,   14,  #220);
   object(171, 20,  1,   1,   14,  #220);
   object(169, 13,  1,   1,   7,   #220);
   object(170, 13,  1,   1,   7,   #220);
   object(174, 13,  1,   1,   7,   #220);
   object(175, 13,  1,   1,   7,   #220);
   object(158, 14,  1,   1,   8,   #220);
   object(169, 8 ,  1,   1,   6,   #220);
   object(170, 8 ,  1,   1,   6,   #220);
   object(175, 8 ,  1,   1,   6,   #220);
   object(174, 8 ,  1,   1,   6,   #220);
   object(177, 6 ,  1,   1,   6,   #220);
   object(167, 6 ,  1,   1,   6,   #220);
   object(168, 11,  1,   1,   8,   #223);
   object(169, 12,  1,   1,   8,   #223);
   object(171, 13,  1,   1,   8,   #223);
   object(173, 13,  1,   1,   8,   #223);
   object(175, 12,  1,   1,   8,   #223);
   object(176, 11,  1,   1,   8,   #223);
   object(172, 13,  1,   1,   7,   #223);
   object(173, 10,  1,   1,   7,   #223);
   object(171, 10,  1,   1,   7,   #223);
   object(169, 19,  1,   1,   8,   #223);
   object(176, 19,  1,   1,   8,   #223);
   object(179, 20,  1,   1,   8,   #223);
   object(183, 17,  1,   1,   8,   #223);
   object(182, 18,  1,   1,   8,   #223);
   object(166, 17,  1,   1,   8,   #223);
   object(164, 19,  1,   1,   8,   #223);
   object(163, 21,  1,   1,   6,   #223);
   object(165, 24,  1,   1,   4,   #223);
   object(179, 23,  1,   1,   4,   #223);
   object(176, 9 ,  1,   1,   6,   #223);
   object(178, 8 ,  1,   1,   6,   #223);
   object(168, 9 ,  1,   1,   6,   #223);
   object(166, 8 ,  1,   1,   6,   #223);
   object(157, 18,  1,   1,   7,   #223);
   object(167, 27,  1,   1,   8,   #223);
   object(170, 27,  1,   1,   8,   #223);
   object(174, 27,  1,   1,   8,   #223);
   object(177, 27,  1,   1,   8,   #223);
   object(178, 19,  1,   1,   7,   #219);
   object(163, 20,  1,   1,   6,   #223);
   object(160, 19,  1,   1,   8,   #219);
End;

//Dragon2 Sprite

procedure dragon2Sprite;

begin
  object(167, 29,  1,   1,   7 ,  #219 );
  object(167, 28,  1,   1,   7 ,  #219);
  object(168, 27,  1,   1,   7 ,  #219);
  object(169, 25,  1,   2,   7 ,  #219);
  object(170, 23,  1,   3,   7 ,  #219);
  object(171, 22,  1,   3,   7 ,  #219);
  object(168, 28,  1,   1,   8 ,  #219);
  object(170, 26,  1,   1,   8 ,  #219);
  object(171, 25,  1,   1,   8 ,  #219);
  object(172, 24,  1,   1,   8 ,  #219);
  object(173, 23,  1,   1,   8 ,  #219);
  object(172, 22,  1,   1,   8 ,  #219);
  object(172, 23,  1,   1,   7 ,  #219);
  object(173, 24,  1,   1,   7 ,  #219);
  object(174, 24,  1,   1,   7 ,  #219);
  object(175, 24,  1,   1,   7 ,  #219);
  object(174, 23,  1,   1,   7 ,  #219);
  object(174, 22,  1,   1,   7 ,  #219);
  object(173, 22,  1,   1,   7 ,  #219);
  object(175, 22,  1,   1,   7 ,  #219);
  object(175, 23,  1,   1,   15,  #219);
  object(176, 22,  1,   1,   15,  #219);
  object(176, 24,  1,   1,   15,  #219);
  object(177, 24,  1,   1,   7 ,  #219);
  object(178, 24,  1,   1,   7 ,  #219);
  object(176, 23,  1,   1,   7 ,  #219);
  object(177, 23,  1,   1,   7 ,  #219);
  object(177, 22,  1,   1,   7 ,  #219);
  object(178, 22,  1,   1,   8 ,  #219);
  object(178, 23,  1,   1,   8 ,  #219);
  object(179, 23,  1,   1,   8 ,  #219);
  object(179, 24,  1,   1,   8 ,  #219);
  object(177, 25,  1,   1,   15,  #219);
  object(178, 25,  1,   1,   7 ,  #219);
  object(177, 26,  1,   1,   7 ,  #219);
  object(176, 26,  1,   1,   7 ,  #219);
  object(177, 21,  1,   1,   8 ,  #219);
  object(176, 20,  1,   1,   8 ,  #219);
  object(175, 20,  1,   1,   8 ,  #219);
  object(174, 20,  1,   1,   8 ,  #219);
  object(173, 19,  1,   1,   8 ,  #219);
  object(172, 19,  1,   1,   8 ,  #219);
  object(171, 18,  1,   1,   8 ,  #219);
  object(170, 18,  1,   1,   8 ,  #219);
  object(169, 17,  1,   1,   8 ,  #219);
  object(168, 16,  1,   1,   8 ,  #219);
  object(168, 15,  1,   1,   8 ,  #219);
  object(167, 15,  1,   1,   8 ,  #219);
  object(167, 14,  1,   1,   8 ,  #219);
  object(167, 13,  1,   1,   8 ,  #219);
  object(166, 13,  1,   1,   8 ,  #219);
  object(162, 13,  4,   1,   7 ,  #219);
  object(161, 13,  1,   1,   15,  #219);
  object(162, 12,  1,   1,   15,  #219);
  object(160, 14,  1,   1,   15,  #219);
  object(159, 15,  1,   1,   15,  #219);
  object(158, 16,  1,   1,   15,  #219);
  object(157, 15,  1,   1,   15,  #219);
  object(167, 27,  1,   1,   15,  #219);
  object(168, 26,  1,   1,   15,  #219);
  object(168, 25,  1,   1,   15,  #219);
  object(169, 24,  1,   1,   15,  #219);
  object(169, 23,  1,   1,   15,  #219);
  object(170, 22,  1,   1,   15,  #219);
  object(169, 22,  1,   1,   7 ,  #219);
  object(168, 22,  1,   1,   7 ,  #219);
  object(168, 21,  1,   1,   7 ,  #219);
  object(169, 21,  1,   1,   7 ,  #219);
  object(170, 21,  1,   1,   7 ,  #219);
  object(171, 21,  1,   1,   7 ,  #219);
  object(176, 21,  1,   1,   7 ,  #219);
  object(175, 21,  1,   1,   7 ,  #219);
  object(174, 21,  1,   1,   7 ,  #219);
  object(173, 21,  1,   1,   7 ,  #219);
  object(172, 21,  1,   1,   7 ,  #219);
  object(169, 20,  5,   1,   7 ,  #219);
  object(168, 20,  1,   1,   8 ,  #219);
  object(167, 21,  1,   1,   8 ,  #219);
  object(167, 22,  1,   1,   8 ,  #219);
  object(168, 23,  1,   1,   8 ,  #219);
  object(168, 24,  1,   1,   6 ,  #219);
  object(167, 24,  1,   1,   6 ,  #219);
  object(166, 23,  2,   1,   6 ,  #219);
  object(165, 22,  2,   1,   6 ,  #219);
  object(165, 21,  2,   1,   6 ,  #219);
  object(166, 20,  2,   1,   6 ,  #219);
  object(166, 19,  2,   1,   6 ,  #219);
  object(165, 18,  2,   1,   6 ,  #219);
  object(165, 17,  1,   1,   6 ,  #219);
  object(164, 17,  1,   1,   14,  #219);
  object(164, 18,  1,   1,   14,  #219);
  object(163, 19,  3,   1,   14,  #219);
  object(163, 20,  3,   1,   14,  #219);
  object(162, 21,  3,   1,   14,  #219);
  object(163, 22,  2,   1,   14,  #219);
  object(164, 23,  2,   1,   14,  #219);
  object(166, 24,  1,   1,   14,  #219);
  object(163, 23,  1,   2,   8 ,  #219);
  object(162, 24,  1,   1,   8 ,  #219);
  object(161, 26,  1,   1,   8 ,  #219);
  object(160, 27,  1,   1,   8 ,  #219);
  object(160, 26,  1,   1,   7 ,  #219);
  object(160, 25,  1,   1,   7 ,  #219);
  object(161, 25,  1,   1,   7 ,  #219);
  object(161, 24,  1,   1,   7 ,  #219);
  object(161, 23,  1,   1,   7 ,  #219);
  object(162, 23,  1,   1,   7 ,  #219);
  object(162, 22,  1,   1,   7 ,  #219);
  object(166, 14,  1,   1,   7 ,  #219);
  object(165, 15,  2,   1,   7 ,  #219);
  object(165, 16,  3,   1,   7 ,  #219);
  object(166, 17,  3,   1,   7 ,  #219);
  object(167, 18,  3,   1,   7 ,  #219);
  object(168, 19,  4,   1,   7 ,  #219);
  object(162, 20,  1,   1,   15,  #219);
  object(163, 18,  1,   1,   15,  #219);
  object(164, 16,  1,   1,   15,  #219);
  object(164, 15,  1,   1,   8 ,  #219);
  object(165, 14,  1,   1,   8 ,  #219);
  object(163, 15,  1,   1,   8 ,  #219);
  object(161, 16,  2,   1,   8 ,  #219);
  object(159, 17,  1,   1,   8 ,  #219);
  object(157, 17,  1,   1,   8 ,  #219);
  object(157, 16,  1,   1,   8 ,  #219);
  object(158, 15,  1,   1,   8 ,  #219);
  object(159, 14,  1,   1,   8 ,  #219);
  object(160, 13,  1,   1,   8 ,  #219);
  object(161, 12,  1,   1,   8 ,  #219);
  object(161, 17,  3,   1,   5 ,  #219);
  object(158, 17,  1,   1,   5 ,  #219);
  object(157, 18,  6,   1,   5 ,  #219);
  object(157, 19,  6,   1,   5 ,  #219);
  object(156, 20,  6,   1,   5 ,  #219);
  object(156, 21,  3,   1,   5 ,  #219);
  object(156, 22,  1,   1,   5 ,  #219);
  object(160, 21,  1,   1,   8 ,  #219);
  object(159, 21,  1,   1,   8 ,  #219);
  object(157, 22,  1,   1,   8 ,  #219);
  object(156, 23,  1,   1,   8 ,  #219);
  object(155, 22,  1,   1,   8 ,  #219);
  object(155, 21,  1,   1,   8 ,  #219);
  object(155, 20,  1,   1,   8 ,  #219);
  object(156, 18,  1,   2,   8 ,  #219);
  object(155, 23,  1,   1,   7 ,  #219);
  object(155, 24,  1,   1,   7 ,  #219);
  object(154, 22,  1,   1,   7 ,  #219);
  object(154, 21,  1,   1,   7 ,  #219);
  object(155, 19,  1,   1,   7 ,  #219);
  object(155, 18,  1,   1,   7 ,  #219);
  object(156, 16,  1,   2,   7 ,  #219);
  object(158, 14,  1,   1,   7 ,  #219);
  object(159, 13,  1,   1,   7 ,  #219);
  object(163, 12,  1,   1,   7 ,  #219);
  object(165, 12,  1,   1,   7 ,  #219);
  object(166, 12,  1,   1,   7 ,  #219);
  object(155, 25,  1,   1,   15,  #219);
  object(154, 23,  1,   2,   15,  #219);
  object(153, 21,  1,   2,   15,  #219);
  object(154, 19,  1,   2,   15,  #219);
  object(155, 17,  1,   1,   15,  #219);
  object(181, 24,  1,   1,   5 ,  #219);
  object(180, 23,  2,   1,   5 ,  #219);
  object(180, 22,  2,   1,   5 ,  #219);
  object(179, 21,  2,   1,   5 ,  #219);
  object(179, 20,  2,   1,   5 ,  #219);
  object(178, 19,  2,   1,   5 ,  #219);
  object(178, 18,  2,   1,   5 ,  #219);
  object(177, 17,  2,   1,   5 ,  #219);
  object(177, 16,  2,   1,   5 ,  #219);
  object(176, 16,  1,   1,   5 ,  #219);
  object(177, 15,  1,   1,   5 ,  #219);
  object(175, 17,  2,   1,   13,  #219);
  object(174, 18,  4,   1,   13,  #219);
  object(175, 19,  3,   1,   13,  #219);
  object(177, 20,  2,   1,   13,  #219);
  object(178, 21,  1,   1,   13,  #219);
  object(179, 22,  1,   1,   13,  #219);
  object(174, 19,  1,   1,   7 ,  #219);
  object(173, 18,  1,   1,   7 ,  #219);
  object(182, 24,  1,   1,   7 ,  #219);
  object(182, 23,  2,   1,   7 ,  #219);
  object(182, 22,  2,   1,   7 ,  #219);
  object(182, 21,  1,   1,   7 ,  #219);
  object(181, 20,  2,   1,   7 ,  #219);
  object(180, 18,  2,   1,   7 ,  #219);
  object(181, 19,  1,   1,   7 ,  #219);
  object(180, 17,  1,   1,   7 ,  #219);
  object(179, 16,  1,   1,   7 ,  #219);
  object(178, 15,  1,   1,   7 ,  #219);
  object(176, 15,  1,   1,   7 ,  #219);
  object(177, 14,  1,   1,   7 ,  #219);
  object(176, 13,  1,   1,   7 ,  #219);
  object(175, 12,  1,   1,   7 ,  #219);
  object(174, 11,  1,   1,   7 ,  #219);
  object(182, 26,  1,   1,   8 ,  #219);
  object(183, 24,  1,   2,   8 ,  #219);
  object(184, 20,  1,   5,   8 ,  #219);
  object(185, 22,  1,   2,   8 ,  #219);
  object(183, 18,  1,   4,   8 ,  #219);
  object(182, 17,  1,   3,   8 ,  #219);
  object(181, 16,  1,   2,   8 ,  #219);
  object(180, 15,  1,   2,   8 ,  #219);
  object(179, 14,  1,   2,   8 ,  #219);
  object(178, 13,  1,   2,   8 ,  #219);
  object(177, 13,  1,   1,   8 ,  #219);
  object(176, 12,  1,   1,   8 ,  #219);
  object(181, 21,  1,   1,   15,  #219);
  object(180, 19,  1,   1,   15,  #219);
  object(179, 17,  1,   1,   15,  #219);
  object(174, 17,  1,   1,   8 ,  #219);
  object(175, 16,  1,   1,   8 ,  #219);
  object(176, 14,  1,   1,   15,  #219);
  object(184, 19,  1,   1,   7 ,  #219);
  object(185, 18,  1,   1,   7 ,  #219);
  object(185, 17,  1,   1,   7 ,  #219);
  object(184, 16,  1,   1,   7 ,  #219);
  object(184, 15,  1,   1,   7 ,  #219);
  object(183, 14,  1,   1,   7 ,  #219);
  object(184, 13,  1,   1,   7 ,  #219);
  object(185, 19,  1,   1,   8 ,  #219);
  object(186, 18,  1,   1,   8 ,  #219);
  object(186, 17,  1,   1,   8 ,  #219);
  object(185, 16,  1,   1,   8 ,  #219);
  object(185, 15,  1,   1,   8 ,  #219);
  object(184, 14,  1,   1,   8 ,  #219);
  object(182, 25,  1,   1,   15,  #219);
  object(162, 15,  1,   1,   4 ,  #220);
  object(175, 11,  1,   1,   8 ,  #220);
  object(177, 12,  1,   1,   8 ,  #220);
  object(180, 14,  1,   1,   8 ,  #220);
  object(181, 15,  1,   1,   8 ,  #220);
  object(182, 16,  1,   1,   8 ,  #220);
  object(185, 21,  1,   1,   8 ,  #220);
  object(186, 16,  1,   1,   8 ,  #220 );
  object(159, 16,  1,   1,   7 ,  #220);
  object(164, 12,  1,   1,   7 ,  #220);
  object(162, 11,  1,   1,   15,  #220);
  object(158, 13,  1,   1,   15,  #220);
  object(185, 12,  1,   1,   8 ,  #220);
  object(186, 11,  1,   1,   15,  #220);
  object(164, 14,  1,   1,   4 ,  #220);
  object(163, 14,  1,   1,   7 ,  #219);
  object(162, 14,  1,   1,   7 ,  #219);
  object(162, 15,  1,   1,   7 ,  #219 );
  object(161, 15,  1,   1,   7 ,  #219);
  object(160, 15,  1,   1,   7 ,  #219);
  object(160, 16,  1,   1,   7 ,  #219 );
  object(161, 14,  1,   1,   4 ,  #223);
  object(160, 17,  1,   1,   8 ,  #223);
  object(163, 16,  1,   1,   8 ,  #223);
  object(185, 13,  1,   1,   8 ,  #223);
  object(186, 12,  1,   1,   7 ,  #223);
  object(173, 11,  1,   1,   15,  #223);
  object(187, 11,  1,   1,   15,  #223);
  object(169, 12,  1,   1,   5 ,  #219);
  object(170, 11,  1,   1,   5 ,  #219);
  object(170, 10,  1,   1,   5 ,  #219);
  object(164, 11,  1,   1,   5 ,  #219);
  object(165, 10,  1,   1,   5 ,  #219);
  object(163, 11,  1,   1,   13,  #219);
  object(164, 10,  1,   1,   13,  #219);
  object(168, 12,  1,   1,   13,  #219);
  object(169, 11,  1,   1,   13,  #219);
  object(172, 18,  1,   1,   7 ,  #220 );
  object(159, 26,  1,   1,   7 ,  #220);
  object(166, 28,  1,   1,   7 ,  #220);
  object(185, 12,  1,   1,   7 ,  #220);
  object(186, 11,  1,   1,   16,  #219);
  object(187, 11,  1,   1,   16,  #219);
  object(186, 12,  1,   1,   15,  #223);
  object(168, 13,  1,   1,   5 ,  #223);
  object(166, 9 ,  1,   1,   5 ,  #220);
  object(165, 9 ,  1,   1,   13,  #220);
  object(167, 12,  1,   1,   13,  #220);
  object(165, 29,  1,   1,   7 ,  #223);
  object(158, 27,  1,   1,   7 ,  #223);
  object(175, 27,  1,   1,   7 ,  #223);
  object(177, 27,  1,   1,   8 ,  #223);
  object(158, 22,  1,   1,   8 ,  #223);
  object(161, 21,  1,   1,   8 ,  #223);
  object(162, 25,  1,   1,   8 ,  #223);
  object(162, 26,  1,   1,   8 ,  #223);
  object(169, 28,  1,   1,   8 ,  #223);
  object(173, 25,  1,   1,   8 ,  #223);
  object(174, 25,  1,   1,   8 ,  #223);
  object(175, 25,  1,   1,   8 ,  #223);
  object(179, 25,  1,   1,   8 ,  #223 );
  object(180, 24,  1,   1,   8 ,  #223);
  object(160, 12,  1,   1,   15,  #220);
  object(158, 13,  1,   1,   16,  #220);
end;

//Phenix Sprite

procedure phenixSprite;

begin
  object(174, 28,  1,   1,   6 ,  #219 );
  object(176, 27,  1,   1,   6 ,  #219 );
  object(175, 26,  1,   1,   6 ,  #219 );
  object(175, 25,  2,   1,   6 ,  #219 );
  object(177, 26,  1,   1,   6 ,  #219 );
  object(175, 24,  1,   1,   6 ,  #219 );
  object(174, 23,  1,   1,   6 ,  #219 );
  object(172, 23,  1,   1,   6 ,  #219 );
  object(172, 22,  1,   1,   6 ,  #219 );
  object(173, 22,  1,   1,   6 ,  #219 );
  object(172, 21,  1,   1,   6 ,  #219 );
  object(171, 21,  1,   1,   6 ,  #219 );
  object(171, 20,  1,   1,   6 ,  #219 );
  object(170, 20,  1,   1,   6 ,  #219 );
  object(170, 19,  1,   1,   6 ,  #219 );
  object(169, 19,  1,   1,   6 ,  #219 );
  object(170, 18,  1,   1,   6 ,  #219 );
  object(169, 18,  1,   1,   6 ,  #219 );
  object(168, 18,  1,   1,   6 ,  #219 );
  object(169, 17,  1,   1,   6 ,  #219 );
  object(168, 17,  1,   1,   6 ,  #219 );
  object(167, 17,  1,   1,   6 ,  #219 );
  object(167, 16,  1,   1,   6 ,  #219 );
  object(168, 16,  1,   1,   6 ,  #219 );
  object(169, 16,  1,   1,   6 ,  #219 );
  object(168, 15,  1,   1,   6 ,  #219 );
  object(169, 15,  1,   1,   6 ,  #219 );
  object(170, 15,  1,   1,   6 ,  #219 );
  object(168, 14,  1,   1,   6 ,  #219 );
  object(167, 14,  1,   1,   6 ,  #219 );
  object(167, 13,  1,   1,   6 ,  #219 );
  object(166, 13,  1,   1,   6 ,  #219 );
  object(165, 13,  1,   1,   6 ,  #219 );
  object(166, 12,  1,   1,   6 ,  #219 );
  object(166, 11,  1,   1,   6 ,  #219 );
  object(164, 15,  1,   1,   6 ,  #219 );
  object(163, 16,  1,   1,   6 ,  #219 );
  object(166, 14,  1,   1,   14,  #219 );
  object(166, 15,  1,   1,   14,  #219 );
  object(167, 15,  1,   1,   14,  #219 );
  object(165, 15,  1,   1,   14,  #219 );
  object(166, 16,  1,   1,   14,  #219 );
  object(165, 16,  1,   1,   14,  #219 );
  object(164, 16,  1,   1,   14,  #219 );
  object(163, 17,  1,   1,   14,  #219 );
  object(164, 17,  1,   1,   14,  #219 );
  object(165, 17,  1,   1,   14,  #219 );
  object(166, 17,  1,   1,   14,  #219 );
  object(164, 18,  1,   1,   14,  #219 );
  object(165, 18,  1,   1,   14,  #219 );
  object(166, 18,  1,   1,   14,  #219 );
  object(167, 18,  1,   1,   14,  #219 );
  object(165, 19,  1,   1,   14,  #219 );
  object(166, 19,  1,   1,   14,  #219 );
  object(167, 19,  1,   1,   14,  #219 );
  object(168, 19,  1,   1,   14,  #219 );
  object(169, 20,  1,   1,   14,  #219 );
  object(168, 20,  1,   1,   14,  #219 );
  object(167, 20,  1,   1,   14,  #219 );
  object(170, 21,  1,   1,   14,  #219 );
  object(169, 21,  1,   1,   14,  #219 );
  object(170, 22,  1,   1,   14,  #219 );
  object(171, 22,  1,   1,   14,  #219 );
  object(170, 23,  1,   1,   14,  #219 );
  object(164, 13,  1,   1,   14,  #219 );
  object(163, 12,  1,   1,   7 ,  #219 );
  object(161, 13,  1,   1,   8 ,  #219 );
  object(167, 11,  1,   1,   4 ,  #219 );
  object(167, 12,  1,   1,   4 ,  #219 );
  object(168, 13,  1,   1,   4 ,  #219 );
  object(169, 13,  1,   1,   4 ,  #219 );
  object(169, 14,  1,   1,   4 ,  #219 );
  object(170, 14,  1,   1,   4 ,  #219 );
  object(171, 14,  1,   1,   4 ,  #219 );
  object(172, 14,  1,   1,   4 ,  #219 );
  object(173, 14,  1,   1,   4 ,  #219 );
  object(174, 14,  1,   1,   4 ,  #219 );
  object(175, 14,  1,   1,   4 ,  #219 );
  object(176, 14,  1,   1,   4 ,  #219 );
  object(176, 13,  1,   1,   4 ,  #219 );
  object(175, 13,  1,   1,   4 ,  #219 );
  object(177, 13,  1,   1,   4 ,  #219 );
  object(178, 13,  1,   1,   4 ,  #219 );
  object(176, 15,  1,   1,   4 ,  #219 );
  object(177, 15,  1,   1,   4 ,  #219 );
  object(178, 15,  1,   1,   4 ,  #219 );
  object(179, 14,  1,   1,   4 ,  #219 );
  object(180, 14,  1,   1,   4 ,  #219 );
  object(181, 14,  1,   1,   4 ,  #219 );
  object(175, 15,  1,   1,   4 ,  #219 );
  object(174, 15,  1,   1,   4 ,  #219 );
  object(173, 15,  1,   1,   4 ,  #219 );
  object(172, 15,  1,   1,   4 ,  #219 );
  object(171, 15,  1,   1,   4 ,  #219 );
  object(175, 16,  1,   1,   4 ,  #219 );
  object(174, 16,  1,   1,   4 ,  #219 );
  object(173, 16,  1,   1,   4 ,  #219 );
  object(172, 16,  1,   1,   4 ,  #219 );
  object(171, 16,  1,   1,   4 ,  #219 );
  object(170, 16,  1,   1,   4 ,  #219 );
  object(175, 17,  1,   1,   4 ,  #219 );
  object(174, 17,  1,   1,   4 ,  #219 );
  object(173, 17,  1,   1,   4 ,  #219 );
  object(172, 17,  1,   1,   4 ,  #219 );
  object(171, 17,  1,   1,   4 ,  #219 );
  object(170, 17,  1,   1,   4 ,  #219 );
  object(175, 18,  1,   1,   4 ,  #219 );
  object(173, 18,  1,   1,   4 ,  #219 );
  object(172, 18,  1,   1,   4 ,  #219 );
  object(171, 18,  1,   1,   4 ,  #219 );
  object(171, 19,  1,   1,   4 ,  #219 );
  object(172, 19,  1,   1,   4 ,  #219 );
  object(173, 19,  1,   1,   4 ,  #219 );
  object(172, 20,  1,   1,   4 ,  #219 );
  object(173, 20,  1,   1,   4 ,  #219 );
  object(174, 20,  1,   1,   4 ,  #219 );
  object(173, 21,  1,   1,   4 ,  #219 );
  object(174, 21,  1,   1,   4 ,  #219 );
  object(174, 22,  1,   1,   4 ,  #219 );
  object(175, 22,  1,   1,   4 ,  #219 );
  object(175, 23,  1,   1,   4 ,  #219 );
  object(176, 24,  1,   1,   4 ,  #219 );
  object(178, 25,  1,   1,   4 ,  #219 );
  object(177, 17,  1,   1,   4 ,  #219 );
  object(178, 17,  1,   1,   4 ,  #219 );
  object(163, 15,  1,   1,   4 ,  #219 );
  object(162, 15,  1,   1,   4 ,  #219 );
  object(161, 15,  1,   1,   4 ,  #219 );
  object(160, 15,  1,   1,   4 ,  #219 );
  object(159, 15,  1,   1,   4 ,  #219 );
  object(160, 14,  1,   1,   4 ,  #219 );
  object(159, 14,  1,   1,   4 ,  #219 );
  object(158, 14,  1,   1,   4 ,  #219 );
  object(157, 14,  1,   1,   4 ,  #219 );
  object(156, 15,  1,   1,   4 ,  #219 );
  object(155, 15,  1,   1,   4 ,  #219 );
  object(154, 15,  1,   1,   4 ,  #219 );
  object(157, 16,  1,   1,   4 ,  #219 );
  object(158, 16,  1,   1,   4 ,  #219 );
  object(159, 16,  1,   1,   4 ,  #219 );
  object(160, 16,  1,   1,   4 ,  #219 );
  object(161, 16,  1,   1,   4 ,  #219 );
  object(162, 16,  1,   1,   4 ,  #219 );
  object(162, 17,  1,   1,   4 ,  #219 );
  object(161, 17,  1,   1,   4 ,  #219 );
  object(160, 17,  1,   1,   4 ,  #219 );
  object(159, 18,  1,   1,   4 ,  #219 );
  object(158, 18,  1,   1,   4 ,  #219 );
  object(161, 18,  1,   1,   4 ,  #219 );
  object(162, 18,  1,   1,   4 ,  #219 );
  object(163, 18,  1,   1,   4 ,  #219 );
  object(164, 19,  1,   1,   4 ,  #219 );
  object(166, 20,  1,   1,   4 ,  #219 );
  object(168, 21,  1,   1,   4 ,  #219 );
  object(169, 22,  1,   1,   4 ,  #219 );
  object(162, 19,  1,   1,   4 ,  #219 );
  object(163, 20,  1,   1,   4 ,  #219 );
  object(164, 21,  1,   1,   4 ,  #219 );
  object(165, 23,  1,   1,   4 ,  #219 );
  object(164, 25,  1,   1,   4 ,  #219 );
  object(153, 13,  1,   1,   6 ,  #219 );
  object(150, 12,  1,   1,   14,  #219 );
  object(149, 11,  1,   1,   14,  #219 );
  object(153, 16,  1,   1,   6 ,  #219 );
  object(182, 12,  1,   1,   6 ,  #219 );
  object(185, 11,  1,   1,   6 ,  #219 );
  object(186, 10,  1,   1,   14,  #219 );
  object(182, 15,  1,   1,   6 ,  #219 );
  object(170, 24,  1,   1,   7 ,  #219 );
  object(173, 24,  1,   1,   7 ,  #219 );
  object(171, 24,  1,   1,   7 ,  #220 );
  object(173, 23,  1,   1,   7 ,  #220 );
  object(171, 25,  1,   1,   7 ,  #220 );
  object(162, 12,  1,   1,   7 ,  #220 );
  object(165, 11,  1,   1,   14,  #220 );
  object(164, 11,  1,   1,   14,  #220 );
  object(169, 10,  1,   1,   4 ,  #220 );
  object(165, 12,  1,   1,   6 ,  #220 );
  object(161, 14,  1,   1,   4 ,  #220 );
  object(162, 14,  1,   1,   4 ,  #220 );
  object(163, 14,  1,   1,   4 ,  #220 );
  object(156, 13,  1,   1,   4 ,  #220 );
  object(155, 13,  1,   1,   6 ,  #220 );
  object(154, 13,  1,   1,   6 ,  #220 );
  object(151, 12,  1,   1,   6 ,  #220 );
  object(181, 12,  1,   1,   6 ,  #220 );
  object(184, 11,  1,   1,   14,  #220 );
  object(180, 12,  1,   1,   4 ,  #220 );
  object(179, 12,  1,   1,   4 ,  #220 );
  object(183, 13,  1,   1,   4 ,  #220 );
  object(184, 13,  1,   1,   6 ,  #220 );
  object(154, 16,  1,   1,   6 ,  #220 );
  object(155, 16,  1,   1,   6 ,  #220 );
  object(156, 16,  1,   1,   4 ,  #220 );
  object(159, 17,  1,   1,   4 ,  #220 );
  object(157, 18,  1,   1,   6 ,  #220 );
  object(156, 18,  1,   1,   14,  #220 );
  object(154, 18,  1,   1,   14,  #220 );
  object(150, 15,  1,   1,   14,  #220 );
  object(152, 14,  1,   1,   4 ,  #220 );
  object(151, 14,  1,   1,   6 ,  #220 );
  object(149, 13,  1,   1,   14,  #220 );
  object(150, 14,  1,   1,   14,  #219);
  object(185, 13,  1,   1,   14,  #219 );
  object(179, 15,  1,   1,   4 ,  #220 );
  object(180, 15,  1,   1,   4 ,  #220 );
  object(181, 15,  1,   1,   6 ,  #220 );
  object(185, 14,  1,   1,   14,  #220 );
  object(186, 12,  1,   1,   14,  #220 );
  object(177, 14,  1,   1,   4 ,  #220 );
  object(178, 14,  1,   1,   4 ,  #220 );
  object(174, 13,  1,   1,   4 ,  #220 );
  object(173, 13,  1,   1,   4 ,  #220 );
  object(172, 13,  1,   1,   4 ,  #220 );
  object(157, 15,  1,   1,   4 ,  #220 );
  object(158, 15,  1,   1,   4 ,  #220 );
  object(165, 22,  1,   1,   4 ,  #220 );
  object(164, 24,  1,   1,   4 ,  #220 );
  object(163, 26,  1,   1,   4 ,  #220 );
  object(176, 23,  1,   1,   4 ,  #220 );
  object(177, 24,  1,   1,   4 ,  #220 );
  object(179, 25,  1,   1,   4 ,  #220 );
  object(177, 22,  1,   1,   4 ,  #220 );
  object(178, 22,  1,   1,   4 ,  #220 );
  object(175, 21,  1,   1,   4 ,  #220 );
  object(176, 18,  1,   1,   4 ,  #220 );
  object(176, 16,  1,   1,   4 ,  #220 );
  object(179, 19,  1,   1,   4 ,  #220 );
  object(180, 19,  1,   1,   4 ,  #220 );
  object(181, 19,  1,   1,   4 ,  #220 );
  object(185, 20,  1,   1,   4 ,  #220 );
  object(186, 20,  1,   1,   4 ,  #220 );
  object(179, 17,  1,   1,   4 ,  #220 );
  object(180, 17,  1,   1,   14,  #220 );
  object(182, 17,  1,   1,   14,  #220 );
  object(168, 12,  1,   1,   4 ,  #220 );
  object(174, 27,  1,   1,   6 ,  #220 );
  object(173, 26,  1,   1,   14,  #220 );
  object(172, 27,  1,   1,   14,  #220 );
  object(169, 27,  1,   1,   14,  #220 );
  object(151, 16,  1,   1,   14,  #223 );
  object(151, 13,  1,   1,   14,  #223 );
  object(152, 13,  1,   1,   6 ,  #223 );
  object(152, 16,  1,   1,   6 ,  #223 );
  object(156, 19,  1,   1,   6 ,  #223 );
  object(155, 19,  1,   1,   14,  #223 );
  object(153, 15,  1,   1,   4 ,  #223 );
  object(152, 15,  1,   1,   6 ,  #223 );
  object(156, 14,  1,   1,   4 ,  #223 );
  object(155, 14,  1,   1,   4 ,  #223 );
  object(155, 17,  1,   1,   4 ,  #223 );
  object(156, 17,  1,   1,   4 ,  #223 );
  object(157, 17,  1,   1,   4 ,  #223 );
  object(157, 19,  1,   1,   4 ,  #223 );
  object(160, 18,  1,   1,   4 ,  #223 );
  object(164, 22,  1,   1,   4 ,  #223 );
  object(165, 24,  1,   1,   4 ,  #223 );
  object(164, 26,  1,   1,   4 ,  #223 );
  object(165, 20,  1,   1,   4 ,  #223 );
  object(163, 19,  1,   1,   4 ,  #223 );
  object(167, 21,  1,   1,   4 ,  #223 );
  object(169, 23,  1,   1,   4 ,  #223 );
  object(180, 25,  1,   1,   4 ,  #223 );
  object(177, 25,  1,   1,   4 ,  #223 );
  object(179, 22,  1,   1,   4 ,  #223 );
  object(176, 22,  1,   1,   4 ,  #223 );
  object(184, 20,  1,   1,   4 ,  #223 );
  object(183, 20,  1,   1,   4 ,  #223 );
  object(182, 20,  1,   1,   4 ,  #223 );
  object(187, 21,  1,   1,   4 ,  #223 );
  object(178, 19,  1,   1,   4 ,  #223 );
  object(177, 19,  1,   1,   4 ,  #223 );
  object(174, 18,  1,   1,   4 ,  #223 );
  object(176, 17,  1,   1,   4 ,  #223 );
  object(179, 18,  1,   1,   6 ,  #223 );
  object(180, 18,  1,   1,   6 ,  #223 );
  object(181, 18,  1,   1,   14,  #223 );
  object(184, 15,  1,   1,   14,  #223 );
  object(183, 15,  1,   1,   6 ,  #223 );
  object(180, 16,  1,   1,   6 ,  #223 );
  object(179, 16,  1,   1,   4 ,  #223 );
  object(178, 16,  1,   1,   4 ,  #223 );
  object(182, 14,  1,   1,   4 ,  #223 );
  object(183, 14,  1,   1,   6 ,  #223 );
  object(183, 12,  1,   1,   6 ,  #223 );
  object(184, 12,  1,   1,   6 ,  #223 );
  object(180, 13,  1,   1,   6 ,  #223 );
  object(179, 13,  1,   1,   4 ,  #223 );
  object(164, 12,  1,   1,   4 ,  #223 );
  object(168, 11,  1,   1,   4 ,  #223 );
  object(165, 14,  1,   1,   6 ,  #223 );
  object(163, 13,  1,   1,   14,  #223 );
  object(162, 13,  1,   1,   7 ,  #223 );
  object(170, 25,  1,   1,   7 ,  #223 );
  object(174, 25,  1,   1,   7 ,  #223 );
  object(174, 24,  1,   1,   7 ,  #223 );
  object(177, 28,  1,   1,   6 ,  #223 );
  object(178, 27,  1,   1,   6 ,  #223 );
  object(175, 27,  1,   1,   6 ,  #223 );
  object(173, 29,  1,   1,   6 ,  #223 );
  object(170, 28,  1,   1,   14,  #223 );
  object(171, 28,  1,   1,   14,  #223 );
  object(173, 27,  1,   1,   14,  #223 );
  object(174, 26,  1,   1,   14,  #223 );
  object(173, 26,  1,   1,   16,  #223 );
  object(174, 26,  1,   1,   14,  #219 );
  object(171, 23,  1,   1,   6 ,  #223 );
end;

//Dragon Sprite

procedure dragonSprite;

Begin

  object(155, 22,  32,  2,   3, #219); 
  object(156, 21,  30,  2,   3, #219); 
  object(156, 23,  30,  2,   3, #219); 
  object(152, 16,  38,  1,   3, #219); 
  object(164, 17,  14,  4,   3, #219); 
  object(158, 20,  4,   4,   3, #219); 
  object(180, 20,  4,   4,   3, #219); 
  object(180, 23,  4,   4,   3, #219); 
  object(158, 23,  4,   4,   3, #219); 
  object(157, 27,  5,   2,   3, #219); 
  object(158, 25,  5,   2,   3, #219); 
  object(179, 25,  5,   2,   3, #219); 
  object(180, 27,  5,   2,   3, #219); 
  object(165, 25,  12,  1,  3, #219); 
  object(166, 26,  10,  1,  3, #219); 
  object(162, 17,  10,  1,  3, #219); 
  object(170, 17,  10,  1,  3, #219); 
  object(151, 17,  1,   2,   3 , #219); 
  object(152, 16,  1,   2,   3 , #219); 
  object(153, 15,  1,   2,   3 , #219); 
  object(190, 17,  1,   2,   3 , #219); 
  object(189, 16,  1,   2,   3 , #219); 
  object(188, 15,  1,   2,   3 , #219); 
  object(187, 14,  1,   2,   3 , #219); 
  object(154, 14,  1,   2,   3 , #219); 
  object(156, 12,  1,   2,   3 , #219); 
  object(158, 12,  1,   2,   3 , #219); 
  object(160, 14,  1,   2,   3 , #219); 
  object(161, 15,  1,   2,   3 , #219); 
  object(162, 15,  1,   2,   3 , #219); 
  object(163, 15,  1,   2,   3 , #219); 
  object(185, 12,  1,   2,   3 , #219); 
  object(183, 12,  1,   2,   3 , #219); 
  object(181, 14,  1,   2,   3 , #219); 
  object(180, 15,  1,   2,   3 , #219); 
  object(179, 15,  1,   2,   3 , #219); 
  object(178, 15,  1,   2,   3 , #219); 
  object(182, 13,  1,   2,   3 , #219); 
  object(184, 11,  1,   2,   3 , #219); 
  object(186, 13,  1,   2,   3 , #219); 
  object(159, 13,  1,   2,   3 , #219); 
  object(157, 11,  1,   2,   3 , #219); 
  object(155, 13,  1,   2,   3 , #219); 
  object(168, 12,  6,   4,   3 , #219); 
  object(166, 12,  10,  3,   3 , #219); 
  object(165, 11,  12,  3,   3 , #219); 
  object(166, 10,  10,  1,   3 , #219); 
  object(153, 15,  7,   1,   3 , #219); 
  object(154, 14,  7,   1,   3 , #219); 
  object(155, 13,  5,   1,   3 , #219); 
  object(182, 13,  5,   1,   3 , #219); 
  object(182, 14,  5,   1,   3 , #219); 
  object(182, 15,  5,   1,   3 , #219); 
  object(186, 24,  1,   1,   1 , #219); 
  object(187, 23,  1,   1,   1 , #219); 
  object(187, 22,  1,   1,   1 , #219); 
  object(186, 21,  1,   1,   1 , #219); 
  object(184, 20,  1,   1,   1 , #219); 
  object(180, 20,  1,   1,   1 , #219); 
  object(181, 19,  1,   1,   1 , #219); 
  object(183, 19,  1,   1,   1 , #219); 
  object(179, 21,  1,   1,   1 , #219); 
  object(177, 24,  1,   1,   1 , #219); 
  object(178, 23,  1,   1,   1 , #219); 
  object(179, 22,  1,   1,   1 , #219); 
  object(178, 21,  1,   1,   1 , #219); 
  object(177, 20,  1,   1,   1 , #219); 
  object(164, 20,  1,   1,   1 , #219); 
  object(164, 24,  1,   1,   1 , #219); 
  object(163, 23,  1,   1,   1 , #219); 
  object(162, 22,  1,   1,   1 , #219); 
  object(162, 21,  1,   1,   1 , #219); 
  object(165, 25,  1,   1,   1 , #219); 
  object(166, 26,  1,   1,   1 , #219); 
  object(175, 26,  1,   1,   1 , #219); 
  object(176, 25,  1,   1,   1 , #219); 
  object(155, 24,  1,   1,   1 , #219); 
  object(154, 23,  1,   1,   1 , #219); 
  object(154, 22,  1,   1,   1 , #219); 
  object(155, 21,  1,   1,   1 , #219); 
  object(157, 20,  1,   1,   1 , #219); 
  object(156, 25,  1,   1,   1 , #219); 
  object(158, 26,  1,   1,   1 , #219); 
  object(156, 28,  1,   1,   1 , #219); 
  object(158, 28,  1,   1,   1 , #219); 
  object(160, 28,  1,   1,   1 , #219); 
  object(185, 28,  1,   1,   1 , #219); 
  object(183, 28,  1,   1,   1 , #219); 
  object(181, 28,  1,   1,   1 , #219); 
  object(183, 26,  1,   1,   1 , #219); 
  object(185, 25,  1,   1,   1 , #219); 
  object(179, 25,  1,   1,   1 , #219); 
  object(179, 26,  1,   1,   1 , #219); 
  object(178, 24,  1,   1,   1 , #219); 
  object(163, 24,  1,   1,   1 , #219); 
  object(162, 25,  1,   1,   1 , #219); 
  object(162, 26,  1,   1,   1 , #219); 
  object(163, 21,  1,   1,   1 , #219); 
  object(161, 20,  1,   1,   1 , #219); 
  object(160, 19,  1,   1,   1 , #219); 
  object(158, 19,  1,   1,   1 , #219); 
  object(156, 20,  1,   1,   1 , #219); 
  object(159, 19,  1,   1,   1 , #219); 
  object(183, 19,  1,   1,   1 , #219); 
  object(182, 19,  1,   1,   1 , #219); 
  object(185, 20,  1,   1,   1 , #219); 
  object(177, 19,  1,   1,   1 , #219); 
  object(178, 18,  1,   1,   1 , #219); 
  object(179, 17,  1,   1,   1 , #219); 
  object(164, 19,  1,   1,   1 , #219); 
  object(163, 18,  1,   1,   1 , #219); 
  object(161, 17,  1,   1,   1 , #219); 
  object(151, 16,  1,   1,   1 , #219); 
  object(152, 15,  1,   1,   1 , #219); 
  object(153, 14,  1,   1,   1 , #219); 
  object(154, 13,  1,   1,   1 , #219); 
  object(155, 12,  1,   1,   1 , #219); 
  object(156, 11,  1,   1,   1 , #219); 
  object(158, 11,  1,   1,   1 , #219); 
  object(159, 12,  1,   1,   1 , #219); 
  object(160, 13,  1,   1,   1 , #219); 
  object(161, 14,  1,   1,   1 , #219); 
  object(162, 14,  1,   1,   1 , #219); 
  object(163, 15,  1,   1,   1 , #219); 
  object(164, 15,  1,   1,   1 , #219); 
  object(190, 16,  1,   1,   1 , #219); 
  object(189, 15,  1,   1,   1 , #219); 
  object(188, 14,  1,   1,   1 , #219); 
  object(187, 13,  1,   1,   1 , #219); 
  object(186, 12,  1,   1,   1 , #219); 
  object(185, 11,  1,   1,   1 , #219); 
  object(183, 11,  1,   1,   1 , #219); 
  object(182, 12,  1,   1,   1 , #219); 
  object(181, 13,  1,   1,   1 , #219); 
  object(180, 14,  1,   1,   1 , #219); 
  object(179, 14,  1,   1,   1 , #219); 
  object(178, 15,  1,   1,   1 , #219); 
  object(177, 15,  1,   1,   1 , #219); 
  object(191, 17,  1,   1,   1 , #219); 
  object(190, 18,  1,   1,   1 , #219); 
  object(150, 17,  1,   1,   1 , #219); 
  object(151, 18,  1,   1,   1 , #219); 
  object(167, 15,  1,   1,   1 , #219); 
  object(168, 16,  1,   1,   1 , #219); 
  object(166, 14,  1,   1,   1 , #219); 
  object(165, 13,  1,   1,   1 , #219); 
  object(164, 12,  1,   1,   1 , #219); 
  object(165, 11,  1,   1,   1 , #219); 
  object(166, 10,  1,   1,   1 , #219); 
  object(175, 10,  1,   1,   1 , #219); 
  object(176, 11,  1,   1,   1 , #219); 
  object(177, 12,  1,   1,   1 , #219); 
  object(176, 13,  1,   1,   1 , #219); 
  object(175, 14,  1,   1,   1 , #219); 
  object(174, 15,  1,   1,   1 , #219); 
  object(173, 16,  1,   1,   1 , #219); 
  object(169, 17,  1,   1,   1 , #219); 
  object(172, 17,  1,   1,   1 , #219); 
  object(171, 10,  1,   1,   1 , #219); 
  object(170, 10,  1,   1,   1 , #219); 
  object(169, 9 ,  1,   1,   1 , #219); 
  object(168, 8 ,  1,   1,   1 , #219); 
  object(167, 8 ,  1,   1,   1 , #219); 
  object(166, 7 ,  1,   1,   1 , #219); 
  object(165, 7 ,  1,   1,   1 , #219); 
  object(163, 7 ,  1,   1,   1 , #219); 
  object(164, 7 ,  1,   1,   1 , #219); 
  object(161, 8 ,  1,   1,   1 , #219); 
  object(165, 9 ,  1,   1,   1 , #219); 
  object(162, 9 ,  1,   1,   1 , #219); 
  object(163, 8 ,  1,   1,   1 , #219); 
  object(164, 8 ,  1,   1,   1 , #219); 
  object(162, 7 ,  1,   1,   1 , #219); 
  object(172, 9 ,  1,   1,   1 , #219); 
  object(173, 8 ,  1,   1,   1 , #219); 
  object(175, 7 ,  1,   1,   1 , #219); 
  object(176, 9 ,  1,   1,   1 , #219); 
  object(177, 8 ,  1,   1,   1 , #219); 
  object(179, 8 ,  1,   1,   1 , #219); 
  object(180, 9 ,  1,   1,   1 , #219); 
  object(181, 8 ,  1,   1,   1 , #219); 
  object(180, 7 ,  1,   1,   1 , #219); 
  object(179, 7 ,  1,   1,   1 , #219); 
  object(178, 7 ,  1,   1,   1 , #219); 
  object(177, 7 ,  1,   1,   1 , #219); 
  object(177, 7 ,  1,   1,   1 , #219); 
  object(176, 7 ,  1,   1,   1 , #219); 
  object(175, 8 ,  1,   1,   1 , #219); 
  object(174, 8 ,  1,   1,   1 , #219); 
  object(176, 8 ,  1,   1,   1 , #219); 
  object(175, 9 ,  1,   1,   1 , #219); 
  object(174, 9 ,  1,   1,   1 , #219); 
  object(174, 9 ,  1,   1,   1 , #219); 
  object(173, 9 ,  1,   1,   1 , #219); 
  object(167, 9 ,  1,   1,   1 , #219); 
  object(168, 9 ,  1,   1,   1 , #219); 
  object(166, 9 ,  1,   1,   1 , #219); 
  object(166, 8 ,  1,   1,   1 , #219); 
  object(165, 8 ,  1,   1,   1 , #219); 
  object(162, 8 ,  1,   1,   1 , #219); 
  object(178, 8 ,  1,   1,   1 , #219); 
  object(180, 8 ,  1,   1,   1 , #219); 
  object(170, 17,  1,   1,   1 , #219); 
  object(171, 17,  1,   1,   1 , #219); 
  object(184, 17,  1,   1,   1 , #219); 
  object(185, 16,  1,   1,   1 , #219); 
  object(187, 16,  1,   1,   1 , #219); 
  object(189, 17,  1,   1,   1 , #219); 
  object(188, 16,  1,   1,   1 , #219); 
  object(186, 15,  1,   1,   1 , #219); 
  object(183, 16,  1,   1,   1 , #219); 
  object(182, 15,  1,   1,   1 , #219); 
  object(181, 16,  1,   1,   1 , #219); 
  object(160, 16,  1,   1,   1 , #219); 
  object(158, 16,  1,   1,   1 , #219); 
  object(157, 17,  1,   1,   1 , #219); 
  object(156, 16,  1,   1,   1 , #219); 
  object(153, 17,  1,   1,   1 , #219); 
  object(154, 16,  1,   1,   1 , #219); 
  object(155, 15,  1,   1,   1 , #219); 
  object(159, 15,  1,   1,   1 , #219); 
  object(171, 18,  1,   1,   4 , #219); 
  object(170, 18,  1,   1,   4 , #219); 
  object(169, 19,  1,   1,   4 , #219); 
  object(172, 19,  1,   1,   4 , #219); 
  object(170, 20,  1,   1,   4 , #219); 
  object(171, 20,  1,   1,   4 , #219); 
  object(171, 19,  1,   1,   4 , #219); 
  object(170, 19,  1,   1,   4 , #219); 
  object(168, 20,  1,   1,   4 , #219); 
  object(169, 21,  1,   1,   4 , #219); 
  object(172, 20,  1,   1,   4 , #219); 
  object(171, 21,  1,   1,   4 , #219); 
  object(170, 22,  1,   1,   4 , #219); 
  object(167, 21,  1,   1,   4 , #219); 
  object(169, 23,  1,   1,   4 , #219); 
  object(169, 22,  1,   1,   4 , #219); 
  object(167, 20,  1,   1,   4 , #219); 
  object(168, 19,  1,   1,   4 , #219); 
  object(169, 20,  1,   1,   4 , #219); 
  object(170, 21,  1,   1,   4 , #219); 
  object(170, 18,  1,   1,   6 , #219); 
  object(171, 19,  1,   1,   6 , #219); 
  object(169, 20,  1,   1,   6 , #219); 
  object(170, 19,  1,   1,   6 , #219); 
  object(170, 20,  1,   1,   6 , #219); 
  object(170, 21,  1,   1,   6 , #219); 
  object(168, 21,  1,   1,   6 , #219); 
  object(162, 17,  1,   1,   1 , #219); 
  object(157, 25,  1,   1,   9 , #219); 
  object(156, 24,  1,   1,   9 , #219); 
  object(155, 23,  1,   1,   9 , #219); 
  object(158, 25,  1,   1,   9 , #219); 
  object(161, 27,  1,   1,   9 , #219); 
  object(161, 28,  1,   1,   9 , #219); 
  object(180, 28,  1,   1,   9 , #219); 
  object(180, 27,  1,   1,   9 , #219); 
  object(184, 25,  1,   1,   9 , #219); 
  object(183, 25,  1,   1,   9 , #219); 
  object(185, 24,  1,   1,   9 , #219); 
  object(186, 23,  1,   1,   9 , #219); 
  object(180, 21,  1,   1,   9 , #219); 
  object(181, 20,  1,   1,   9 , #219); 
  object(183, 20,  1,   1,   9 , #219); 
  object(179, 24,  1,   1,   9 , #219); 
  object(179, 23,  1,   1,   9 , #219); 
  object(162, 23,  1,   1,   9 , #219); 
  object(162, 24,  1,   1,   9 , #219); 
  object(163, 24,  1,   1,   9 , #219); 
  object(178, 24,  1,   1,   9 , #219); 
  object(161, 23,  1,   1,   9 , #219); 
  object(161, 22,  1,   1,   9 , #219); 
  object(180, 23,  1,   1,   9 , #219); 
  object(160, 20,  1,   1,   9 , #219); 
  object(156, 21,  1,   1,   9 , #219); 
  object(158, 20,  1,   1,   9 , #219); 
  object(161, 26,  1,   1,   9 , #219); 
  object(159, 16,  1,   1,   9 , #219); 
  object(155, 16,  1,   1,   9 , #219); 
  object(152, 16,  1,   1,   9 , #219); 
  object(151, 17,  1,   1,   9 , #219); 
  object(153, 15,  1,   1,   9 , #219); 
  object(154, 14,  1,   1,   9 , #219); 
  object(155, 13,  1,   1,   9 , #219); 
  object(156, 12,  1,   1,   9 , #219); 
  object(157, 11,  1,   1,   9 , #219); 
  object(158, 12,  1,   1,   9 , #219); 
  object(183, 12,  1,   1,   9 , #219); 
  object(184, 11,  1,   1,   9 , #219); 
  object(185, 12,  1,   1,   9 , #219); 
  object(186, 13,  1,   1,   9 , #219); 
  object(187, 14,  1,   1,   9 , #219); 
  object(188, 15,  1,   1,   9 , #219); 
  object(189, 16,  1,   1,   9 , #219); 
  object(190, 17,  1,   1,   9 , #219); 
  object(186, 16,  1,   1,   9 , #219); 
  object(182, 16,  1,   1,   9 , #219); 
  object(174, 16,  1,   1,   9 , #219); 
  object(176, 15,  1,   1,   9 , #219); 
  object(165, 15,  1,   1,   9 , #219); 
  object(167, 16,  1,   1,   9 , #219); 
  object(167, 27,  8,   1,   1 , #219); 
  object(191, 16,  1,   1,   1 , #219); 
  object(192, 15,  1,   1,   1 , #219); 
  object(193, 14,  1,   1,   1 , #219); 
  object(193, 13,  1,   1,   1 , #219); 
  object(192, 12,  1,   1,   1 , #219); 
  object(191, 11,  1,   1,   1 , #219); 
  object(189, 10,  1,   1,   1 , #219); 
  object(190, 10,  1,   1,   1 , #219); 
  object(185, 10,  1,   1,   1 , #219); 
  object(186, 9 ,  1,   1,   1 , #219); 
  object(188, 9 ,  1,   1,   1 , #219); 
  object(194, 15,  1,   1,   1 , #219); 
  object(194, 16,  1,   1,   1 , #219); 
  object(195, 17,  1,   1,   1 , #219); 
  object(195, 18,  1,   1,   1 , #219); 
  object(193, 17,  1,   1,   1 , #219); 
  object(156, 10,  1,   1,   1 , #219); 
  object(155, 9 ,  1,   1,   1 , #219); 
  object(153, 9 ,  1,   1,   1 , #219); 
  object(152, 10,  1,   1,   1 , #219); 
  object(151, 10,  1,   1,   1 , #219); 
  object(150, 11,  1,   1,   1 , #219); 
  object(149, 12,  1,   1,   1 , #219); 
  object(148, 13,  1,   1,   1 , #219); 
  object(148, 14,  1,   1,   1 , #219); 
  object(147, 15,  1,   1,   1 , #219); 
  object(147, 16,  1,   1,   1 , #219); 
  object(146, 17,  1,   1,   1 , #219); 
  object(146, 18,  1,   1,   1 , #219); 
  object(148, 17,  1,   1,   1 , #219); 
  object(163, 13,  1,   1,   1 , #219); 
  object(162, 12,  1,   1,   1 , #219); 
  object(161, 12,  1,   1,   1 , #219); 
  object(160, 11,  1,   1,   1 , #219); 
  object(158, 10,  1,   1,   1 , #219); 
  object(178, 13,  1,   1,   1 , #219); 
  object(179, 12,  1,   1,   1 , #219); 
  object(180, 12,  1,   1,   1 , #219); 
  object(181, 11,  1,   1,   1 , #219); 
  object(183, 10,  1,   1,   1 , #219); 
  object(192, 16,  1,   1,   9 , #219); 
  object(193, 16,  1,   1,   9 , #219); 
  object(193, 15,  1,   1,   9 , #219); 
  object(191, 15,  1,   1,   9 , #219); 
  object(190, 15,  1,   1,   9 , #219); 
  object(192, 14,  1,   1,   9 , #219); 
  object(191, 14,  1,   1,   9 , #219); 
  object(189, 14,  1,   1,   9 , #219); 
  object(190, 14,  1,   1,   9 , #219); 
  object(188, 13,  5,   1,   9 , #219); 
  object(187, 12,  5,   1,   9 , #219); 
  object(186, 11,  5,   1,   9 , #219); 
  object(186, 10,  3,   1,   9 , #219); 
  object(153, 10,  3,   1,   9 , #219); 
  object(151, 11,  5,   1,   9 , #219); 
  object(150, 12,  5,   1,   9 , #219); 
  object(149, 13,  5,   1,   9 , #219); 
  object(149, 14,  4,   1,   9 , #219); 
  object(148, 15,  4,   1,   9 , #219); 
  object(148, 16,  3,   1,   9 , #219); 
  object(147, 19,  1,   1,   1 , #219); 
  object(148, 20,  1,   1,   1 , #219); 
  object(149, 19,  1,   1,   1 , #219); 
  object(194, 19,  1,   1,   1 , #219); 
  object(193, 20,  1,   1,   1 , #219); 
  object(192, 19,  1,   1,   1 , #219); 
  object(184, 9 ,  1,   1,   1 , #219); 
  object(185, 8 ,  1,   1,   1 , #219); 
  object(187, 9 ,  1,   1,   1 , #219); 
  object(157, 9 ,  1,   1,   1 , #219); 
  object(156, 8 ,  1,   1,   1 , #219); 
  object(154, 9 ,  1,   1,   1 , #219); 
  object(150, 18,  1,   1,   1 , #219); 
  object(191, 18,  1,   1,   1 , #219); 
  object(192, 18,  1,   1,   3 , #219); 
  object(193, 18,  1,   1,   3 , #219); 
  object(194, 18,  1,   1,   3 , #219); 
  object(194, 17,  1,   1,   3 , #219); 
  object(192, 17,  1,   1,   3 , #219); 
  object(193, 19,  1,   1,   3 , #219); 
  object(193, 17,  1,   1,   3 , #219); 
  object(193, 16,  1,   1,   3 , #219); 
  object(193, 15,  1,   1,   3 , #219); 
  object(192, 15,  1,   1,   3 , #219); 
  object(191, 14,  1,   1,   3 , #219); 
  object(192, 14,  1,   1,   3 , #219); 
  object(192, 13,  1,   1,   3 , #219); 
  object(191, 12,  1,   1,   3 , #219); 
  object(189, 12,  1,   1,   3 , #219); 
  object(190, 13,  1,   1,   3 , #219); 
  object(188, 11,  1,   1,   3 , #219); 
  object(187, 10,  1,   1,   3 , #219); 
  object(186, 10,  1,   1,   3 , #219); 
  object(190, 11,  1,   1,   3 , #219); 
  object(149, 13,  1,   1,   3 , #219); 
  object(150, 12,  1,   1,   3 , #219); 
  object(151, 11,  1,   1,   3 , #219); 
  object(154, 10,  1,   1,   3 , #219); 
  object(155, 10,  1,   1,   3 , #219); 
  object(153, 11,  1,   1,   3 , #219); 
  object(152, 12,  1,   1,   3 , #219); 
  object(151, 13,  1,   1,   3 , #219); 
  object(150, 14,  1,   1,   3 , #219); 
  object(149, 14,  1,   1,   3 , #219); 
  object(149, 15,  1,   1,   3 , #219); 
  object(148, 15,  1,   1,   3 , #219); 
  object(148, 16,  1,   1,   3 , #219); 
  object(148, 17,  1,   1,   3 , #219); 
  object(149, 17,  1,   1,   3 , #219); 
  object(147, 17,  1,   1,   3 , #219); 
  object(147, 18,  1,   1,   3 , #219); 
  object(148, 18,  1,   1,   3 , #219); 
  object(149, 18,  1,   1,   3 , #219); 
  object(148, 19,  1,   1,   3 , #219); 
  object(189, 17,  1,   1,   3 , #219); 
  object(188, 16,  1,   1,   3 , #219); 
  object(177, 14,  1,   1,   3 , #219); 
  object(178, 14,  1,   1,   3 , #219); 
  object(179, 13,  1,   1,   3 , #219); 
  object(180, 13,  1,   1,   3 , #219); 
  object(181, 12,  1,   1,   3 , #219); 
  object(182, 11,  1,   1,   3 , #219); 
  object(184, 10,  1,   1,   3 , #219); 
  object(185, 9 ,  1,   1,   3 , #219); 
  object(156, 9 ,  1,   1,   3 , #219); 
  object(157, 10,  1,   1,   3 , #219); 
  object(159, 11,  1,   1,   3 , #219); 
  object(160, 12,  1,   1,   3 , #219); 
  object(161, 13,  1,   1,   3 , #219); 
  object(162, 13,  1,   1,   3 , #219); 
  object(163, 14,  1,   1,   3 , #219); 
  object(164, 14,  1,   1,   3 , #219); 
  object(164, 15,  1,   1,   3 , #219); 
  object(163, 15,  1,   1,   3 , #219); 
  object(162, 13,  1,   1,   3 , #219); 
  object(161, 14,  1,   1,   3 , #219); 
  object(162, 14,  1,   1,   3 , #219); 
  object(160, 13,  1,   1,   3 , #219); 
  object(181, 13,  1,   1,   3 , #219); 
  object(180, 14,  1,   1,   3 , #219); 
  object(179, 14,  1,   1,   3 , #219); 
  object(178, 15,  1,   1,   3 , #219); 
  object(177, 15,  1,   1,   3 , #219); 
  object(169, 26,  1,   1,   11, #219); 
  object(170, 26,  1,   1,   11, #219); 
  object(171, 26,  1,   1,   11, #219); 
  object(172, 26,  1,   1,   11, #219); 
  object(173, 25,  1,   1,   11, #219); 
  object(168, 25,  1,   1,   11, #219); 
  object(167, 24,  1,   1,   11, #219); 
  object(166, 23,  1,   1,   11, #219); 
  object(174, 24,  1,   1,   11, #219); 
  object(175, 23,  1,   1,   11, #219); 
  object(175, 22,  1,   1,   11, #219); 
  object(175, 21,  1,   1,   11, #219); 
  object(166, 22,  1,   1,   11, #219); 
  object(166, 21,  1,   1,   11, #219); 
  object(174, 20,  1,   1,   11, #219); 
  object(173, 19,  1,   1,   11, #219); 
  object(171, 27,  1,   1,   11, #219); 
  object(170, 27,  1,   1,   11, #219); 
  object(169, 25,  1,   1,   11, #219); 
  object(170, 25,  1,   1,   11, #219); 
  object(171, 25,  1,   1,   11, #219); 
  object(172, 25,  1,   1,   11, #219); 
  object(173, 24,  1,   1,   11, #219); 
  object(172, 24,  1,   1,   11, #219); 
  object(171, 24,  1,   1,   11, #219); 
  object(170, 24,  1,   1,   11, #219); 
  object(169, 24,  1,   1,   11, #219); 
  object(168, 24,  1,   1,   11, #219); 
  object(168, 23,  1,   1,   11, #219); 
  object(167, 23,  1,   1,   11, #219); 
  object(167, 22,  1,   1,   11, #219); 
  object(168, 22,  1,   1,   11, #219); 
  object(171, 22,  1,   1,   11, #219); 
  object(172, 22,  1,   1,   11, #219); 
  object(173, 22,  1,   1,   11, #219); 
  object(174, 22,  1,   1,   11, #219); 
  object(174, 23,  1,   1,   11, #219); 
  object(173, 23,  1,   1,   11, #219); 
  object(172, 23,  1,   1,   11, #219); 
  object(171, 23,  1,   1,   11, #219); 
  object(170, 23,  1,   1,   11, #219); 
  object(172, 21,  1,   1,   11, #219); 
  object(173, 21,  1,   1,   11, #219); 
  object(174, 21,  1,   1,   11, #219); 
  object(173, 20,  1,   1,   11, #219); 
  object(194, 21,  1,   1,   1 , #219); 
  object(195, 22,  1,   1,   1 , #219); 
  object(195, 23,  1,   1,   1 , #219); 
  object(195, 24,  1,   1,   1 , #219); 
  object(194, 25,  1,   1,   1 , #219); 
  object(193, 26,  1,   1,   1 , #219); 
  object(190, 26,  1,   1,   1 , #219); 
  object(189, 26,  1,   1,   1 , #219); 
  object(190, 25,  1,   1,   1 , #219); 
  object(191, 24,  1,   1,   1 , #219); 
  object(190, 23,  1,   1,   1 , #219); 
  object(188, 22,  1,   1,   1 , #219); 
  object(190, 27,  1,   1,   1 , #219); 
  object(191, 28,  1,   1,   1 , #219); 
  object(192, 27,  1,   1,   1 , #219); 
  object(189, 22,  1,   1,   1 , #219); 
  object(180, 18,  1,   1,   1 , #219); 
  object(189, 19,  1,   1,   1 , #219); 
  object(188, 18,  1,   1,   1 , #219); 
  object(187, 17,  1,   1,   1 , #219); 
  object(182, 17,  1,   1,   1 , #219); 
  object(181, 18,  7,   1,   3 , #219); 
  object(187, 21,  7,   1,   3 , #219); 
  object(186, 20,  7,   1,   3 , #219); 
  object(191, 23,  4,   1,   3 , #219); 
  object(190, 22,  5,   1,   3 , #219); 
  object(184, 19,  5,   1,   3 , #219); 
  object(178, 19,  3,   1,   3 , #219); 
  object(178, 20,  2,   1,   3 , #219); 
  object(185, 17,  2,   1,   3 , #219); 
  object(192, 24,  3,   1,   3 , #219); 
  object(191, 25,  3,   1,   3 , #219); 
  object(190, 26,  3,   1,   3 , #219); 
  object(191, 27,  1,   1,   3 , #219); 
  object(191, 19,  1,   1,   1 , #219); 
  object(190, 19,  1,   1,   1 , #219); 
  object(186, 17,  1,   1,   1 , #219); 
  object(185, 17,  1,   1,   1 , #219); 
  object(178, 19,  3,   1,   9 , #219); 
  object(178, 20,  2,   1,   9 , #219); 
  object(181, 18,  2,   1,   9 , #219); 
  object(184, 19,  2,   1,   9 , #219); 
  object(186, 20,  1,   1,   9 , #219); 
  object(187, 21,  1,   1,   9 , #219); 
  object(190, 22,  1,   1,   9 , #219); 
  object(191, 23,  1,   1,   9 , #219); 
  object(193, 25,  1,   1,   9 , #219); 
  object(192, 26,  1,   1,   9 , #219); 
  object(191, 27,  1,   1,   9 , #219); 
  object(190, 26,  1,   1,   9 , #219); 
  object(194, 24,  1,   1,   9 , #219); 
  object(183, 17,  1,   1,   9 , #219); 
  object(171, 16,  1,   1,   9 , #219); 
  object(172, 15,  1,   1,   0 , #219); 
  object(169, 15,  1,   1,   0 , #219); 
  object(173, 13,  1,   1,   0 , #219); 
  object(168, 13,  1,   1,   0 , #219); 
  object(167, 12,  1,   1,   0 , #219); 
  object(174, 12,  1,   1,   0 , #219); 
  object(165, 12,  1,   1,   0 , #219); 
  object(166, 13,  1,   1,   0 , #219); 
  object(167, 14,  1,   1,   0 , #219); 
  object(166, 11,  1,   1,   0 , #219); 
  object(174, 14,  1,   1,   0 , #219); 
  object(175, 13,  1,   1,   0 , #219); 
  object(176, 12,  1,   1,   0 , #219); 
  object(175, 11,  1,   1,   0 , #219); 
  object(174, 13,  1,   1,   10, #219); 
  object(167, 13,  1,   1,   10, #219); 
  object(167, 14,  1,   1,   1 , #219); 
  object(166, 13,  1,   1,   1 , #219); 
  object(165, 12,  1,   1,   1 , #219); 
  object(174, 14,  1,   1,   1 , #219); 
  object(175, 13,  1,   1,   1 , #219); 
  object(176, 12,  1,   1,   1 , #219); 
  object(175, 12,  1,   1,   10, #219); 
  object(166, 12,  1,   1,   10, #219); 
  object(170, 12,  1,   1,   9 , #219); 
  object(171, 12,  1,   1,   9 , #219); 
  object(171, 11,  1,   1,   9 , #219); 
  object(170, 11,  1,   1,   9 , #219); 
  object(169, 11,  1,   1,   9 , #219); 
  object(169, 10,  1,   1,   9 , #219); 
  object(168, 10,  1,   1,   9 , #219); 
  object(172, 10,  1,   1,   9 , #219); 
  object(173, 10,  1,   1,   9 , #219); 
  object(172, 11,  1,   1,   9 , #219);

End; 

//Knight Sprite

procedure knightSprite;

Begin

   
   object(35,  34,  3,   1,   7 ,  #219);
   object(35,  32,  1,   2,   7 ,  #219);
   object(34,  30,  1,   2,   7 ,  #219);
   object(34,  32,  1,   3,   8 ,  #219);
   object(33,  31,  1,   3,   8 ,  #219);
   object(35,  30,  1,   2,   15,  #219);
   object(36,  33,  1,   1,   15,  #219);
   object(34,  29,  1,   1,   15,  #219);
   object(32,  31,  1,   2,   11,  #219);
   object(33,  29,  1,   2,   11,  #219);
   object(34,  26,  1,   3,   11,  #219);
   object(33,  23,  1,   2,   11,  #219);
   object(34,  22,  1,   1,   11,  #219);
   object(31,  31,  1,   2,   3 ,  #219);
   object(30,  32,  1,   1,   3 ,  #219);
   object(32,  29,  1,   2,   3 ,  #219);
   object(33,  27,  1,   2,   3 ,  #219);
   object(32,  25,  2,   2,   3 ,  #219);
   object(32,  22,  2,   1,   9 ,  #219);
   object(31,  24,  2,   1,   9 ,  #219);
   object(32,  23,  1,   1,   9 ,  #219);
   object(30,  25,  2,   2,   9 ,  #219);
   object(31,  27,  2,   2,   9 ,  #219);
   object(30,  29,  2,   2,   9 ,  #219);
   object(29,  31,  2,   1,   9 ,  #219);
   object(28,  32,  2,   1,   9 ,  #219);
   object(25,  32,  3,   1,   1 ,  #219);
   object(23,  31,  6,   1,   1 ,  #219);
   object(24,  30,  6,   1,   1 ,  #219);
   object(24,  29,  6,   1,   1 ,  #219);
   object(25,  28,  6,   1,   1 ,  #219);
   object(26,  27,  5,   1,   1 ,  #219);
   object(26,  26,  4,   1,   1 ,  #219);
   object(27,  25,  3,   1,   1 ,  #219);
   object(27,  24,  4,   1,   1 ,  #219);
   object(28,  23,  4,   1,   1 ,  #219);
   object(28,  22,  4,   1,   1 ,  #219);
   object(28,  21,  1,   1,   9 ,  #219);
   object(27,  22,  1,   2,   9 ,  #219);
   object(26,  24,  1,   2,   9 ,  #219);
   object(25,  26,  1,   2,   9 ,  #219);
   object(23,  29,  1,   2,   9 ,  #219);
   object(24,  28,  1,   1,   9 ,  #219);
   object(22,  31,  1,   1,   9 ,  #219);
   object(26,  20,  1,   1,   9 ,  #219);
   object(28,  19,  1,   1,   9 ,  #219);
   object(29,  18,  1,   1,   9 ,  #219);
   object(27,  19,  1,   1,   3 ,  #219);
   object(28,  18,  1,   1,   3 ,  #219);
   object(28,  17,  2,   1,   3 ,  #219);
   object(29,  16,  2,   1,   3 ,  #219);
   object(31,  17,  1,   1,   3 ,  #219);
   object(31,  16,  1,   1,   11,  #219);
   object(30,  18,  1,   1,   8 ,  #219);
   object(29,  19,  3,   1,   8 ,  #219);
   object(29,  20,  4,   1,   8 ,  #219);
   object(33,  20,  2,   1,   7 ,  #219);
   object(32,  19,  2,   1,   7 ,  #219);
   object(31,  18,  3,   1,   7 ,  #219);
   object(35,  22,  1,   1,   7 ,  #219);
   object(34,  23,  3,   1,   7 ,  #219);
   object(35,  24,  2,   1,   7 ,  #219);
   object(37,  25,  3,   1,   7 ,  #219);
   object(39,  24,  2,   1,   7 ,  #219);
   object(39,  22,  1,   1,   7 ,  #219);
   object(40,  20,  1,   2,   7 ,  #219);
   object(41,  18,  1,   2,   7 ,  #219);
   object(42,  16,  1,   2,   7 ,  #219);
   object(35,  27,  1,   1,   7 ,  #219);
   object(43,  15,  1,   2,   15,  #219);
   object(42,  18,  1,   1,   15,  #219);
   object(41,  20,  1,   1,   15,  #219);
   object(40,  22,  1,   1,   15,  #219);
   object(39,  23,  1,   1,   8 ,  #219);
   object(36,  25,  1,   1,   8 ,  #219);
   object(34,  24,  1,   1,   8 ,  #219);
   object(27,  33,  1,   1,   8 ,  #219);
   object(26,  33,  1,   1,   8 ,  #219);
   object(28,  33,  1,   1,   7 ,  #219);
   object(34,  25,  1,   1,   15,  #219);
   object(34,  19,  1,   1,   15,  #219);
   object(35,  21,  1,   1,   15,  #219);
   object(36,  22,  1,   1,   15,  #219);
   object(37,  24,  1,   1,   15,  #219);
   object(34,  21,  1,   1,   11,  #220);
   object(32,  16,  1,   1,   11,  #220);
   object(30,  15,  1,   1,   11,  #220);
   object(33,  17,  1,   1,   15,  #220);
   object(37,  23,  1,   1,   15,  #220);
   object(38,  24,  1,   1,   15,  #220);
   object(41,  22,  1,   1,   8 ,  #220);
   object(35,  26,  1,   1,   15,  #220);
   object(43,  14,  1,   1,   15,  #220);
   object(39,  21,  1,   1,   7 ,  #220);
   object(40,  19,  1,   1,   7 ,  #220);
   object(41,  17,  1,   1,   7 ,  #220);
   object(32,  17,  1,   1,   7 ,  #220);
   object(29,  21,  1,   1,   1 ,  #220);
   object(30,  21,  1,   1,   1 ,  #220);
   object(21,  31,  1,   1,   9 ,  #220);
   object(22,  30,  1,   1,   9 ,  #220);
   object(24,  27,  1,   1,   9 ,  #220);
   object(36,  32,  1,   1,   15,  #220);
   object(38,  34,  1,   1,   15,  #220);
   object(27,  18,  1,   1,   3 ,  #220);
   object(30,  17,  1,   1,   3 ,  #223);
   object(26,  21,  1,   1,   9 ,  #223);
   object(27,  20,  1,   1,   9 ,  #223);
   object(22,  32,  1,   1,   9 ,  #223);
   object(23,  32,  1,   1,   9 ,  #223);
   object(24,  32,  1,   1,   1 ,  #223);
   object(30,  33,  1,   1,   3 ,  #223);
   object(31,  33,  1,   1,   11,  #223);
   object(40,  23,  1,   1,   8 ,  #223);
   object(38,  23,  1,   1,   8 ,  #223);
   object(37,  26,  1,   1,   8 ,  #223);
   object(27,  34,  1,   1,   8 ,  #223);
   object(26,  34,  1,   1,   8 ,  #223);
   object(31,  21,  1,   1,   8 ,  #223);
   object(32,  21,  1,   1,   7 ,  #223);
   object(33,  21,  1,   1,   7 ,  #223);
   object(38,  26,  1,   1,   7 ,  #223);
   object(35,  28,  1,   1,   7 ,  #223);
   object(28,  34,  1,   1,   7 ,  #223);
   object(29,  34,  1,   1,   15,  #223);
   object(41,  21,  1,   1,   15,  #223);
   object(42,  19,  1,   1,   15,  #223);
   object(43,  17,  1,   1,   15,  #223);
   object(34,  18,  1,   1,   15,  #223);
   object(35,  34,  1,   1,   8 ,  #219);

End;   

//Gun Slinger Sprite

procedure gunslingerSprite;

Begin
   object(37,  34,  1,   1,   1 ,  #219);
   object(36,  32,  2,   2,   1 ,  #219);
   object(36,  30,  1,   2,   1 ,  #219);
   object(35,  29,  1,   2,   1 ,  #219);
   object(31,  28,  5,   1,   1 ,  #219);
   object(32,  27,  3,   1,   1 ,  #219);
   object(31,  29,  2,   1,   1 ,  #219);
   object(30,  30,  3,   1,   1 ,  #219);
   object(30,  31,  2,   1,   1 ,  #219);
   object(29,  32,  3,   1,   1 ,  #219);
   object(29,  33,  2,   1,   1 ,  #219);
   object(33,  29,  1,   1,   9 ,  #219);
   object(32,  31,  1,   1,   9 ,  #219);
   object(31,  33,  1,   1,   9 ,  #219);
   object(38,  34,  3,   1,   9 ,  #219);
   object(38,  32,  1,   2,   9 ,  #219);
   object(37,  30,  1,   2,   9 ,  #219);
   object(36,  29,  2,   1,   9 ,  #219);
   object(36,  28,  1,   1,   9 ,  #219);
   object(35,  27,  1,   1,   9 ,  #219);
   object(38,  27,  1,   1,   3 ,  #219);
   object(38,  30,  1,   2,   3 ,  #219);
   object(39,  33,  1,   1,   3 ,  #219);
   object(36,  26,  2,   2,   6 ,  #219);
   object(33,  26,  3,   1,   6 ,  #219);
   object(31,  27,  1,   1,   6 ,  #219);
   object(37,  28,  1,   1,   6 ,  #219);
   object(40,  26,  1,   1,   6 ,  #219);
   object(41,  26,  1,   1,   6 ,  #219);
   object(42,  24,  2,   1,   6 ,  #219);
   object(36,  25,  1,   1,   7 ,  #219);
   object(35,  24,  2,   1,   7 ,  #219);
   object(37,  23,  3,   1,   7 ,  #219);
   object(37,  22,  2,   1,   7 ,  #219);
   object(38,  24,  2,   1,   7 ,  #219);
   object(40,  25,  3,   1,   7 ,  #219);
   object(39,  25,  1,   1,   8 ,  #219);
   object(37,  24,  1,   1,   8 ,  #219);
   object(36,  23,  1,   1,   8 ,  #219);
   object(35,  25,  1,   1,   8 ,  #219);
   object(44,  24,  1,   1,   8 ,  #219);
   object(43,  23,  2,   1,   8 ,  #219);
   object(45,  22,  2,   1,   8 ,  #219);
   object(47,  21,  1,   1,   8 ,  #219);
   object(40,  24,  1,   1,   15,  #219);
   object(36,  21,  1,   1,   12,  #219);
   object(35,  22,  2,   1,   12,  #219);
   object(34,  23,  2,   1,   12,  #219);
   object(33,  24,  2,   1,   12,  #219);
   object(33,  25,  1,   1,   12,  #219);
   object(34,  25,  1,   1,   8 ,  #219);
   object(31,  26,  2,   1,   12,  #219);
   object(30,  27,  1,   1,   12,  #219);
   object(31,  24,  1,   1,   12,  #219);
   object(28,  24,  1,   1,   12,  #219);
   object(29,  23,  1,   1,   12,  #219);
   object(31,  22,  1,   1,   12,  #219);
   object(32,  22,  3,   1,   4 ,  #219);
   object(30,  23,  4,   1,   4 ,  #219);
   object(34,  21,  2,   1,   4 ,  #219);
   object(29,  24,  2,   1,   4 ,  #219);
   object(29,  25,  1,   1,   4 ,  #219);
   object(32,  24,  1,   1,   4 ,  #219);
   object(31,  25,  2,   1,   4 ,  #219);
   object(31,  21,  2,   1,   6 ,  #219);
   object(32,  20,  3,   1,   6 ,  #219);
   object(32,  19,  2,   1,   6 ,  #219);
   object(34,  19,  2,   1,   14,  #219);
   object(35,  20,  3,   1,   14,  #219);
   object(41,  24,  1,   1,   15,  #220);
   object(40,  23,  1,   1,   15,  #220);
   object(39,  22,  1,   1,   15,  #220);
   object(37,  21,  1,   1,   12,  #220);
   object(30,  22,  1,   1,   12,  #220);
   object(27,  24,  1,   1,   12,  #220);
   object(28,  25,  1,   1,   4 ,  #220);
   object(30,  26,  1,   1,   4 ,  #220);
   object(30,  21,  1,   1,   6 ,  #220);
   object(31,  19,  1,   1,   6 ,  #220);
   object(34,  18,  1,   1,   14,  #220);
   object(39,  19,  1,   1,   14,  #220);
   object(35,  18,  1,   1,   15,  #220);
   object(36,  19,  1,   1,   15,  #220);
   object(38,  26,  1,   1,   6 ,  #220);
   object(38,  29,  1,   1,   3 ,  #220);
   object(39,  32,  1,   1,   3 ,  #220);
   object(41,  34,  1,   1,   3 ,  #220);
   object(44,  22,  1,   1,   8 ,  #220);
   object(46,  21,  1,   1,   8 ,  #220);
   object(48,  20,  1,   1,   8 ,  #220);
   object(50,  19,  1,   1,   8 ,  #220);
   object(49,  20,  1,   1,   8 ,  #223);
   object(48,  21,  1,   1,   8 ,  #223);
   object(45,  23,  1,   1,   8 ,  #223);
   object(38,  25,  1,   1,   8 ,  #223);
   object(37,  25,  1,   1,   15,  #219);
   object(38,  20,  1,   1,   14,  #223);
   object(33,  21,  1,   1,   6 ,  #223);
   object(43,  25,  1,   1,   6 ,  #223);
   object(40,  27,  1,   1,   6 ,  #223);
   object(39,  26,  1,   1,   6 ,  #223);
   object(38,  28,  1,   1,   3 ,  #223);
   object(32,  32,  1,   1,   3 ,  #223);
   object(33,  30,  1,   1,   3 ,  #223);
   object(32,  34,  1,   1,   3 ,  #223);
   object(28,  26,  1,   1,   12,  #223);
   object(30,  25,  1,   1,   12,  #223);
   object(31,  34,  1,   1,   9 ,  #223);
   object(29,  34,  1,   1,   1 ,  #223);
   object(30,  34,  1,   1,   1 ,  #223);

End;

//Mage Fight Sprite

procedure mageSprite;

Begin

	object(10, 10,  2 ,  2,   0,   #219);
	object(34, 34,  1 ,  1,   1,   #219);
	object(34, 33,  3 ,  1,   1,   #219);
	object(33, 32,  5 ,  1,   1,   #219);
	object(33, 31,  4 ,  1,   1,   #219);
	object(32, 30,  4 ,  1,   1,   #219);
	object(32, 29,  4 ,  1,   1,   #219);
	object(33, 28,  2 ,  1,   1,   #219);
	object(33, 27,  3 ,  1,   1,   #219);
	object(32, 26,  3 ,  1,   1,   #219);
	object(32, 25,  3 ,  1,   1,   #219);
	object(33, 24,  1 ,  1,   1,   #219);
	object(31, 20,  1 ,  2,   1,   #219);
	object(30, 19,  1 ,  2,   1,   #219);
	object(29, 18,  1 ,  1,   1,   #219);
	object(30, 22,  1 ,  1,   1,   #219);
	object(28, 26,  4 ,  1,   9,   #219);
	object(28, 27,  5 ,  1,   9,   #219);
	object(28, 28,  5 ,  1,   9,   #219);
	object(27, 29,  5 ,  1,   9,   #219);
	object(27, 30,  5 ,  1,   9,   #219);
	object(26, 31,  7 ,  1,   9,   #219);
	object(25, 32,  8 ,  1,   9,   #219);
	object(24, 33,  10,  1,   9,   #219);
	object(31, 34,  3 ,  1,   9,   #219);
	object(29, 21,  2 ,  1,   9,   #219);
	object(28, 22,  2 ,  1,   9,   #219);
	object(29, 25,  1 ,  1,   9,   #219);
	object(28, 24,  1 ,  1,   9,   #219);
	object(27, 25,  2 ,  1,   3,   #219);
	object(26, 26,  2 ,  1,   3,   #219);
	object(32, 24,  1 ,  1,   7,   #219);
	object(33, 23,  1 ,  1,   7,   #219);
	object(34, 22,  1 ,  1,   7,   #219);
	object(32, 22,  2 ,  1,   8,   #219);
	object(29, 23,  4 ,  1,   8,   #219);
	object(29, 24,  3 ,  1,   8,   #219);
	object(30, 25,  2 ,  1,   8,   #219);
	object(34, 23,  1 ,  1,   5,   #219);
	object(34, 24,  2 ,  1,   5,   #219);
	object(35, 25,  2 ,  1,   5,   #219);
	object(35, 26,  3 ,  1,   5,   #219);
	object(36, 27,  3 ,  1,   5,   #219);
	object(35, 28,  2 ,  1,   5,   #219);
	object(36, 29,  1 ,  1,   5,   #219);
	object(37, 31,  1 ,  1,   5,   #219);
	object(36, 30,  2 ,  1,   5,   #219);
	object(38, 32,  1 ,  1,   5,   #219);
	object(37, 33,  3 ,  1,   5,   #219);
	object(38, 28,  3 ,  1,   5,   #219);
	object(39, 29,  1 ,  1,   5,   #219);
	object(40, 27,  1 ,  1,   5,   #219);
	object(40, 26,  2 ,  1,   5,   #219);
	object(42, 25,  1 ,  1,   5,   #219);
	object(42, 21,  1 ,  1,   5,   #219);
	object(40, 20,  1 ,  1,   5,   #219);
	object(32, 21,  2 ,  1,   5,   #219);
	object(32, 20,  1 ,  1,   5,   #219);
	object(31, 19,  1 ,  1,   5,   #219);
	object(30, 18,  1 ,  1,   5,   #219);
	object(29, 17,  1 ,  1,   5,   #219);
	object(31, 18,  1 ,  1,   13,  #219);
	object(32, 19,  1 ,  1,   13,  #219);
	object(33, 20,  1 ,  1,   13,  #219);
	object(34, 21,  1 ,  1,   13,  #219);
	object(36, 24,  1 ,  1,   13,  #219);
	object(37, 25,  5 ,  1,   13,  #219);
	object(40, 24,  3 ,  1,   13,  #219);
	object(38, 26,  2 ,  1,   13,  #219);
	object(39, 27,  1 ,  1,   13,  #219);
	object(37, 28,  1 ,  2,   13,  #219);
	object(38, 30,  1 ,  2,   13,  #219);
	object(39, 32,  1 ,  1,   13,  #219);
	object(42, 20,  1 ,  1,   13,  #219);
	object(43, 20,  1 ,  1,   13,  #219);
	object(43, 21,  1 ,  1,   13,  #219);
	object(44, 20,  1 ,  1,   15,  #219);
	object(44, 21,  1 ,  1,   6,   #219);
	object(42, 22,  1 ,  2,   6,   #219);
	object(41, 20,  1 ,  2,   6,   #219);
	object(41, 27,  1 ,  3,   6,   #219);
	object(40, 30,  1 ,  3,   6,   #219);
	object(43, 22,  1 ,  1,   6,   #223);
	object(41, 22,  1 ,  1,   6,   #223);
	object(40, 21,  1 ,  1,   5,   #223);
	object(37, 34,  1 ,  1,   5,   #223);
	object(36, 34,  1 ,  1,   5,   #223);
	object(28, 17,  1 ,  1,   5,   #223);
	object(26, 23,  1 ,  1,   9,   #223);
	object(23, 33,  1 ,  1,   9,   #223);
	object(27, 34,  4 ,  1,   9,   #223);
	object(35, 34,  1 ,  1,   1,   #223);
	object(31, 22,  1 ,  1,   1,   #223);
	object(27, 27,  1 ,  1,   3,   #223);
	object(37, 21,  1 ,  1,   13,  #223);
	object(35, 21,  1 ,  1,   13,  #220);
	object(36, 21,  1 ,  1,   13,  #220);
	object(35, 23,  1 ,  1,   13,  #220);
	object(30, 17,  1 ,  1,   13,  #220);
	object(43, 19,  1 ,  1,   15,  #220);
	object(42, 19,  1 ,  1,   6,   #220);
	object(41, 19,  1 ,  1,   5,   #220);
	object(41, 23,  1 ,  1,   13,  #220);
	object(40, 33,  1 ,  1,   13,  #220);
	object(26, 25,  1 ,  1,   3,   #220);
	object(27, 24,  1 ,  1,   3,   #220);
	object(27, 22,  1 ,  1,   9,   #220);
	object(29, 20,  1 ,  1,   9,   #220);
	object(28, 23,  1 ,  1,   9,   #220);

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

procedure lose;

Begin

   object(28 , 15,  152, 16,  4,   #219);
   object(44 , 17,  7  , 1 ,  8,   #219);
   object(42 , 18,  3  , 1 ,  8,   #219);
   object(40 , 19,  3  , 1 ,  8,   #219);
   object(39 , 20,  2  , 5 ,  8,   #219);
   object(40 , 25,  3  , 1 ,  8,   #219);
   object(42 , 26,  3  , 1 ,  8,   #219);
   object(44 , 27,  7  , 1 ,  8,   #219);
   object(50 , 26,  3  , 1 ,  8,   #219);
   object(52 , 25,  3  , 1 ,  8,   #219);
   object(54 , 23,  2  , 2 ,  8,   #219);
   object(49 , 23,  5  , 1 ,  8,   #219);
   object(50 , 18,  3  , 1 ,  8,   #219);
   object(52 , 19,  3  , 1 ,  8,   #219);
   object(61 , 20,  3  , 1 ,  8,   #219);
   object(62 , 19,  3  , 1 ,  8,   #219);
   object(63 , 18,  3  , 1 ,  8,   #219);
   object(65 , 17,  6  , 1 ,  8,   #219);
   object(70 , 18,  3  , 1 ,  8,   #219);
   object(71 , 19,  3  , 1 ,  8,   #219);
   object(72 , 20,  3  , 1 ,  8,   #219);
   object(72 , 21,  3  , 7 ,  8,   #219);
   object(61 , 21,  3  , 7 ,  8,   #219);
   object(64 , 22,  8  , 1 ,  8,   #219);
   object(78 , 17,  3  , 11,  8,   #219);
   object(80 , 18,  3  , 1 ,  8,   #219);
   object(81 , 19,  3  , 1 ,  8,   #219);
   object(82 , 20,  3  , 1 ,  8,   #219);
   object(83 , 21,  3  , 1 ,  8,   #219);
   object(85 , 22,  3  , 1 ,  8,   #219);
   object(87 , 21,  3  , 1 ,  8,   #219);
   object(88 , 20,  3  , 1 ,  8,   #219);
   object(89 , 19,  3  , 1 ,  8,   #219);
   object(90 , 18,  3  , 1 ,  8,   #219);
   object(91 , 17,  3  , 1 ,  8,   #219);
   object(92 , 17,  3  , 11,  8,   #219);
   object(98 , 17,  3  , 11,  8,   #219);
   object(98 , 17,  11 , 2 ,  8,   #219);
   object(98 , 26,  11 , 2 ,  8,   #219);
   object(98 , 21,  11 , 2 ,  8,   #219);
   object(118, 17,  8  , 1 ,  8,   #219);
   object(116, 18,  3  , 1 ,  8,   #219);
   object(125, 18,  3  , 1 ,  8,   #219);
   object(127, 19,  3  , 1 ,  8,   #219);
   object(114, 19,  3  , 1 ,  8,   #219);
   object(113, 20,  2  , 5 ,  8,   #219);
   object(114, 25,  3  , 1 ,  8,   #219);
   object(116, 26,  3  , 1 ,  8,   #219);
   object(118, 27,  8  , 1 ,  8,   #219);
   object(129, 20,  2  , 5 ,  8,   #219);
   object(127, 25,  3  , 1 ,  8,   #219);
   object(126, 26,  3  , 1 ,  8,   #219);
   object(101, 21,  8  , 1 ,  4,   #219);
   object(101, 18,  8  , 1 ,  4,   #219);
   object(101, 26,  8  , 1 ,  4,   #219);
   object(106, 22,  4  , 1 ,  4,   #219);
   object(135, 17,  3  , 7 ,  8,   #219);
   object(136, 24,  3  , 1 ,  8,   #219);
   object(137, 25,  3  , 1 ,  8,   #219);
   object(138, 26,  3  , 1 ,  8,   #219);
   object(140, 27,  3  , 1 ,  8,   #219);
   object(142, 26,  3  , 1 ,  8,   #219);
   object(143, 25,  3  , 1 ,  8,   #219);
   object(144, 24,  3  , 1 ,  8,   #219);
   object(145, 19,  3  , 5 ,  8,   #219);
   object(135, 17,  3  , 2 ,  4,   #219);
   object(151, 19,  3  , 9 ,  8,   #219);
   object(154, 19,  4  , 1 ,  8,   #219);
   object(154, 23,  4  , 1 ,  8,   #219);
   object(154, 27,  4  , 1 ,  8,   #219);
   object(162, 19,  3  , 9 ,  8,   #219);
   object(170, 19,  3  , 4 ,  8,   #219);
   object(164, 18,  7  , 1 ,  8,   #219);
   object(164, 23,  7  , 1 ,  8,   #219);
   object(169, 23,  2,   4,   8,   #219);

	delay(5000);

End;  

procedure victory;

Begin

 object(31,  19,  144, 13,  3, #219);   
 object(34 , 22,  1,   2,   6, #219);
 object(35 , 23,  1,   2,   6, #219);
 object(36 , 24,  1,   2,   6, #219);
 object(37 , 25,  1,   2,   6, #219);
 object(38 , 26,  1,   2,   6, #219);
 object(39 , 27,  1,   2,   6, #219);
 object(40 , 27,  1,   2,   6, #219);
 object(41 , 26,  1,   2,   6, #219);
 object(42 , 25,  1,   2,   6, #219);
 object(43 , 24,  1,   2,   6, #219);
 object(44 , 23,  1,   2,   6, #219);
 object(45 , 22,  1,   2,   6, #219);
 object(48 , 22,  2,   1,   6, #219);
 object(48 , 24,  2,   5,   6, #219);
 object(53 , 24,  1,   2,   6, #219);
 object(53 , 25,  1,   2,   6, #219);
 object(54 , 26,  1,   2,   6, #219);
 object(54 , 23,  1,   2,   6, #219);
 object(55 , 27,  1,   2,   6, #219);
 object(55 , 22,  1,   2,   6, #219);
 object(56 , 28,  1,   1,   6, #219);
 object(57 , 28,  1,   1,   6, #219);
 object(58 , 28,  1,   1,   6, #219);
 object(59 , 28,  1,   1,   6, #219);
 object(60 , 27,  1,   1,   6, #219);
 object(56 , 22,  1,   1,   6, #219);
 object(57 , 22,  1,   1,   6, #219);
 object(58 , 22,  1,   1,   6, #219);
 object(59 , 22,  1,   1,   6, #219);
 object(60 , 23,  1,   1,   6, #219);
 object(66 , 21,  3,   8,   6, #219);
 object(63 , 22,  9,   1,   6, #219);
 object(78 , 22,  5,   1,   6, #219);
 object(76 , 23,  3,   1,   6, #219);
 object(75 , 24,  2,   3,   6, #219);
 object(76 , 27,  3,   1,   6, #219);
 object(78 , 28,  5,   1,   6, #219);
 object(82 , 27,  3,   1,   6, #219);
 object(82 , 23,  3,   1,   6, #219);
 object(84 , 24,  2,   3,   6, #219);
 object(88 , 22,  2,   7,   6, #219);
 object(90 , 22,  5,   1,   6, #219);
 object(90 , 25,  5,   1,   6, #219);
 object(94 , 23,  2,   2,   6, #219);
 object(94 , 26,  2,   3,   6, #219);
 object(98 , 22,  2,   3,   6, #219);
 object(106, 22,  2,   6,   6, #219);
 object(105, 27,  2,   2,   6, #219);
 object(101, 29,  5,   1,   6, #219);
 object(99 , 28,  3,   1,   6, #219);
 object(100, 25,  5,   1,   6, #219);
 object(105, 24,  1,   1,   6, #219);
 object(113, 21,  2,   9,   6, #219);
 object(115, 21,  8,   1,   6, #219);
 object(122, 22,  2,   3,   6, #219);
 object(115, 25,  8,   1,   6, #219);
 object(122, 26,  2,   4,   6, #219);
 object(126, 24,  2,   3,   6, #219);
 object(127, 23,  3,   1,   6, #219);
 object(127, 27,  3,   1,   6, #219);
 object(129, 28,  5,   1,   6, #219);
 object(129, 22,  5,   1,   6, #219);
 object(133, 23,  3,   1,   6, #219);
 object(133, 27,  3,   1,   6, #219);
 object(135, 24,  2,   3,   6, #219);
 object(138, 22,  2,   3,   6, #219);
 object(139, 25,  6,   1,   6, #219);
 object(146, 22,  2,   6,   6, #219);
 object(145, 24,  2,   1,   6, #219);
 object(145, 27,  2,   2,   6, #219);
 object(141, 29,  5,   1,   6, #219);
 object(139, 28,  3,   1,   6, #219);
 object(150, 23,  2,   6,   6, #219);
 object(151, 22,  8,   1,   6, #219);
 object(151, 25,  8,   1,   6, #219);
 object(159, 23,  2,   6,   6, #219);
 object(163, 21,  2,   8,   6, #219);
 object(165, 28,  7,   1,   6, #219);

Delay(5000);

 End;

// Stats Calc Procedure

procedure statCalc(statIndex: integer);

Begin

	if((statPoints > 0) and (statIndex < 4)) then
	begin
		statPoints := statPoints - 1; 
		case (statIndex) of
			1: statMelee := statMelee + 1;
			2: statMagic := statMagic + 1; 
			3: statRange := statRange + 1;
		end;	  
	end;

	if((statDinheiro > 500) and (statIndex > 3)) then
	begin
	 	statDinheiro := statDinheiro - 500;
		case (statIndex) of
			4: itemCura := itemCura + 1;
			5: itemDano := statMagic + 1; 
		end;	  
	end;	
	
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
	  object(24, 6, 2, 22, 14, #219);
    object(128, 6, 2, 22, 14, #219);
    object(25, 6, 104, 1, 14, #219);
    object(25, 27, 104, 1, 14, #219);
    object(25, 27, 104, 1, 14, #219);

	while (out = false) do
	Begin
		textcolor(yellow);
		gotoxy(27,8); write('Pontos Disponíveis: ', statPoints);
		textcolor(white);
		gotoxy(27,10); write(select[1],'Melee: ', statMelee);
		gotoxy(27,12); write(select[2],'Magic: ', statMagic);
		gotoxy(27,14); write(select[3],'Range: ', statRange);
		textcolor(yellow);
		gotoxy(27,17); write('Dinheiro Disponível: ', statDinheiro);
		textcolor(white);
		gotoxy(27,19); write(select[4],'Poção de Cura: ', itemCura, '  (Custa 500)');
		gotoxy(27,21); write(select[5],'Poção de Dano: ', itemDano, '  (Custa 500)');
		textcolor(yellow);
		gotoxy(27,25); write('Pressione "Tab" para sair da loja.');
	
	//Logica

		key := readkey;
		
		case (key) of              
			'w': shoppath := shoppath-1;
      #72: shoppath := shoppath-1;
			's': shoppath := shoppath+1;
      #80: shoppath := shoppath+1;
			#13: statCalc(shoppath);
			#9: Begin out := true; clrscr; end;	
		end;
		
		case (shoppath) of            		
			0: shoppath := 5;
			6: shoppath := 1;
		end;

		//Graph Selecao
		
		for i := 1 to 5 do
			begin                                  
				select[i] := #32
			end;
		select[shoppath] := #62;
	
	End;
End; 

//Fight Procedure Screen

procedure fightScreen(bossIndex: integer);

var out: boolean;
	key: char;
	fightpath,i,n: integer;
	select: array [1..6] of string;
	atacks: array [1..3,1..3] of string;

	espadada, pergaminho, pedrada, tacada, boldaDeFogo, flechada, placagem, rezar, disparar: real;
	selectedAtack, selectedType: real;

	bossAttack: integer;
	bossHealth: integer;
	bossSprite: integer;
	 

Begin

	clrscr;

	bossHealth := 43;

	//Atribuicao Inicial do Dano dos Ataques

	espadada := 8; 
	pergaminho:= 5; 
	pedrada := 1; 
	tacada := 2;  
	boldaDeFogo := 8; 
	flechada := 4; 
	placagem := 6;
	rezar := 0;  
	disparar := 8;

	//Atribuicao Inicial do Nome dos Ataques

	//Knight

	atacks[1,1] := 'Espadada';
	atacks[1,2] := 'Pergaminho';
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
		object(2, 4, 3, 44, 8, #219);
 		object(4, 4, 203, 1, 8, #219);
  	object(205, 4, 3, 44, 8, #219);
		object(4, 40, 203, 1, 8, #219);
 		object(4, 47, 203, 1, 8, #219);

	//Life Bar Player  
		
		Object(8,36,45,1,8, #220);
    Object(8,37,1,1,8,#219);
    Object(52,37,1,1,8,#219);
    Object(8,38,45,1,8,#223);

	//Life Bar Boss  

		Object(156,31,45,1,8, #220);
    Object(156,32,1,1,8,#219);			
    Object(200,32,1,1,8,#219);
    Object(156,33,45,1,8,#223);	

	//Atribuicoes	 
	
		fightpath := 1;

	//Boss Sprite

	bossSprite := random(5);

	if(bossSprite = 0) then minotauroSprite; 
	if(bossSprite = 1) then dragonSprite;
  if(bossSprite = 2) then cobraSprite;
  if(bossSprite = 3) then dragon2Sprite;
  if(bossSprite = 4) then phenixSprite;

	//Player Sprite

		textcolor(white);

		if(playerClass = 'Knight') then knightSprite;

		if(playerClass = 'Mage') then mageSprite;

	  if(playerClass = 'Gun Slinger') then gunslingerSprite;

	while (out = false) do
	Begin

	//Health Display Player

	gotoxy(9,37); write('                                           ');
    Object(9,37,playerHealth,1,4,#219);	

	//Health Display Boss

    gotoxy(157,32); write('                                           ');
	Object(157,32,bossHealth,1,4,#219);	
	
	textcolor(white);
								
	if (playerClass = 'Knight') then n := 1;

	if (playerClass = 'Mage') then 	n := 2;

	if (playerClass = 'Gun Slinger') then n := 3;

	gotoxy(10,43);  write(select[1],atacks[n,1]);
	gotoxy(35,43);  write(select[2],atacks[n,2]);
	gotoxy(60,43);  write(select[3],atacks[n,3]);
	gotoxy(90,43);  write(select[4],'Poção de Cura (',itemCura,')');
	gotoxy(120,43); write(select[5],'Poção de Dano (',itemDano,')');
	gotoxy(175,43); write(select[6],'Fugir ');			
	
	textcolor(white);

	//Logica

		key := readkey;
		
		case (key) of              
			'a': fightpath := fightpath-1;
      #75: fightpath := fightpath-1;
			'd': fightpath := fightpath+1;
      #77: fightpath := fightpath+1;
			#13: begin

					 //Sair

					if(fightpath = 6) then
					begin
						out := true;
						clrscr;
					end;

					//Player Attack

					if((fightpath < 5) and (fightpath > 3) and (itemCura > 0)) then
						begin
							itemCura := itemCura - 1;
							gotoxy(8,8); write('                                       ');
							gotoxy(8,8); write(playerName, ' usou Poção de Cura');
							playerHealth := 43;	
						end;

					if((fightpath < 6) and (fightpath > 4) and (itemDano > 0)) then
						begin
							itemDano := itemDano - 1;
							gotoxy(8,8); write('                                       ');
							gotoxy(8,8); write(playerName, ' usou Poção de Dano');
							bossHealth := bossHealth - 20;	
						end;	

					if(fightpath < 4) then
						begin
							gotoxy(8,8); write('                                       ');
              gotoxy(8,9); write('                                                         ');
							gotoxy(8,8); write(playerName, ' usou ', atacks[n,fightpath]);

							if(playerClass = 'Knight') then
								begin
									if(fightpath = 1) then begin selectedAtack := espadada; selectedType := statMelee; end; 
									if(fightpath = 2) then begin selectedAtack := pergaminho; selectedType := statMagic; end;  
									if(fightpath = 3) then begin selectedAtack := pedrada; selectedType := statRange; end; 		
								end;

							if(playerClass = 'Mage') then
								begin
									if(fightpath = 1) then begin selectedAtack := tacada; selectedType := statMelee; end;
									if(fightpath = 2) then begin selectedAtack := boldaDeFogo; selectedType := statMagic; end; 
									if(fightpath = 3) then begin selectedAtack := flechada; selectedType := statRange; end;  		
								end;

							if(playerClass = 'Gun Slinger') then
								begin
									if(fightpath = 1) then begin selectedAtack := placagem; selectedType := statMelee; end;
									if(fightpath = 2) then begin selectedAtack := rezar; selectedType := statMagic; end; 
									if(fightpath = 3) then begin selectedAtack := disparar; selectedType := statRange; end;  		
								end;  

              if(((bossSprite = 1) or (bossSprite = 3) or (bossSprite = 4)) and (selectedType = statRange)) then
              begin
                bossHealth := bossHealth - 10;
                textcolor(yellow);
                gotoxy(8,9); write(atacks[n,fightpath], ' é extra eficaz contra estre monstro!');  
                textcolor(white);
              end;

              if((bossSprite = 0) and (selectedType = statMagic)) then
              begin
                bossHealth := bossHealth - 10;
                textcolor(yellow);
                gotoxy(8,9); write(atacks[n,fightpath], ' é extra eficaz contra estre monstro!');  
                textcolor(white);
              end;

              if((bossSprite = 2) and (selectedType = statMelee)) then
              begin
                bossHealth := bossHealth - 10;
                textcolor(yellow);
                gotoxy(8,9); write(atacks[n,fightpath], ' é extra eficaz contra estre monstro!');  
                textcolor(white);
              end;


							bossHealth := int(bossHealth - (selectedAtack + (selectedAtack * selectedType) / 100));			

						end;


						if(bossHealth <= 0) then
						begin
							victory;
							playerHealth := playerHealth + 10;
							if(playerHealth > 43) then playerHealth := 43; 
							bossState[bossIndex] := 'dead';
							clrscr;
							statPoints := statPoints + 6;
							statDinheiro := statDinheiro + 600; 
						    shop;
							out := true;
						end;

						if(playerHealth <= 0) then
						begin
							clrscr;
							lose;
							bossState[bossIndex] := 'alive';
							xplayer := xspawn;
							yplayer := yspawn;
							playerHealth := 43;
							clrscr;
							out := true;
						end;

						//Boss Attack

            gotoxy(157,30); write('                                                ');
                
            delay(1000);

						bossAttack := (random(2) + 1);

						if(bossAttack = 1) then
							begin
								gotoxy(157,35); write('O monstro deu 4 de dano.');
								playerHealth := playerHealth - 4;		
							end;
			
						if(bossAttack = 2) then
							begin
								gotoxy(157,35); write('O monstro deu 6 de dano.');
								playerHealth := playerHealth - 6;		
							end;

						if(bossAttack = 3) then
							begin
								gotoxy(157,35); write('O monstro falhou o ataque');		
							end;		

				end;
			end;	

		//Loop
		
		case (fightpath) of            		
			0: fightpath := 6;
			7: fightpath := 1;
		end;

		//Graph Selecao
		
		for i := 1 to 6 do
			begin                                  
				select[i] := #32
			end;
		select[fightpath] := #62;
	
	End;
clrscr;		
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

    textcolor(13);

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
		

    textcolor(15);
		gotoxy(5,22); write(select[1],' INICIAR');
		gotoxy(5,24); write(select[2],' DEFINICOES');
		gotoxy(5,26); write(select[3],' SAIR');

		key := readkey;
		
		//Logica
		
		case (key) of
      #72: path := path-1;              
			'w': path := path-1;
      #80: path := path+1;
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
    #72: begin yplayer := yplayer - ymovspeed; faceplayer := 'w'; end; 
		's': begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end;
    #80: begin yplayer := yplayer + ymovspeed; faceplayer := 's'; end; 
		'a': begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end;
    #75: begin xplayer := xplayer - xmovspeed; faceplayer := 'a'; end; 
		'd': begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end;
    #77: begin xplayer := xplayer + xmovspeed; faceplayer := 'd'; end; 
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

	bosscheck := bosscollide;

	if(bosscollide <> 0) then
		begin
			fightScreen(bosscheck);
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

//Procedure Keybinds

procedure keybinds;

var key: char;
	out: boolean;


Begin
	while (out = false) do
	Begin
		textcolor(cyan);
		gotoxy(30,9); write('Controlos:');
		
		gotoxy(30,12); write('W / ↑ - Andar para cima ');
		gotoxy(30,13); write('S / ↓ - Andar para baixo');
		gotoxy(30,14); write('A / ← - Andar para a esquerda');
		gotoxy(30,15); write('D / → - Andar para a direita');
		
		gotoxy(30,18); write('"Tab" - Abrir a loja de pontos');
		
		
		gotoxy(30,21); write('"P" - Para voltar');

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
	playerHealth := 43;

	bossState[1] := 'alive';
	bossState[2] := 'alive';
	
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
		
		textcolor(8);	
		gotoxy(130,4); write('"P" - Controlos');
			
		 
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
		gotoxy(156,2); write('Stats:');				 gotoxy(172,2); write('Personagem:');	gotoxy(194,2); write('Avatar:');
		gotoxy(156,3); write('Melee = ', statMelee); gotoxy(172,3); write('Classe = ',playerClass);
		gotoxy(156,4); write('Magic = ', statMagic); gotoxy(172,4); write('Dinheiro = ',statDinheiro);
		gotoxy(156,5); write('Range = ', statRange); gotoxy(172,5); write('Pontos = ', statPoints);

		if(playerClass = 'Knight') then
		begin
			gotoxy(195,3); write(' ',#179,'',#136,' _');
			gotoxy(195,4); write(' ',#197,'O\',#206);
			gotoxy(195,5); write(' / )',#202,' ');	
		end;

			if(playerClass = 'Mage') then
		begin
			gotoxy(195,3); write(' ',#143,' ',#245);
			gotoxy(195,4); write('/H\',#197);
			gotoxy(195,5); write('/_\',#179);	
		end;

			if(playerClass = 'Gun Slinger') then
		begin
			gotoxy(195,3); write('  O');
			gotoxy(195,4); write(''#170'/O\i');
			gotoxy(195,5); write(' / \ ');	
		end;

		{Mundo Alpha
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

		//Mundo Beta

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

		fightObject(45,10,8,5,#219,12);
		fightObject(101,23,8,5,#219,13);
		fightObject(13,39,8,5,#219,4);
		fightObject(151,10,8,5,#219,12);
		fightObject(151,22,8,5,#219,4);
		fightObject(191,18,8,5,#219,13);

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
		'p': begin  clrscr; keybinds; end;
		#9 : shop;
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
devmod := false;

//Main Loop

	cursoroff;
	repeat
		while(path = 0) do
		begin
			menu;
		end;	
		while(path = 1) do
		begin
			if(devmod = false) then
			begin
				conversa;
				instructions;
			end;	
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