using Markdown;



public class MarkdownReader {  
    const int HEADER_LIMIT = 10;
    
    private PlxDocument? parse (FileStream stream) {
        StringBuilder builder = new StringBuilder ();
        var plx_doc = new PlxDocument ();

        int counter = 0;
        string line;
        while ((line = stream.read_line ()) != null) {
            if (line[0] == '%' & counter < HEADER_LIMIT) {
                counter++;
                var token = line.split (" ", 2);
                switch (token[0].down ()) {
                    case "%title":
                        print ("Title: %s\n", token[1]);
                        plx_doc.title = token[1];
                        break;
                    case "%description":
                        print ("Description: %s\n", token[1]);
                        plx_doc.description = token[1];
                        break;
                    case "%keywords":
                        print ("Keywords: %s\n", token[1]);
                        plx_doc.keywords = token[1];
                        break;
                    case "%date":
                        print ("Date: %s\n", token[1]);
                        plx_doc.creation_date = token[1];
                        break;
                    case "%tags":
                        print ("Tags: %s\n", token[1]);
                        plx_doc.tags = token[1];
                        break;
                    case "%filename":
                        print ("Tags: %s\n", token[1]);
                        plx_doc.tags = token[1];
                        break;
                    default:
                        warning ("*** %s *** %s\n", token[0], token[1]);
                        break;
                }
            }
            else {
                builder.append (line);
                builder.append_c ('\n');
            }
        }

        Document mk = new Document.from_string (builder.data, DocumentFlags.DLEXTRA | DocumentFlags.FENCEDCODE | DocumentFlags.GITHUBTAGS);
        mk.compile (DocumentFlags.DLEXTRA | DocumentFlags.FENCEDCODE | DocumentFlags.GITHUBTAGS);

        string content;
        int val = mk.document (out content);
        if (val > 0) {
            plx_doc.content = content;
        }
        return plx_doc;
    }

    public PlxDocument? open (string path) {
        FileStream infile = FileStream.open (path, "r");
        assert (infile != null);

        return parse (infile);
    }
}
