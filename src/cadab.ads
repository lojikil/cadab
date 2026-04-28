with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Interfaces; use Interfaces;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

-- To start, we just want the ability to take a cdb and get something from it
-- Ideas as well:
--
-- . Have an Ord type here for `First, Last, Other` that allows user to specify which hit to get
-- . Allow user to specify how to handle duplicate keys when creating Cdb

package Cadab is
    type Cadab_Type is private;
    type Cadab_Make_Type is private;
    procedure Read_Cdb(Source_File: in Unbounded_String; Source_Db: out Cadab_Type);
    function Read_Cdb(Source_File: in Unbounded_String) return Cadab_Type;
    procedure Find(Source_Db: in Cadab_Type; Key: in Unbounded_String; Value: out Unbounded_String);
    function Find(Source_DB: in Cadab_Type; Key: in Unbounded_String) return Unbounded_String;
    procedure Find_Next(Source_Db: in Cadab_Type; Key: in Unbounded_String; Value: out Unbounded_String);
    function Find_Next(Source_DB: in Cadab_Type; Key: in Unbounded_String) return Unbounded_String;

    procedure Make_Cdb(Source_File: in Unbounded_String; Source_Out: in Cadab_Make_Type);
    function Hash(Key: Unbounded_String) return Unsigned_32;

    private

    package Cadab_Internal_Vector is new
        Ada.Containers.Vectors
            (Element_Type => Unbounded_String,
             Index_Type => Natural);

    use Cadab_Internal_Vector;

    type Cadab_Header is Array (1 .. 512) of Unsigned_32;

    -- thinking about this, should we just make this type limited
    -- and then call it a day?
    type Cadab_Type is
        record
            Map       : Cadab_Header;
            -- Fh        : File_Type;
            Cdb_Size  : Unsigned_32;
            Cdb_Loop  : Unsigned_32;
            Cdb_Khash : Unsigned_32;
            Cdb_Kpos  : Unsigned_32;
            Cdb_Hpos  : Unsigned_32;
            Cdb_HSlots: Unsigned_32;
            Cdb_Dpos  : Unsigned_32;
            Cdb_Dlen  : Unsigned_32;
        end record;

    -- honestly this style is wedding us very much to "this fits in memory" and not
    -- look everything up on disk...
    --
    -- I wonder, should we have two types (tagged records?), one for when we're constructing
    -- things in memory, and one for when we're accessing things on disk?
    --
    -- The other idea is just lean fully into cdb and recreate the format here. it would be
    -- interesting to experiment more with something like LBR but for hash tables...
    --
    -- Looking at the original implementation however, this would be good to keep for
    -- *writing* cdb files...
    type Cadab_Make_Type is
        record
            Keys: Vector;
            Values: Vector;
        end record;
end Cadab;
