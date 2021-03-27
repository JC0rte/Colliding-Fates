Program projeto_final;

var 

		//Core
		
		path,turn: integer;
		key: char;
    devmod,rgbplayer: boolean;
		
		//Player
		
		xspawn,yspawn,xplayer,yplayer,xmovspeed,ymovspeed: integer;   
		faceplayer: char;
		
		//Objetos
		
		objectcount,tpcount,collidecheck,teleportcheck,xres,yres,x,y:integer;  
		objectpos: array [1..100,1..4] of integer;
		objecttexture: array [1..100] of char;
		teleportpos: array [1..100,1..6] of integer;
	

//Testar Colisão Com Objetos
                                    
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
	

//Testar Colisão Com Portal

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

var select: array [1..3,1..16] of string; 
		i: integer;
		key: char;
		out: boolean;

Begin

	//Atribuição
	
	out := false;
	path := 1;
		
	//Menu	
																													
	while(out = false) do
	begin
		
		textcolor(cyan);
		
		//Graph Seleção
		
		for i := 1 to 3 do
			begin                                  
				select[i,1] := ('          ');
				select[i,2] := ('          ');
				select[i,3] := ('          ');
				select[i,4] := ('          ');
				select[i,5] := ('          ');
				select[i,6] := ('          ');
				select[i,7] := ('          ');
				select[i,8] := ('          ');
				select[i,9] := ('          ');
				select[i,10] := ('          ');
				select[i,11] := ('          ');
				select[i,12] := ('          ');
				select[i,13] := ('          ');
				select[i,14] := ('          ');
				select[i,15] := ('          ');
				select[i,16] := ('          ');
				
			end;
			
			  select[path,1] := ('          ');
				select[path,2] := ('  **      ');
				select[path,3] := (' // **    ');
				select[path,4] := ('  // **   ');
				select[path,5] := ('   // **  ');
				select[path,6] := ('     **/  ');
				select[path,7] := ('   **/    ');
				select[path,8] := (' **/      ');
				select[path,9] := ('//        ');
        select[path,10]:= ('          ');
			              
		
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
		

	 gotoxy(6,22);writeln(select[1,1],'	      ,a8a,                                                             ');
	 gotoxy(6,23);writeln(select[1,2],'	     ,8" "8,                                                            ');
	 gotoxy(6,24);writeln(select[1,3],'	     d8   8b                                                            ');
 	 gotoxy(6,25);writeln(select[1,4],'	     88   88                gg              gg                          ');
   gotoxy(6,26);writeln(select[1,5],'	     88   88                ""              ""                          ');
   gotoxy(6,27);writeln(select[1,6],'	     Y8   8P  ,ggg,,ggg,    gg     ,gggg,   gg     ,gggg,gg   ,gggggg,  ');
   gotoxy(6,28);writeln(select[1,7],'	     `8, ,8  ,8" "8P" "8,   88    dP"  "Yb  88    dP"  "Y8I   dP""""8I  ');
	 gotoxy(6,29);writeln(select[1,8],'	8888  "8,8"  I8   8I   8I   88   i8         88   i8     ,8I  ,8     8I  ');
	 gotoxy(6,30);writeln(select[1,9],'	`8b,  ,d8b, ,dP   8I   Yb,_,88,_,d8,_    __,88,_,d8,   ,d8b,,dP     Y8, ');
	 gotoxy(6,31);writeln(select[1,10],'	  "Y88P" "Y88P    8I   `Y88P""Y8P""Y8888PP8P""Y8P"Y8888P"`Y88P      `Y8 ');
		                                                                                                                                         
	 gotoxy(6,35);writeln(select[2,1],'   ,gggggggggggg,                                                                                        ');
	 gotoxy(6,36);writeln(select[2,2],' dP"""88""""""Y8b,          ,dPYb,                                                                       ');
	 gotoxy(6,37);writeln(select[2,3],' Yb,  88       `8b,         IP `Yb                                                                       ');
	 gotoxy(6,38);writeln(select[2,4],'  `"  88        `8b         I8  8I                         gg                                            ');
	 gotoxy(6,39);writeln(select[2,5],'      88         Y8         I8  8                          ""                                            ');
	 gotoxy(6,40);writeln(select[2,6],'      88         d8 ,ggg,   I8 dP   ,ggg,    ,ggg,,ggg,    gg     ,gggg,    ,ggggg,    ,ggg,     ,g,     ');
	 gotoxy(6,41);writeln(select[2,7],'      88        ,8Pi8" "8i  I8dP   i8" "8i  ,8" "8P" "8,   88    dP"  "Yb  dP"  "Y8gggi8" "8i   ,8 8,    ');
	 gotoxy(6,42);writeln(select[2,8],'      88       ,8P I8, ,8I  I8P    I8, ,8I  I8   8I   8I   88   i8        i8     ,8I  I8, ,8I  ,8   Yb   ');
	 gotoxy(6,43);writeln(select[2,9],'      88______,dP  `YbadP  ,d8b,_  `YbadP  ,dP   8I   Yb,_,88,_,d8,_    _,d8,   ,d8   `YbadP  ,8 _   8)  ');
	 gotoxy(6,44);writeln(select[2,10],'     888888888P"  888P"Y888PI8"888888P"Y8888P    8I   `Y88""Y8P""Y8888PPP"Y8888P"   888P"Y888P  "YY8P8P ');
	 gotoxy(6,45);writeln(select[2,11],'                           I8 `8,                                                                        ');
	 gotoxy(6,46);writeln(select[2,12],'                           I8  `8,                                                                       ');
 	 gotoxy(6,47);writeln(select[2,13],'                           I8   8I                                                                       ');
 	 gotoxy(6,48);writeln(select[2,14],'                           I8   8I                                                                       ');
 	 gotoxy(6,49);writeln(select[2,15],'                           I8, ,8                                                                        ');
 	 gotoxy(6,50);writeln(select[2,16],'                            "Y8P                                                                         ');
		                                                        	                                                             
		
   gotoxy(6,50);writeln(select[3,1],'	     ,gg,     ');
 	 gotoxy(6,51);writeln(select[3,2],'     i8""8i                                  ');
   gotoxy(6,52);writeln(select[3,3],'      `8,,8                                  ');
   gotoxy(6,53);writeln(select[3,4],'      `88                   gg               ');
   gotoxy(6,54);writeln(select[3,5],'       dP"8,                ""               ');
   gotoxy(6,55);writeln(select[3,6],'      dP  `8a    ,gggg,gg   gg    ,gggggg,   ');
   gotoxy(6,56);writeln(select[3,7],'     dP    `Yb  dP"  "Y8I   88    dP""""8I   ');
   gotoxy(6,57);writeln(select[3,8],' _ ,dP      I8 i8     ,8I   88   ,8     8I   ');
   gotoxy(6,58);writeln(select[3,9],' "888,,____,dP,d8,   ,d8b,_,88,_,dP     Y8,  ');
   gotoxy(6,59);writeln(select[3,10],' a8P"Y88888P" P"Y8888P"`Y88P""Y88P      `Y8 ');
																											
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
						write(objectpos[i,n]);
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
	xspawn := 26;
	yspawn := 21;
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

			object(10,10,2,50,#178,11);
			object(12,10,200,1,#178,11);
			object(212,10,2,50,#178,11);
			object(12,59,200,1,#178,11);
		  
		  //Obstaculos
		  object(50,30,1,20,#178,8);
		  object(65,30,2,20,#160,8);
		  object(80,30,3,20,#178,8);
		  object(123,23,20,1,#170,8);
		  object(133,23,20,2,#173,8);
		  
		  //Tp´s
		  
		  teleport(30,14,5,5,#130,5,2);
		  teleport(60,14,5,5,#130,5,1);

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