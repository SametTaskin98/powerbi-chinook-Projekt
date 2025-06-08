-- Zählt alle Kunden – unabhängig davon, ob Felder wie Name oder E-Mail leer sind
SELECT 
	COUNT(*) AS anzahl_kunden
FROM 
	customer;

-- Zählt alle Kunden mit einer eingetragenen E-Mail-Adresse (falls Email notwendig für Validität)
SELECT 
	COUNT(email) AS kunden_mit_mail
FROM 
	customer;

-- Zählt nur Kunden, bei denen Vor- und Nachname eingetragen sind (ebenfalls Validitätsprüfung)
SELECT 
	COUNT(*)
FROM 
	customer
WHERE 
	first_name IS NOT NULL 
	AND last_name IS NOT NULL;
	
-- Gibt die 5 Länder mit dem höchsten Gesamtumsatz aus
SELECT 
	billing_country, 
	SUM(total) AS umsatz
FROM 
	invoice
GROUP BY 
	billing_country
ORDER BY 
	umsatz DESC
LIMIT 5;

-- Zeigt die Anzahl der Kunden pro Land (absteigend sortiert)
SELECT
	country,
	COUNT(*) AS anzahl_kunden
FROM
	customer
GROUP BY
	country
ORDER BY	
	anzahl_kunden DESC;

-- Zählt, aus wie vielen verschiedenen Ländern Kunden stammen
SELECT 
	COUNT(DISTINCT country) AS anzahl_laender
FROM	 
	customer
	