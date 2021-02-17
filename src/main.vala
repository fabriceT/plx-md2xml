using GLib;

public static int main (string[] args) {
    if (args.length == 1) {
        print ("Usage: plx-md2xml <file.md>\n");
        return 1;
    }
    var reader = new MarkdownReader ();
    PlxDocument document = reader.open (args[1]);

    return document.write ();
}
