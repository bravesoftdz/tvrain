unit untEchoMskRu;

interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IOUtils, System.StrUtils, System.DateUtils,
  IdHTTP, IdGlobalProtocols,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Xml.Win.msxmldom,
  StringFuncs
  ;

procedure EchoDownloadFromRSS(AIdHTTP: TIdHTTP);

implementation


procedure DownloadFile(AIdHTTP: TIdHTTP; AURL, AFileName, ADestFolder: string);
var
  AStream: TFileStream;
  cnt: Integer;
begin
  if not TDirectory.Exists(ADestFolder) then
    TDirectory.CreateDirectory(ADestFolder);
  AStream := TFileStream.Create(ADestFolder + AFileName, fmCreate);
  try
    AIdHTTP.Request.Accept := '*/*';
    cnt := 1;
    repeat
      try
        AIdHTTP.Get(AURL, AStream);
        cnt := 5;
      except
        cnt := cnt + 1;
      end;
    until cnt >= 5;
  finally
    AStream.Free;
  end;
end;

procedure EchoDownloadFromRSS(AIdHTTP: TIdHTTP);
var
  doc: IXMLDocument;
  AStream: TMemoryStream;
  root, item: IXMLNode;
  I: Integer;
  Arr: TStrArray;
  URL, Filename, NewFilename, FileDay, ProgramName, FileTime: string;
  dt: TDate;
  tf: TFormatSettings;
begin
  doc := TXMLDocument.Create(nil);
  AStream := TMemoryStream.Create;
  try
    AIdHTTP.Request.Accept := '*/*';
    AIdHTTP.Get('http://echo.msk.ru/interview/rss-audio.xml', AStream);
    doc.LoadFromStream(AStream);
    root := doc.DocumentElement;
    root := root.ChildNodes.FindNode('channel');
//    pbCount.Position := 0;
//    cbxLog.Items.Clear;
    if root <> nil then
    for I := 0 to root.ChildNodes.Count - 1 do
      if SameText(root.ChildNodes.Get(I).LocalName, 'item') then
      begin
//        pbCount.Max := root.ChildNodes.Count - 1;
//        pbCount.Position := I;
        try
          item := root.ChildNodes.Get(I);
          URL := item.ChildValues['guid'];
          if URL <> '' then //<guid>http://cdn.echo.msk.ru/snd/2015-10-11-razvorot-morning-0706.mp3</guid>
          begin
            Filename := Copy(URL, LastDelimiter('/', URL) + 1, Length(URL));
            Filename := ReplaceStr(Filename, '.mp3', '');
            DecomposeText(Arr, '-', Filename); //2015-10-04-tabel-2005
            if Length(Arr) >= 3 then
            if SameText('bigecho', Arr[3]) or SameText('classicrock', Arr[3])
              or SameText('odna', Arr[3]) or SameText('risk', Arr[3])
              or SameText('vinil', Arr[3]) or SameText('peskov', Arr[3])
              or SameText('unpast', Arr[3]) or SameText('buntman', Arr[3])
              or SameText('farm', Arr[3]) or SameText('apriscatole', Arr[3])
              or SameText('moscowtravel', Arr[3]) or SameText('speakrus', Arr[3])
              or SameText('orders', Arr[3]) or SameText('kazino', Arr[3])
              or SameText('autorsong', Arr[3]) or SameText('redrquare', Arr[3])
              or SameText('museum', Arr[3]) or SameText('voensovet', Arr[3])
              or SameText('parking', Arr[3]) or SameText('graniweek', Arr[3])
              or SameText('gorodovoy', Arr[3]) or SameText('proehali', Arr[3])
              or SameText('skaner', Arr[3]) or SameText('doehali', Arr[3])
              or SameText('zoloto', Arr[3]) or SameText('glam', Arr[3])
              or SameText('babnik', Arr[3]) or SameText('blues', Arr[3])
              or SameText('znamenatel', Arr[3]) or SameText('arsenal', Arr[3])
              or SameText('football', Arr[3]) or SameText('galopom', Arr[3])
              or SameText('autorsong', Arr[3]) or SameText('tabel', Arr[3])
              or SameText('kid', Arr[3]) or SameText('just', Arr[3])
              or SameText('radiodetaly', Arr[3]) or SameText('keys', Arr[3])
              or SameText('blogout1', Arr[3]) or SameText('beatles', Arr[3])
              or SameText('bombard', Arr[3]) or SameText('', Arr[3])
  //            or SameText('', Arr[3]) or SameText('', Arr[3])
            then
              Continue;

            if Length(Arr) >= 3 then
              FileDay := Format('%s-%s', [Arr[1], Arr[2]])
            else
            begin  // FileDay �������� �� ����������� �����
              FileDay := item.ChildValues['pubDate'];
              dt := StrInternetToDateTime(FileDay);
              // 'Mon, 22 May 2017 17:35:00 +0300'
//              dt := XMLTimeToDateTime(FileDay);
              FileDay := Format('%2d-%2d', [MonthOf(dt), DayOf(dt)]);
            end;
            case Length(Arr) of
              5: NewFilename := Format('%s_%s_%s.mp3', [Arr[0] + '-' + FileDay, Arr[4], Arr[3]]);
              6: NewFilename := Format('%s_%s_%s-%s.mp3', [Arr[0] + '-' + FileDay, Arr[5], Arr[3], Arr[4]]);
              else
                NewFilename := Filename + '.mp3';
            end;
            DownloadFile(AIdHTTP, URL, NewFilename, 'H:\Downloads\Echo\' + FileDay + '\');
          end;
        except
          on E: Exception do
          begin
//            cbxLog.Items.Add(Format('Error %s on download file %s', [E.Message, URL] ));
//            if cbxLog.Items.Count = 1 then
//              cbxLog.ItemIndex := 0;
          end;
        end;
      end;
  finally
    AStream.Free;
  end;
end;

end.