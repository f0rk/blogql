CREATE OR REPLACE FUNCTION request(path VARCHAR) RETURNS TEXT AS $$
DECLARE
    header TEXT;
    response response_type;

    path_query TEXT[];
    path_parts TEXT[];
    parts_count INTEGER;

    year_text TEXT;
    month_text TEXT;
BEGIN
    response.status = 400;

    --split into path and query
    path_query := regexp_split_to_array(path, E'\\?');

    --split path components
    path_parts := regexp_split_to_array(path_query[1], '/');

    --count number of path components
    parts_count := array_upper(path_parts, 1);
    IF (parts_count = 2) THEN --2 is / or /year
        IF (path_parts[2] = '') THEN
            response := content();
        ELSE
            IF (is_integer(path_parts[2])) THEN
                response := content(to_integer(path_parts[2]));
            END IF;
        END IF;
    ELSIF (parts_count = 3) THEN --1 is /year/ or /year/month
        IF (path_parts[3] = '') THEN
            IF (is_integer(path_parts[2])) THEN
                response := content(to_integer(path_parts[2]));
            END IF;
        ELSE
            IF ((is_integer(path_parts[2])) AND (is_integer(path_parts[3]))) THEN
                response := content(to_integer(path_parts[2]), to_integer(path_parts[3]));
            END IF;
        END IF;
    ELSIF (parts_count = 4) THEN --4 is /year/month/ or /year/month/title
        IF (path_parts[4] = '') THEN
            IF ((is_integer(path_parts[2])) AND (is_integer(path_parts[3]))) THEN
                response := content(to_integer(path_parts[2]), to_integer(path_parts[3]));
            END IF;
        ELSE
            IF ((is_integer(path_parts[2])) AND (is_integer(path_parts[3]))) THEN
                response := content(to_integer(path_parts[2]),to_integer(path_parts[3]), path_parts[4]);
            END IF;
        END IF;
    ELSIF (parts_count = 5) THEN --5 is /year/month/title/
        IF ((is_integer(path_parts[2])) AND (is_integer(path_parts[3]))) THEN
            response := content(to_integer(path_parts[2]), to_integer(path_parts[3]), path_parts[4]);
        END IF;
    END IF;

    IF response.status = 404 THEN 
        response := not_found();
    ELSIF response.status = 400 THEN
        response := bad_request();
    END IF;

    RETURN 'HTTP/1.0 ' || response.status || E' \n' || response.content_type || E'\n\n' || response.content;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_integer(str TEXT) RETURNS BOOLEAN AS $$
BEGIN
    RETURN substring(str from E'^\\d+$') IS DISTINCT FROM NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION to_integer(str TEXT) RETURNS INTEGER AS $$
BEGIN
    RETURN CAST(str AS INTEGER);
END;
$$ LANGUAGE plpgsql;
