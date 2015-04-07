procedure SetWallpaper(sWallpaperBMPPath : String; bTile : boolean );
//
// Permite que voce troque o papel de parede do Windows
//
// Requer a unit Registry na clausula Uses
//
// ex: SetWallpaper('c:\windows\win95.bmp',False );
// onde:  True - Lado a Lado
//        False - Centralizado
//
var
 reg : TRegIniFile;
begin
reg := TRegIniFile.Create('Control Panel\Desktop' );
with reg do
     begin
     WriteString( '', 'Wallpaper', sWallpaperBMPPath );
     if( bTile )then
       begin
       WriteString('', 'TileWallpaper', '1' );
       end
     else
       begin
       WriteString('', 'TileWallpaper', '0' );
       end;
     end;
reg.Free;
SystemParametersInfo(SPI_SETDESKWALLPAPER,0,Nil, SPIF_SENDWININICHANGE );
end;
