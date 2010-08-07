CREATE OR REPLACE FUNCTION html_open() RETURNS TEXT AS $$
BEGIN
    return '<html>';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION html_close() RETURNS TEXT AS $$
BEGIN
    return '</html>';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION body_open() RETURNS TEXT AS $$
BEGIN
    return '<body>';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION body_close() RETURNS TEXT AS $$
BEGIN
    return '</body>';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content_open() RETURNS TEXT AS $$
BEGIN
    return '<div id="content">';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content_close() RETURNS TEXT AS $$
BEGIN
    return '</div>';
END;
$$ LANGUAGE plpgsql;

