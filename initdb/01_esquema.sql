CREATE TABLE albergues (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    concello VARCHAR(100) NOT NULL,
    camiño VARCHAR(150) NOT NULL,
    numero_plazas INTEGER NOT NULL CHECK (numero_plazas > 0),
    precio_por_noche NUMERIC(8, 2) NOT NULL CHECK (precio_por_noche >= 0)
);