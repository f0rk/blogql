#!/bin/sh
psql -d $1 -f blocks.sql  
psql -d $1 -f content.sql  
psql -d $1 -f errors.sql      
psql -d $1 -f header.sql  
psql -d $1 -f head.sql    
psql -d $1 -f request.sql  
psql -d $1 -f tags.sql
