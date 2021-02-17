using Markdown;



public class MarkdownReader {  
    const int HEADER_LIMIT = 10;
    const int CHAPO_LIMIT = 5;
    
    private string get_html_content(StringBuilder builder) {
        // TODO: Investigate on these flags.   
        Document mk = new Document.from_string (builder.data, DocumentFlags.DLEXTRA | DocumentFlags.FENCEDCODE | DocumentFlags.GITHUBTAGS);
        mk.compile (DocumentFlags.DLEXTRA | DocumentFlags.FENCEDCODE | DocumentFlags.GITHUBTAGS);

        string content;
        mk.document (out content);

        return content;
    }

    private PlxDocument? parse (FileStream stream) {
        bool chapo_processed = false;
        int content_lines = 0;
        int line_counter = 0;
        
        StringBuilder builder = new StringBuilder ();
        var plx_doc = new PlxDocument ();
        
        string line;
        while ((line = stream.read_line ()) != null) {
            if (line_counter < HEADER_LIMIT && line[0] == '%') {
                line_counter++;
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
                        //print ("Tags: %s\n", token[1]);
                        plx_doc.tags = token[1];
                        break;
                    case "%filename":
                        print ("Filename: %s\n", token[1]);
                        plx_doc.filename = token[1];
                        break;
                    default:
                        warning ("*** %s *** %s\n", token[0], token[1]);
                        break;
                }
            }
            else {
                builder.append (line);
                builder.append_c ('\n');

                content_lines++;

                // Let's get the first CHAPO_LIMIT lines of text. More line if not empty.
                if (chapo_processed == false && content_lines > CHAPO_LIMIT && line.length == 0) {
                    plx_doc.chapo = get_html_content (builder);
                    chapo_processed = true;
                }
            }
        }

        plx_doc.content = get_html_content (builder);
        return plx_doc;
    }

    public PlxDocument? open (string path) {
        FileStream infile = FileStream.open (path, "r");
        assert (infile != null);

        return parse (infile);
    }
}
