{ Free DB Manager

  Copyright (C) 2005-2019 Lagunov Aleksey  alexs75 at yandex.ru

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}

unit pgToolsFindDuplicateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, ComCtrls, ExtCtrls, ZConnection,
  SQLEngineAbstractUnit, fbmAbstractSQLEngineToolsUnit, LMessages,
  fbmToolsUnit;

type

  { TpgToolsFindDuplicateFrame }

  TpgToolsFindDuplicateFrame = class(TAbstractSQLEngineTools)
    Label1: TLabel;
    pgStatDB: TZConnection;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
  private
    function DoFindDups(P:TDBRootObject):TFPList;
    procedure SetSQLEngine(AValue: TSQLEngineAbstract); override;
    procedure DoLoadData;
    procedure LMNotyfyDisconectEngine(var Message: TLMessage); message LM_NOTIFY_DISCONECT_ENGINE;
  public
    function PageName:string; override;
    procedure RefreshPage; override;
  end;

implementation
uses SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TpgToolsFindDuplicateFrame }

function TpgToolsFindDuplicateFrame.DoFindDups(P: TDBRootObject): TFPList;
var
  i, j: Integer;
  P1, P2: TDBObject;
  N, M, MR: TTreeNode;
  P3: TDBRootObject;
  A: TFPList;
  St:TStringList;
begin
  St:=TStringList.Create;
  St.Sorted:=true;
  Result:=nil;
  for i:=0 to P.CountObject-2 do
  begin
    P1:=P.Objects[i];
    if (P1.State <> sdboVirtualObject) and (ST.IndexOf(P1.Caption) < 0) then
    begin
      for j:=i+1 to P.CountObject-1 do
      begin
        P2:=P.Objects[j];
        if (P2.State <> sdboVirtualObject) and (P1.Caption = P2.Caption) then
        begin
          if not Assigned(Result) then
            Result:=TFPList.Create;
          if not Assigned(MR) then
          begin
            ST.Add(P1.Caption);
            MR:=TreeView1.Items.Add(nil, P1.Caption);
            Result.Add(MR);
            N:=TreeView1.Items.AddChild(MR, P1.CaptionFullPatch);
            N.ImageIndex:=DBObjectKindImages[P1.DBObjectKind];
            N.SelectedIndex:=DBObjectKindImages[P1.DBObjectKind];
            N.StateIndex:=DBObjectKindImages[P1.DBObjectKind];
            N.Data:=P1;
          end;

          N:=TreeView1.Items.AddChild(MR, P2.CaptionFullPatch);
          N.ImageIndex:=DBObjectKindImages[P2.DBObjectKind];
          N.SelectedIndex:=DBObjectKindImages[P2.DBObjectKind];
          N.StateIndex:=DBObjectKindImages[P2.DBObjectKind];
          N.Data:=P2;
        end;
      end;
    end;
    MR:=nil;
  end;
  St.Free;


  for i:=0 to P.CountGroups-1 do
  begin
    P3:=P.Groups[i];
    A:=DoFindDups(P3);
    if Assigned(A) then
    begin
      if not Assigned(Result) then
        Result:=TFPList.Create;
      N:=TreeView1.Items.Add(nil, P3.Caption);
      N.ImageIndex:=DBObjectKindImages[P3.DBObjectKind];
      N.StateIndex:=DBObjectKindImages[P3.DBObjectKind];
      N.SelectedIndex:=DBObjectKindImages[P3.DBObjectKind];
      for j:=0 to A.Count-1 do
      begin
        M:=TTreeNode(A[j]);
        M.MoveTo(N, naAddChild);
      end;
      N.Expanded:=true;
      Result.Add(N);
      FreeAndNil(A);
    end;
  end;
end;

procedure TpgToolsFindDuplicateFrame.SetSQLEngine(AValue: TSQLEngineAbstract);
begin
  inherited SetSQLEngine(AValue);
end;

procedure TpgToolsFindDuplicateFrame.DoLoadData;
var
  P: TDBObject;
  N, M: TTreeNode;
  A:TFPList;
  i: Integer;
begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;

  if Assigned(FSQLEngine) then
  begin
    for P in FSQLEngine.Groups do
    begin
      if P is TDBRootObject then
      begin
        A:=DoFindDups(TDBRootObject(P));
        if Assigned(A) then
        begin
          N:=TreeView1.Items.Add(nil, P.Caption);
          N.ImageIndex:=DBObjectKindImages[P.DBObjectKind];
          N.SelectedIndex:=DBObjectKindImages[P.DBObjectKind];
          N.StateIndex:=DBObjectKindImages[P.DBObjectKind];
          for i:=0 to A.Count-1 do
          begin
            M:=TTreeNode(A[i]);
            M.MoveTo(N, naAddChild);
          end;
          N.Expanded:=true;
          FreeAndNil(A);
        end;
      end;
    end;
  end;
  TreeView1.Items.EndUpdate;
end;

procedure TpgToolsFindDuplicateFrame.LMNotyfyDisconectEngine(
  var Message: TLMessage);
var
  D: Pointer;
begin
  D:=Pointer(IntPtr(Message.WParam));
  if D = Pointer(FSQLEngine) then
    RefreshPage;
end;

function TpgToolsFindDuplicateFrame.PageName: string;
begin
  Result:='Duplicate objects';
end;

procedure TpgToolsFindDuplicateFrame.RefreshPage;
begin
  Label1.Visible:=not FSQLEngine.Connected;
  TreeView1.Visible:=FSQLEngine.Connected;
  Splitter1.Visible:=FSQLEngine.Connected;

  if FSQLEngine.Connected then
    DoLoadData
  else
    TreeView1.Items.Clear;
end;

end.

