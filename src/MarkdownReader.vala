using Markdown;



public class MarkdownReader {  
    const int HEADER_LIMIT = 10;
    const int CHAPO_LIMIT = 5;
    const string HEADER_MARKER = "---";
    
    enum ParserStatus {
        NO_HEADER,
        HEADER,
        CHAPO,
        CONTENT
    }

    private string get_html_content(StringBuilder builder) {
        // TODO: Investigate on these flags.   
        Document mk = new Document.from_string (builder.data, DocumentFlags.DLEXTRA | DocumentFlags.FENCEDCODE | DocumentFlags.GITHUBTAGS);
        mk.compile (DocumentFlags.DLEXTRA | DocumentFlags.FENCEDCODE | DocumentFlags.GITHUBTAGS);

        string content;
        mk.document (out content);

        return content;
    }

    private PlxDocument? parse (FileStream stream) {
        ParserStatus parser_status = ParserStatus.NO_HEADER;
        int content_lines = 0;
        
        StringBuilder builder = new StringBuilder ();
        var plx_doc = new PlxDocument ();
        
        string line;
        while ((line = stream.read_line ()) != null) {
            if (parser_status == ParserStatus.NO_HEADER && line.strip() == HEADER_MARKER ) {
                print("=== Header starts ===\n");
                parser_status = ParserStatus.HEADER;
                continue;
            }

            if (parser_status == ParserStatus.HEADER && line.strip() == HEADER_MARKER ) {
                print("=== Header ends ===\n");
                parser_status = ParserStatus.CHAPO;
                continue;
            }

            if (parser_status == ParserStatus.HEADER) {
                var token = line.strip().split (" ", 2);

                if (token[1] == null) {
                    continue;
                }

                switch (token[0].down ()) {
                    case "title:":
                        print ("* Title: %s\n", token[1]);
                        plx_doc.title = token[1];
                        break;
                    case "description:":
                        print ("* Description: %s\n", token[1]);
                        plx_doc.description = token[1];
                        break;
                    case "keywords:":
                        print ("* Keywords: %s\n", token[1]);
                        plx_doc.keywords = token[1];
                        break;
                    case "date:":
                        print ("* Date: %s\n", token[1]);
                        plx_doc.creation_date = token[1];
                        break;
                    case "tags:":
                        print ("* Tags: %s\n", token[1]);
                        plx_doc.tags = token[1];
                        break;
                    case "filename:":
                        print ("* Filename: %s\n", token[1]);
                        plx_doc.filename = token[1];
                        break;
                    case "thumbnail:":
                        print ("* Thumbnail: %s\n", token[1]);
                        plx_doc.thumbnail = token[1];
                        break;
                    case "thumbtitle:":
                        print ("* Thumb. Title: %s\n", token[1]);
                        plx_doc.thumbnail_title = token[1];
                        break;
                    case "thumbtext:":
                        print ("* Thumb. Text: %s\n", token[1]);
                        plx_doc.thumbnail_text = token[1];
                        break;
                    default:
                        warning (" * Unknow token: %s", token[0]);
                        break;
                }
            }
            else {
                builder.append (line);
                builder.append_c ('\n');

                content_lines++;

                // Let's get `CHAPO_LIMIT` lines of text. Add more lines if it's not empty.
                if (parser_status == ParserStatus.CHAPO && content_lines > CHAPO_LIMIT && line.length == 0) {
                    plx_doc.chapo = get_html_content (builder);
                    parser_status = ParserStatus.CONTENT;
                    print("=== Chapô ends ===\n");
                }
            }
        }

        //
        if (parser_status == ParserStatus.HEADER || parser_status == ParserStatus.NO_HEADER) {
            error ("Header section is missing or not closed\n");
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
