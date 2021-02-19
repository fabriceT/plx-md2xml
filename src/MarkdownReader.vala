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

    PlxDocument plx_doc = new PlxDocument ();

    private string get_html_content (StringBuilder builder) {
        // TODO: Investigate on these flags.   
        Document mk = new Document.from_string (
            builder.data,
            DocumentFlags.DLEXTRA |
            DocumentFlags.FENCEDCODE |
            DocumentFlags.GITHUBTAGS
        );

        mk.compile (
            DocumentFlags.DLEXTRA |
            DocumentFlags.FENCEDCODE |
            DocumentFlags.GITHUBTAGS
        );

        string content;
        mk.document (out content);

        return content;
    }

    private void parse_header (string header_line) {
        var token = header_line.strip ().split (" ", 2);

        if (token[1] == null) {
            return;
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

    private PlxDocument? parse (FileStream stream) {
        ParserStatus parser_status = NO_HEADER;
        int content_lines = 0;

        StringBuilder builder = new StringBuilder ();

        string line;
        while ((line = stream.read_line ()) != null) {
            switch (parser_status) {
                case NO_HEADER:
                    if (line.strip () == HEADER_MARKER) {
                        print ("=== Header starts ===\n");
                        parser_status = HEADER;
                    }
                    break;

                case HEADER:
                    if (line.strip () == HEADER_MARKER ) {
                        print ("=== Header ends ===\n");
                        parser_status = CHAPO;
                    } else {
                        parse_header (line);
                    }
                    break;

                case CHAPO:
                    builder.append (line);
                    builder.append_c ('\n');
                    content_lines++;

                    if (content_lines > CHAPO_LIMIT && line.length == 0) {
                        plx_doc.chapo = get_html_content (builder);
                        parser_status = CONTENT;
                        print ("=== Chapô ends ===\n");
                    }
                    break;

                case CONTENT:
                    builder.append (line);
                    builder.append_c ('\n');
                    break;
            }
        }

        if (parser_status == HEADER || parser_status == NO_HEADER) {
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
