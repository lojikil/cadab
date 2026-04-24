with Interfaces; use Interfaces;
with Ada.Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Command_Line; use Ada.Command_Line;

-- extremely straightforward translation of https://github.com/jbarham/cdb/blob/master/dump.go
-- I need to clean this up to be more "Ada," but still something useful to get started

procedure cadab_dump is
    header_size : constant unsigned_32 := 256 * 8;
    eod, pos, klen, dlen : unsigned_32 := 0;
    tmp : character;
    s : stream_access;
    fh : file_type;
begin
    if argument_count < 1 then
        Ada.Text_IO.Put_Line("usage: cadab_dump [cdb]");
    else
        Open (fh, in_file, Argument(1));
        s := Stream(fh);

        -- read the end of data
        unsigned_32'Read(s, eod);

        -- read the rest of the header
        for idx in 1 .. 511 loop
            unsigned_32'read(s, klen);
        end loop;

        pos := header_size;

        while pos < eod loop
            -- read the key length & data length from the stream
            unsigned_32'Read(s, klen);
            unsigned_32'Read(s, dlen);
            Ada.Text_IO.Put("+" & unsigned_32'Image(klen) & "," & unsigned_32'Image(dlen) & ":");

            -- read in klen characters from the stream and print the key
            for idx in 1 .. klen loop
                character'Read(s, tmp);
                Ada.Text_IO.Put(tmp);
            end loop;

            Ada.Text_IO.Put("->");

            -- read in dlen characters from the stream and print the value
            for idx in 1 .. dlen loop
                character'Read(s, tmp);
                Ada.Text_IO.Put(tmp);
            end loop;

            Ada.Text_IO.New_Line;

            pos := pos + 8 + klen + dlen;
        end loop;
        Ada.Text_IO.New_Line;
        Close (fh);
    end if;
end cadab_dump;
