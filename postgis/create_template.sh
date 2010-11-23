#!/bin/sh

POSTGISCONTRIB_PATH=`pg_config --sharedir`/contrib
POSTGIS=$(find $POSTGISCONTRIB_PATH -name 'postgis.sql')
POSTGIS_COMMENTS=$(find $POSTGISCONTRIB_PATH -name 'postgis_comments.sql')
POSTGIS_SPATIAL=$(find $POSTGISCONTRIB_PATH -name 'spatial_ref_sys.sql')

if [ -z "$POSTGIS" ] || [ -z "$POSTGIS_SPATIAL" ]; then
    echo "  * Not found postgis contrib files."
    exit 1
fi

createdb -E UTF8 template_postgis # Create the template spatial database.
createlang -d template_postgis plpgsql # Adding PLPGSQL language support.

# psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"

echo "  * Install '$POSTGIS'."
psql -d template_postgis -f $POSTGIS

echo "  * Install '$POSTGIS_COMMENTS'."
psql -d template_postgis -f $POSTGIS_COMMENTS

echo "  * Install '$POSTGIS_SPATIAL'."
psql -d template_postgis -f $POSTGIS_SPATIAL

echo "  * Grant all."
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;" # Enabling users to alter spatial tables.
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
