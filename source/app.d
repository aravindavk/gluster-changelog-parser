import std.stdio : writeln, writefln, write, writef, File;
import std.algorithm : splitter, startsWith;
import std.conv : to;
import std.string : strip, split;

auto GF_FOP = [
    "NULL", "STAT", "READLINK", "MKNOD", "MKDIR", "UNLINK", "RMDIR", "SYMLINK",
    "RENAME", "LINK", "TRUNCATE", "OPEN", "READ", "WRITE", "STATFS", "FLUSH", "FSYNC", "SETXATTR",
    "GETXATTR", "REMOVEXATTR", "OPENDIR", "FSYNCDIR", "ACCESS", "CREATE", "FTRUNCATE", "FSTAT", "LK", "LOOKUP",
    "READDIR", "INODELK", "FINODELK", "ENTRYLK", "FENTRYLK", "XATTROP",
    "FXATTROP", "FSETXATTR", "FGETXATTR", "RCHECKSUM",
    "SETATTR", "FSETATTR", "READDIRP", "GETSPEC", "FORGET", "RELEASE",
    "RELEASEDIR", "FREMOVEXATTR", "FALLOCATE", "DISCARD", "ZEROFILL"
];

void print_entry_create_mknod_mkdir(T)(string ver, ref T data)
{
    // Mode
    writef("%s ", data.front());
    data.popFront();
    // UID
    writef("%s ", data.front());
    data.popFront();
    // GID
    writef("%s ", data.front());
    data.popFront();
    // PGFID/BASENAME
    writefln("%s", data.front());
    data.popFront();
}

void print_entry_rename(T)(string ver, ref T data)
{
    // OLD NAME: PGFID/BASENAME
    writef("%s", data.front());
    data.popFront();

    // NEW NAME: PGFID/BASENAME
    writefln("%s", data.front());
    data.popFront();
}

void print_entry_unlink_rmdir(T)(string ver, ref T data)
{
    // PGFID/BASENAME
    writef("%s", data.front());
    data.popFront();

    if (ver == "v1.2")
    {
        // If empty, that means deleted path not recorded
        // so one extra pop(Extra seperator)
        if (data.front() == "")
        {
            data.popFront();
            writeln();
        }
        else
            writefln(" %s", data.front());

        data.popFront();
    }
    else
        writeln();
}

void print_entry_symlink(T)(string ver, ref T data)
{
    // PGFID/BASENAME
    writefln("%s", data.front());
    data.popFront();
}

void print_entry_link(T)(string ver, ref T data)
{
    // PGFID/BASENAME
    writefln("%s", data.front());
    data.popFront();
}

int main(string[] args)
{
    if (args.length != 2)
    {
        writeln("Changelog file is required\n");
        writeln("USAGE: gluster-changelog-parser <changelog-file-path>");
        return 1;
    }

    auto file = File(args[1], "r");
    string meta_line = file.readln();
    // GlusterFS Changelog | version: v1.1 | encoding : 2
    string ver = meta_line.split("|")[1].split(": ")[$ - 1];
    ver = ver.strip();
    string content = file.readln();
    auto data = splitter(content, "\x00");

    while (!data.empty)
    {
        auto elem = data.front();
        data.popFront();

        if (elem == "")
            continue;

        auto ty = elem[0];
        auto gfid = elem[1 .. $];

        if (ty == 'E')
        {
            auto entry_type = GF_FOP[to!int(data.front())];
            data.popFront();

            // E <GFID> <FOP_TYPE>
            writef("E %s %7s ", gfid, entry_type);

            switch (entry_type)
            {
            case "CREATE":
                print_entry_create_mknod_mkdir(ver, data);
                break;
            case "MKDIR":
                print_entry_create_mknod_mkdir(ver, data);
                break;
            case "MKNOD":
                print_entry_create_mknod_mkdir(ver, data);
                break;
            case "RENAME":
                print_entry_rename(ver, data);
                break;
            case "UNLINK":
                print_entry_unlink_rmdir(ver, data);
                break;
            case "RMDIR":
                print_entry_unlink_rmdir(ver, data);
                break;
            case "SYMLINK":
                print_entry_symlink(ver, data);
                break;
            case "LINK":
                print_entry_link(ver, data);
                break;
            default:
                break;
            }
        }
        else if (ty == 'D')
            writefln("D %s ", gfid);
        else if (ty == 'M')
        {
            auto entry_type = GF_FOP[to!int(data.front())];
            data.popFront();
            writefln("M %s %s", gfid, entry_type);
        }
    }
    return 0;
}
