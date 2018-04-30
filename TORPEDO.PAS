program TorpedoAttack;
uses Graph, Crt;
var torpedo_count, ship_downed_count,
    x_coord_ship, y_coord_ship,
    x_coord_torpedo, y_coord_torpedo,
    device, mode :integer;
    name, answer, choice :string;
    space_key, menu_key :char;

procedure Menu; forward;
procedure Drawing; forward;
procedure Start; forward;

procedure GameOver;
  begin
    if ship_downed_count=0 then
      begin
        GotoXY(36,5);
        WriteLn('Loser :(')
      end;
    if ship_downed_count>=8 then
      begin
       GotoXY(36,5);
       WriteLn('Professional :)')
      end;
    if (ship_downed_count>=1) and
       (ship_downed_count<=7) then
      begin
        GotoXY(36,5);
        WriteLn('Middle :|')
      end;

    GotoXY(30,7);
    WriteLn('Do you want to play again?');
    GotoXY(38,9);
    ReadLn(choice);
    if choice='yes' then Start
    else Halt
   end;

procedure Counter;
  begin
    torpedo_count:=torpedo_count+1;
    space_key:=ReadKey;
    if torpedo_count>10 then GameOver
    else Drawing
  end;

procedure NotHitTorpedo;
var hz :integer;
  begin
    hz:=100;
    repeat
      Sound(hz);
      Delay(3000);
      hz:=hz+20;
    until hz>400;
    repeat
      Sound(hz);
      Delay(3000);
      hz:=hz-20;
    until hz<10;
    NoSound;

    Counter;
  end;

procedure HitTorpedo;
var hz :integer;
  begin
    ship_downed_count:=ship_downed_count+1;
    hz:=100;
    repeat
     Sound(hz);
     Delay(3000);
     hz:=hz+20;
    until hz>1000;
    NoSound;

    Counter;
  end;

procedure Attack;
  begin
    y_coord_torpedo:=420;
    repeat
     SetColor(White);
     Ellipse(x_coord_ship,y_coord_ship, 0,360, 20,7);
     Ellipse(x_coord_torpedo,y_coord_torpedo, 0,360, 3,15);
     Delay(2000);
     SetColor(Black);
     Ellipse(x_coord_ship,y_coord_ship, 0,360, 20,7);
     Ellipse(x_coord_torpedo,y_coord_torpedo, 0,360, 3,15);

     x_coord_ship:=x_coord_ship+1;
     y_coord_torpedo:=y_coord_torpedo-1;
    until y_coord_torpedo<y_coord_ship;
    if (x_coord_torpedo<=x_coord_ship+20) and
       (x_coord_torpedo>=x_coord_ship) or
       (x_coord_torpedo>=x_coord_ship-20) and
       (x_coord_torpedo<=x_coord_ship) then HitTorpedo
       else NotHitTorpedo;
  end;

procedure Ship;
  begin
    x_coord_ship:=40;
    repeat
      SetColor(White);
      Ellipse(x_coord_ship,y_coord_ship, 0,360, 20,7);
      Delay(2000);
      SetColor(Black);
      Ellipse(x_coord_ship,y_coord_ship, 0,360, 20,7);
      x_coord_ship:=x_coord_ship+1;

      if x_coord_ship>620 then x_coord_ship:=40;
      if KeyPressed then space_key:=ReadKey;
    until space_key=#32;

    Attack;
  end;

procedure Drawing;
var y_line,x_line :integer;
  begin
    ClearDevice;
    SetColor(Cyan);
    Line(0,35, 640,35);
    Line(0,455, 640,455);
    SetColor(Magenta);
    y_line:=458;
    repeat
      Line(0,y_line, 640,y_line);
      y_line:=y_line+3
    until y_line>480;

    x_line:=0;
    repeat
      Line(x_line,458,x_line,480);
      x_line:=x_line+5
    until x_line>640;

    GotoXY(1,2);
    WriteLn(name,'  ', 'Fired torpedoes=',torpedo_count, '  ',
            'Downed ships=',ship_downed_count);
    Ship;
  end;

procedure Start;
  begin
    ClearDevice;
    torpedo_count:=0;
    ship_downed_count:=0;
    Write('Enter your name  ');
    ReadLn(name);
    Drawing;
  end;

procedure Developer;
  begin
    ClearDevice;
    SetTextStyle(0,0,1);
    OutTextXY(10,20, 'Developer: Alidibir Akhbulatov');
    SetTextStyle(3,0,1);
    OutTextXY(10,50, 'Copyright (c) Alidibir Akhbulatov. 2018 year');
    ReadKey;
    if ReadKey=#13 then Menu;
  end;

procedure Help;
  begin
    ClearDevice;
    SetTextStyle(1,0,4);
    OutTextXY(160,20, 'Torpedo Attack');
    SetTextStyle(2,0,8);
    OutTextXY(220,60, 'Description');
    SetTextStyle(0,0,1);
    OutTextXY(1,120, 'The meaning of the game is to shoot torpedoes in flying ships.');
    OutTextXY(1,140, 'The game ends after 10 shot torpedoes.');
    OutTextXY(1,160, 'And after that the result is analyzed and displayed.');
    ReadKey;
    if ReadKey=#13 then Menu;
  end;

procedure Menu;
  begin
    ClearDevice;
    SetTextStyle(4,0,4);
    OutTextXY(250,50, '1. Play');
    OutTextXY(250,90, '2. Help');
    OutTextXY(250,130, '3. Developer');
    OutTextXY(250,170, '4. Exit');
    menu_key:=ReadKey;
  end;

begin
  device:=0;
  initgraph(device,mode, 'C:\TP_7.1\BGI');
  directvideo:=false;
  x_coord_ship:=40;
  y_coord_ship:=80;
  x_coord_torpedo:=450;
  y_coord_torpedo:=420;
  Menu;
  case menu_key of
    '1': Start;
    '2': Help;
    '3': Developer;
    '4': Halt;
  end;
  CloseGraph
end.