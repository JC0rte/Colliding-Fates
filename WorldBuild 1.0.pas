Program world_build_test;

var path,turn: integer;
		key: char;
    devmod,rgbplayer: boolean;
		
		objectcount,tpcount,collidecheck,teleportcheck,xres,yres,x,y:integer;  
		objectsave: array [1..100,1..5] of integer;
		teleportpos: array [1..100,1..5] of integer;
		objecttexture: array [1..100] of char;
		
		mundo: integer;


procedure worldbuild;

var xcursor,ycursor,xcursorres,ycursorres,color: integer;
		outworld,paste,del,textureselect,colorselect: boolean;
		i,n,j: integer;
		texture: char;

Begin

	//Atribuições
	
	cursoroff;
	outworld := false;
	xcursor := 10;
	ycursor := 10;
	xcursorres := 2;
	ycursorres := 2;
	objectcount := 1;

	while(outworld = false) do
	Begin
	
	colorselect := false;
	textureselect := false;
	paste := false;
	del := false;
	
	key := readkey;
	
	gotoxy(xcursor,ycursor);
	for i := 1 to xcursorres do
		for n := 1 to ycursorres do
			begin
				gotoxy(xcursor+i,ycursor+n);
				write(' ');
			end;	
	
	case(key)of
		'w': ycursor := ycursor - 1; 
		's': ycursor := ycursor + 1; 
		'a': xcursor := xcursor - 1;
		'd': xcursor := xcursor + 1;
		'i': ycursorres := ycursorres - 1;
		'k': ycursorres := ycursorres + 1;
		'j': xcursorres := xcursorres - 1; 
		'l': xcursorres := xcursorres + 1;
		#13: paste := true;
		 #8: del := true; 
		#27: outworld := true;
		't': textureselect := true;
		'c': colorselect := true;		
	end;
	
	if(textureselect = true) then
		begin
		  gotoxy(4,4);
			textcolor(cyan);
			write(' Textura: ');
			textcolor(green);
			read(texture);
		end;
		
	if(colorselect = true) then
		begin
		  gotoxy(4,6);
			textcolor(cyan);
			write(' Cor: ');
			textcolor(green);
			read(color);
		end;		
	
	if (xcursorres = 0) then
		xcursorres := 1;
	if (ycursorres = 0) then
		ycursorres := 1;	
	
	if (paste = true) then
		begin
			objectcount := objectcount + 1;
		end;
		
	if( del = true) then
		begin
			objectcount := objectcount - 1;
			for j := 1 to objectcount do
				begin
		  		gotoxy(objectsave[j,1],objectsave[j,2]);
					for i := 1 to objectsave[j,3] do
						for n := 1 to objectsave[j,4] do
							begin
								gotoxy(objectsave[j,1]+i,objectsave[j,2]+n);
								write(' ');
				      end;
				end;			
	  end;		
			
	objectsave[objectcount,1] := xcursor;
  objectsave[objectcount,2] := ycursor;
  objectsave[objectcount,3] := xcursorres;
  objectsave[objectcount,4] := ycursorres;
	objectsave[objectcount,5] := color;               
  objecttexture[objectcount] := texture;
									  
	
	for j := 1 to objectcount do
		begin
		  	gotoxy(objectsave[j,1],objectsave[j,2]);
					for i := 1 to objectsave[j,3] do
						for n := 1 to objectsave[j,4] do
							begin
								textcolor(objectsave[j,5]);
								gotoxy(objectsave[j,1]+i,objectsave[j,2]+n);
								write(objecttexture[j]);
							end;
		end;					
				  
	End;
End;

procedure worldstore;

var j: integer;
	
Begin

	for j := 1 to objectcount do
		Begin
			gotoxy(4,j+2);
			write(objectsave[j,1]);
			gotoxy(8,j+2);
    	write(objectsave[j,2]);
    	gotoxy(12,j+2);
    	write(objectsave[j,3]);
    	gotoxy(16,j+2);
    	write(objectsave[j,4]);
			gotoxy(20,j+2);
			write(objectsave[j,5]);
			gotoxy(24,j+2);
			write(objecttexture[j]);	
		End;
End;



Begin
	writeln;
	textcolor(yellow);
	writeln(' Comandos: "wasd" para mover os objetos, "ijkl" para mudar as dimensões, "enter" para colar, "backspace" para apagar, "t" para mudar a textura, "c" para mudar a cor do objeto.');
	textcolor(green);
	worldbuild;
	clrscr;
	worldstore;  
End.