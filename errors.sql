CREATE OR REPLACE FUNCTION not_found() RETURNS response_type AS $$
DECLARE
    ret response_type;
BEGIN
    ret.status = 404;
    ret.content_type = 'content-type: text/html';
    ret.content = '<html><head><title>not found</title></head><body><div>not found</div></body></html>';
    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bad_request() RETURNS response_type AS $$
DECLARE
    ret response_type;
BEGIN
    ret.status = 400;
    ret.content_type = 'content-type: text/html';
    ret.content = '<html><head><title>bad request</title></head><body><div>bad request</div></body></html>';
    RETURN ret;
END;
$$ LANGUAGE plpgsql;
