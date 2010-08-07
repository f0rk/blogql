CREATE OR REPLACE FUNCTION head(title TEXT) RETURNS TEXT AS $$
BEGIN
    return '<head><title>' || title || '</title></head>';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION header() RETURNS TEXT AS $$
BEGIN
    return '';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION footer() RETURNS TEXT AS $$
BEGIN
    return '';
END;
$$ LANGUAGE plpgsql;
