# Umsatzanalyse mit Power BI – Chinook Datenbank

## Projektübersicht

Das Projekt dient ausschließlich zu Übungszwecken und wurde am 07.06.2025 neu gestartet. Fragestellungen und Visualisierungen werden im Laufe der Zeit erweitert.

In diesem Projekt werden Rechnungs- und Kundendaten aus der Chinook-Probedatenbank analysiert. 
Ziel dieses Projekts ist es, typische Aufgaben eines Business Intelligence Analysts bzw. Business Analysts umzusetzen, darunter die Analyse der Umsatzentwicklung über die Zeit sowie die Identifikation der umsatzstärksten Märkte.
Die Daten stammen aus einer PostgreSQL-Datenbank (ursprünglich aus der Open Source chinook-database)) und wurden über Power BI ausgewertet und visualisiert.


---

## Use Cases & Fragestellungen

1. **Wie entwickeln sich die Umsätze über die Monate und Jahre hinweg?**
2. **Welche Länder generieren den höchsten Umsatz (Top 5)?**
3. **Welche Sales-Mitarbeiter haben den meisten Umsatz betreut?** + **Welcher Mitarbeiter verkauft welche Genres am erfolgreichsten?**
4. **siehe unter Erweiterungsideen**

---

## Umsetzung & Visualisierung

### 1. Umsatzentwicklung über Zeit (Small Multiples)

- Erstellung einer neuen Tabelle MonatsUmsatz
- Erstellung einer neuen Datumsspalte `JahrMonat` im Datumsformat 
- Aggregation des Umsatzes pro Monat
- Erstellung einer `Jahr`-Spalte zur Gruppierung
- Visualisierung: Liniendiagramm mit Small Multiples (1 Diagramm pro Jahr)

Diagrammaufbau:
- X-Achse: `JahrMonat` von Monatsumsatz
- Y-Achse: `Umsatz` von Monatsumsatz
- Small Multiple: Jahr

![Umsatzsvergleich per Small Multiples](./screenshots/small_multiples_umsatz_pro_monat_und_jahr.PNG)

---

### 2. Top 5 Länder nach Umsatz

- Gruppierung der Rechnungsbeträge nach `billing_Country`
- Aggregation der Summe von `total`
- Sortierung und Filterung auf die 5 umsatzstärksten Länder
- Visualisierung: gestapeltes Balkendiagramm

Diagrammaufbau:
- X-Achse: `total` von public invoice (Gesamtsumme genannt)
- Y-Achse: `billingCountry` von public invoice (Rechnungen_Länder genannt)
- Filter: TopN 5 Länder nach Umsatz

![Top 5 Länder](./screenshots/top5laender.PNG)

---

### 3. Umsatz pro Mitarbeiter & Genre

- Prüfung ob alle notwendigen JOIN Verbindungen existieren (Modellansicht)
- SUMX erstellt zur Berechnung von (Preis * Anzahl) um Mitarbeiter Verkäufe pro Genre zu erhalten
- Diagramm kann für 3.1 und 3.2 genutzt werden
- Visualisierung: Balkendiagramm (gruppiert)

Diagrammaufbau:
- X-Achse: `Umsatz` von public invoice_line 
- Y-Achse: `name` von public genre (Genre genannt)
- Legende: `last_name` von public employee (Mitarbeiter_Name genannt)
- Filter: TopN 5 Genres nach Umsatz

![Top Mitarbeiter Umsätze für Top Genres](./mitarbeiter_umsatz_top5_genres.PNG)

---

## DAX-Funktionen

```dax

-- 1. Neue Tabelle mit nur 2 Spalten Land und Gesamtumsatz erstellen
LänderUmsatz = SUMMARIZE('public invoice', 'public invoice'[billing_country],"Umsatz", SUM('public invoice'[total]))

-- 2. JahrMonat aus Rechnungsdatum erzeugen
JahrMonat = DATE(YEAR('public invoice'[invoice_date]), MONTH('public invoice'[invoice_date]), 1)

-- 3.. Aggregation: Umsatz pro Monat
MonatsUmsatz = 
SUMMARIZE(
    'public invoice', 
    'public invoice'[JahrMonat],
    "Umsatz", SUM('public invoice'[total])
)

-- 4. Neue Jahr-Spalte für Gruppierung hinzufügen
Jahr = YEAR('MonatsUmsatz'[JahrMonat])

-- 5. Umsatz Berechnung mit SUMX (Preis * Anzahl) für Nutzung für Mitarbeiter Verkäufe und Verbindung mit Genre
Umsatz = SUMX('public invoice_line', 'public invoice_line'[unit_price] * 'public invoice_line'[quantity]) 
```

## Datenquelle

- Quelle: Chinook PostgreSQL Open Source Probedatenbank
- Tools:
  - PostgreSQL (pgAdmin 4)
  - Power BI + DAX
- Verwendete Tabellen:
  - public invoice
  - MonatsUmsatz
  - LänderUmsatz
- Erste SQL-Auswertungen zur Datenvalidierung und Exploration:
  - Dabei wurden einfache Aggregationen mittels COUNT, GROUP BY und DISTINCT durchgeführt, um z. B. die Kundenzahl, Länderverteilung und Umsatzverteilung zu prüfen.
  - siehe  [erste_abfragen.sql](./sql/countabfragen_mit_groupby_distinct.sql)

## Learnings

- Nutzung von PostgreSQL und Power BI
- Aggregationen, Gruppierungen und DAX-Verarbeitung
- JOIN Verbindungen über Modellansicht per Power BI
- Visualisierung zeitlicher Entwicklungen
- Filter- und Sortierlogiken für Business-Analysen
- Erstellung kleiner Hilfstabellen zur Auswertung

## Erweiterungsideen

- Top-Produkte je Genre
    - „Was sind die meistverkauften Tracks im Genre Pop?“
- Umsatzanalyse nach Künstler, Genre oder Album
- Datenbank selber erweitern mit simulierten Rückgabequoten, um folgende Fragen/Aussagen zu untersuchen:
    - "Wie hoch ist die Rückgabequote pro Produkt?" 
    - "Produkt X wird zwar oft gekauft, aber mit 20 % Rückgabequote."
    - "Wenn der Kunde Artikel A kauft, hat er eine 75 %-Wahrscheinlichkeit, Artikel B auch zu kaufen."
    -> Cross Selling: "Käufer von Jazz kaufen oft auch Blues. Wie können wir das nutzen?“  
- Kundenwertanalyse
    - „Welche Kunden haben den höchsten Gesamtumsatz generiert?“ -> Clustering nach Ländern
- Geografische Analyse
    - Kartenvisualisierung mit Power BI (bubbles/ heatmap) -> Woher kommen unsere Kunden überhaupt? 
- Durchschnittlicher Warenkorbwert pro Kunde oder Land
- Wachstum zum Vormonat/ Quartal


## Autor

- **Name:** [Samet Taskin]
- **Studium:** Wirtschaftsinformatik (B.Sc.)
- **Karriereziel:** Einstieg in den Bereich Business Intelligence und Datenanalyse
- **Technologien:** Power BI, DAX, PostgreSQL
