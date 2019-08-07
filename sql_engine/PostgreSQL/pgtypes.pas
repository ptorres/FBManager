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
unit pgTypes;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, sqlObjects, SQLEngineCommonTypesUnit, SQLEngineAbstractUnit;

type
  TPGSPVolatCat = (pgvcNone, pgvcVOLATILE, pgvcSTABLE, pgvcIMMUTABLE);

  TPGServerVersion = (pgUnknow,
                      pgVersion7_0,
                      pgVersion8_0,
                      pgVersion8_3,
                      pgVersion8_4,
                      pgVersion9_0,
                      pgVersion9_1,
                      pgVersion9_2,
                      pgVersion9_3,
                      pgVersion9_4,
                      pgVersion9_5,
                      pgVersion9_6,
                      pgVersion10_0,
                      pgVersion11_0
                      );


  TPGRuleAction = (raSelect, raUpdate, raInsert, raDelete);
  TPGRuleWork = (rwALSO, rwINSTEAD);


  TPGUserOption  = (puoLoginEnabled,
                    puoNoLoginEnabled,
                    puoInheritedRight,
                    puoNoInheritedRight,
                    puoSuperUser,
                    puoNoSuperUser,
                    puoCreateDatabaseObjects,
                    puoNoCreateDatabaseObjects,
                    puoCreateRoles,
                    puoNoCreateRoles,
                    puoChangeSystemCatalog,
                    puoNeverExpired,
                    puoCreateUser,
                    puoNoCreateUser,
                    puoReplication,
                    puoNoReplication,
                    puoPasswordEncrypted,
                    puoPasswordUnencrypted,
                    puoByPassRLS,
                    puoNullPassword
                 );



  TPGUserOptions = set of TPGUserOption;

  TPGSettingParamType = (pgstBool, pgstEnum, pgstInteger, pgstReal, pgstString);

  { TPGSettingParam }

  TPGSettingParam = class
  private
    FEnumValues: TStrings;
    FMaxValue: Double;
    FMinValue: Double;
    FParamName: string;
    FParamType: TPGSettingParamType;
  public
    constructor Create;
    destructor Destroy; override;
    property ParamName:string read FParamName write FParamName;
    property ParamType:TPGSettingParamType read FParamType write FParamType;
    property MinValue:Double read FMinValue write FMinValue;
    property MaxValue:Double read FMaxValue write FMaxValue;
    property EnumValues:TStrings read FEnumValues;
  end;

const
  RuleActionStr : array [TPGRuleAction] of string = ('SELECT', 'UPDATE', 'INSERT', 'DELETE');
  RuleWorkStr : array [TPGRuleWork] of string = ('ALSO', 'INSTEAD');

  PGSPVolatCatNames : array [TPGSPVolatCat] of string = ('', 'VOLATILE', 'STABLE', 'IMMUTABLE');
  PGUserOptionStr : array [TPGUserOption] of string = (
    'LOGIN',         //puoLoginEnabled,
    'NOLOGIN',       //puoNoLoginEnabled,
    'INHERIT',       //puoInheritedRight,
    'NOINHERIT',     //puoNoInheritedRight,
    'SUPERUSER',     //puoSuperUser,
    'NOSUPERUSER',   //puoNoSuperUser,
    'CREATEDB',      //puoCreateDatabaseObjects,
    'NOCREATEDB',    //puoNoCreateDatabaseObjects,
    'CREATEROLE',    //puoCreateRoles,
    'NOCREATEROLE',  //puoNoCreateRoles,
    '',              //puoChangeSystemCatalog,
    '',              //puoNeverExpired,
    'CREATEUSER',    //puoCreateUser,
    'NOCREATEUSER',  //puoNoCreateUser,
    'REPLICATION',   //puoReplication,
    'NOREPLICATION', //puoNoReplication,
    '',              //puoPasswordEncrypted,
    '',              //puoPasswordUnencrypted,
    '',              //puoByPassRLS
    ''               //puoNullPassword
                    );

const
  pgServerVersionStr :array [TPGServerVersion] of string =
    ('Unknow',
     'Postgre SQL version 7.0',
     'Postgre SQL version 8.0',
     'Postgre SQL version 8.3',
     'Postgre SQL version 8.4',
     'Postgre SQL version 9.0',
     'Postgre SQL version 9.1',
     'Postgre SQL version 9.2',
     'Postgre SQL version 9.3',
     'Postgre SQL version 9.4',
     'Postgre SQL version 9.5',
     'Postgre SQL version 9.6',
     'Postgre SQL version 10.0',
     'Postgre SQL version 11.0'
     );

  pgZeosServerVersionProtoStr :array [TPGServerVersion] of string =
    ('postgresql',
     'postgresql-7',
     'postgresql-8',
     'postgresql-8',
     'postgresql-8',
     'postgresql-9',
     'postgresql-9', //9.1
     'postgresql-9', //9.2
     'postgresql-9', //9.3
     'postgresql-9', //9.4
     'postgresql-9', //9.5
     'postgresql-9', //9.6
     'postgresql-9', //10.0
     'postgresql-9'  //11.0
     );

implementation

{ TPGSettingParam }

constructor TPGSettingParam.Create;
begin
  inherited Create;
  FEnumValues:=TStringList.Create;
end;

destructor TPGSettingParam.Destroy;
begin
  FreeAndNil(FEnumValues);
  inherited Destroy;
end;

end.

