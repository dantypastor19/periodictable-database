#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL=(psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align)
ELEMENT=$("${PSQL[@]}" --set=search="$1" <<'SQL'
SELECT e.atomic_number,
     e.symbol,
     e.name,
     t.type,
     p.atomic_mass,
     p.melting_point_celsius,
     p.boiling_point_celsius
FROM elements e
JOIN properties p USING (atomic_number)
JOIN types t USING (type_id)
WHERE e.atomic_number::text = :'search'
  OR e.symbol = :'search'
  OR e.name = :'search';
SQL
)

if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number symbol name type mass melting_point boiling_point <<< "$ELEMENT"
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."