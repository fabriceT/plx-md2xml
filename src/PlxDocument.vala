public class PlxDocument {
    public string title {
        get; set; default = "";
    }

    public string filename {
        get; set; default = "article.xml";
    }

    public string chapo {
        get; set;
    }

    public string content {
        get; set;
    }

    public string tags {
        get; set; default = "";
    }

    public string description {
        get; set; default = "";
    }

    public string keywords {
        get; set; default = "";
    }

    public string thumbnail {
        get; set; default = "";
    }

    public string thumbnail_title {
        get; set; default = "";
    }

    public string thumbnail_text {
        get; set; default = "";
    }

    public string creation_date {
        get; set; default = get_date (null);
    }

    static string get_date (string? str) {
        if (str != null) {
            return str;
        }

        var date = new DateTime.now_local ();
        return date.format ("%Y%m%d%H%M%S");
    }

    public int write () {
        if (content == null) {
            return 1;
        }

        var outfile = FileStream.open (filename, "w");
        assert (outfile != null);

        message ("Write document to: %s", filename);

        outfile.puts ("<?xml version='1.0' encoding='UTF-8'?>\n");
        outfile.puts ("<document>\n");
        outfile.printf ("  <title><![CDATA[%s]]></title>\n", title);
        outfile.printf ("  <title_htmltag><![CDATA[%s]]></title_htmltag>\n", title);
        outfile.printf ("  <tags><![CDATA[%s]]></tags>\n", tags);
        outfile.printf ("  <chapo><![CDATA[%s]]></chapo>\n", chapo);
        outfile.printf ("  <content><![CDATA[%s]]></content>\n", content);
        outfile.printf ("  <date_update><![CDATA[%s]]></date_update>\n", get_date (null));
        outfile.printf ("  <date_creation><![CDATA[%s]]></date_creation>\n", get_date (creation_date));
        outfile.printf ("  <meta_keywords><![CDATA[%s]]></meta_keywords>\n", keywords);
        outfile.printf ("  <meta_description><![CDATA[%s]]></meta_description>\n", description);
        outfile.puts ("  <allow_com><![CDATA[1]]></allow_com>\n");
        outfile.puts ("  <template><![CDATA[article.php]]></template>\n");
        outfile.printf ("  <thumbnail><![CDATA[%s]]></thumbnail>\n", thumbnail);
        outfile.printf ("  <thumbnail_title><![CDATA[%s]]></thumbnail_title>\n", thumbnail_title);
        outfile.printf ("  <thumbnail_alt><![CDATA[%s]]></thumbnail_alt>\n", thumbnail_text);
        outfile.puts ("</document>");

        return 0;
    }
}
