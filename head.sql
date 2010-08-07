CREATE OR REPLACE FUNCTION head(title TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN '<head><title>' || title || '</title></head>';
END;
$$ LANGUAGE plpgsql;
