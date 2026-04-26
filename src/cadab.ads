with Ada.Unbounded_String; use Ada.Unbounded_String;

-- To start, we just want the ability to take a cdb and get something from it
-- Ideas as well:
--
-- . Have an Ord type here for `First, Last, Other` that allows user to specify which hit to get
-- . Allow user to specify how to handle duplicate keys when creating Cdb

package Cadab is
    type Cadab_Type is private;
    procedure Read_Cdb(Source_File: in Unbounded_String; Source_Db: out Cadab_Type);
    function Read_Cdb(Source_File: in Unbounded_String) return Cadab_Type;
    procedure Get(Source_Db: in Cadab_Type; Key: in Unbounded_String; Value: out Unbounded_String);
    function Get(Source_DB: in Cadab_Type; Key: in Unbounded_String) return Unbounded_String;
end Cadab;
