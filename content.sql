CREATE OR REPLACE FUNCTION content_start(title TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN html_open() || head('index') || body_open() || header() || content_open();
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content_end() RETURNS TEXT AS $$
BEGIN
    RETURN content_close() || footer() || body_close() || html_close();
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content() RETURNS response_type AS $$
DECLARE
    ret response_type;
    post posts;
BEGIN
    --select the 5 most recent posts
    ret.status = 200;
    ret.content_type = 'content-type: text/html';

    ret.content = content_start('index');

    --select and loop over 5 most recent posts
    FOR post IN (SELECT * FROM posts ORDER BY datetime DESC LIMIT 5) LOOP
        ret.content = ret.content || formatted_title(post) || first_paragraph(post.content);
    END LOOP;

    ret.content = ret.content || content_end(); 

    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content(year INTEGER) RETURNS response_type AS $$
DECLARE
    ret response_type;
    post posts;
BEGIN
    --select all posts from the given year
    ret.status = 200;
    ret.content_type = 'content-type: text/html';

    ret.content = content_start('' || year) || '<table class="listings">';

    FOR post IN (SELECT * FROM posts WHERE posts.year = year ORDER BY datetime ASC) LOOP
        ret.content = ret.content || '<tr><td>' || formatted_datetime(post.datetime) || '</td><td><a href="' || url_post(post) || '">' || post.title || '</a></td></tr>';
    END LOOP;

    ret.content = ret.content || '</table>' || content_end();

    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content(year INTEGER, month INTEGER) RETURNS response_type AS $$
DECLARE
    ret response_type;
    post posts;
BEGIN
    --check for valid month
    IF month < 1 OR month > 12 THEN
        ret.status = 400;
        RETURN ret;
    END IF;

    --select all posts from the given month
    ret.status = 200;
    ret.content_type = 'content-type: text/html';

    ret.content = content_start('' || month) || '<table class="listings">';

    FOR post IN (SELECT * FROM posts WHERE posts.year = year AND posts.month = month ORDER BY datetime ASC) LOOP
        ret.content = ret.content || '<tr><td>' || formatted_datetime(post.datetime) || '</td><td><a href="' || url_post(post) || '">' || post.title || '</a></td></tr>';
    END LOOP;

    ret.content = ret.content || '</table>' || content_end();

    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION content(year INTEGER, month INTEGER, urltitle VARCHAR) RETURNS response_type AS $$
DECLARE
    ret response_type;
    post posts;
BEGIN
    --attempt to find the correct post
    SELECT * INTO post FROM posts WHERE posts.year = year AND posts.month = month AND posts.urltitle = urltitle LIMIT 1;

    --return 404 if not found
    IF NOT FOUND THEN
        ret.status = 404;
        RETURN ret;
    END IF;

    ret.status = 200;
    ret.content_type = 'content-type: text/html';

    ret.content = content_start(post.title) || formatted_title(post) || post.content || content_end();

    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION formatted_title(post posts) RETURNS TEXT AS $$
BEGIN
    RETURN '<h1 class="title"><a href="' || url_post(post) || '">' || post.title || '</a></h1>' || '<h2 class="author">posted by ' || post.author || ' at ' || formatted_datetime(post.datetime) || '</h2>';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION first_paragraph(content TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN substring(content FROM 1 FOR position('</p>' IN content) + 3);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION formatted_datetime(datetime TIMESTAMP) RETURNS TEXT AS $$
BEGIN
    RETURN to_char(datetime, 'YYYY-Mon-DD HH24:MI');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION url_post(post posts) RETURNS TEXT AS $$
BEGIN
    RETURN url_base() || post.year || '/' || post.month || '/' || post.urltitle;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION url_base() RETURNS TEXT AS $$
BEGIN
    RETURN '/';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION month_from_num(month INTEGER) RETURNS TEXT AS $$
BEGIN
    IF month = 1 THEN
        RETURN 'january';
    ELSIF month = 2 THEN
        RETURN 'february';
    ELSIF month = 3 THEN
        RETURN 'march';
    ELSIF month = 4 THEN
        RETURN 'april';
    ELSIF month = 5 THEN
        RETURN 'may';
    ELSIF month = 6 THEN
        RETURN 'june';
    ELSIF month = 7 THEN
        RETURN 'july';
    ELSIF month = 8 THEN
        RETURN 'august';
    ELSIF month = 9 THEN
        RETURN 'september';
    ELSIF month = 10 THEN
        RETURN 'october';
    ELSIF month = 11 THEN
        RETURN 'november';
    ELSIF month = 12 THEN
        RETURN 'december';
    ELSE 
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;
