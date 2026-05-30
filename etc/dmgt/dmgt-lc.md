---
kind: Note
status: draft
title: noEA
subtitle: Datenmanagement - Lebenszyklus
aliases:
  - noEA Datenmanagement - Lebenszyklus
author:
  - nemron
version: "0.1"
tags:
dateCreated: 2026-02-02T21:47:46.000+01:00
dateModified: 2026-02-02T22:01:48.409+01:00
---

Im Folgenden die **Phasen eines Datenlebenszyklus**.

# 1. Erzeugung & Erfassung (Capture / Creation)

***Beschreibung***

Hier entstehen Daten in operativen Systemen, Sensoren, Apps, Websites oder externen Quellen (Social Media, Partner, IoT-Geräte usw.).

***Typische Aufgaben***

- Anbinden von Datenquellen (APIs, Streaming, Batch-Exporte).
- Sicherstellen, dass relevante Daten überhaupt erfasst werden.

***Herausforderungen***

- Datenqualität beginnt hier: Wenn schon in den Quellsystemen falsche, unvollständige oder widersprüchliche Daten entstehen, wird es später schwierig, dies auszugleichen.
- Silos in Fachbereichen: Manche Datenquellen liegen in Altsystemen, andere in Cloud-Apps. Es fehlt oft eine Gesamtübersicht.

# 2. Integration (Ingest / Load)

***Beschreibung***

Die Rohdaten gelangen in eine zentrale Umgebung: Data Lake, Lake House oder klassisches DWH. Es wird entschieden, ob Batch-, Streaming- oder Echtzeitanbindungen benötigt werden.

***Typische Aufgaben***

- ETL/ELT-Prozesse (Extraktion, Laden, ggf. erste Transformationen).
- Streaming-Jobs (z. B. Kafka, Event Hubs).

***Herausforderungen***

- Tooling-Vielfalt: Man braucht in großen Umgebungen häufig mehrere Werkzeuge (ETL-Tools, Orchestrierungs-Tools, Skripte etc.).
- Organisatorische Abstimmung: In Data-Mesh-Setups sollen Domänen eigenverantwortlich Daten "veröffentlichen". Aber wie garantiert man, dass sie das zuverlässig und konsistent tun?

# 3. Speicherung & Verwaltung (Storage / Management)

***Beschreibung***

Die Daten werden in einem zentralen oder dezentralen Speicher abgelegt – etwa in S3/ADLS/GCS (Data Lake), Delta Lake (Lakehouse) oder relationalen DB-Systemen (DWH).

***Typische Aufgaben***

- Festlegen von Formaten (z. B. Parquet, Delta).
- Einrichten von Strukturen (z. B. Bronze/Silver/Gold-Layer, Star-Schema im DWH).
- Verwaltung von Metadaten (Katalog, Schema, Datenkatalog, Unity Catalog).

***Herausforderungen***

- Governance: Wo liegen welche Daten? Wer darf zugreifen? Wie werden Metadaten gepflegt?
- Konsistente Datenformate: Selbst mit Delta Lake können Versionierung und Schema-Evolution komplex werden.
- Data Mesh verschiebt die Verantwortung in die Domänen. Das kann zu Wildwuchs führen, wenn nicht zentrale Richtlinien definiert sind.

# 4. Aufbereitung & Veredelung (Transformation / Preparation)

***Beschreibung***

Die Rohdaten werden bereinigt, harmonisiert, aggregiert und gegebenenfalls angereichert (Data Enrichment), um sie für Analytics, Reporting oder KI nutzbar zu machen.

***Typische Aufgaben***

- Datenbereinigung (Fehler, Dupletten, inkonsistente Werte).
- Transformation in nutzerfreundliche Strukturen (Star-/Snowflake-Schema, dimensionale Modelle, Data Products).
- Ablegen in kuratierten Zonen (z. B. Silver-/Gold-Tables in Databricks).

***Herausforderungen***

- Data Quality: Trotz definierter Transformationsregeln muss man ständig überwachen, ob die Daten den Qualitätsansprüchen genügen.
- Performance: Transformationsprozesse können sehr rechenintensiv sein. Databricks (Spark) hilft dabei, aber fehlerhafte oder ineffiziente Jobs können die Kosten explodieren lassen.
- Data Mesh: In einem Mesh-Ansatz sollen Domänen ihre eigenen Aufbereitungs-Pipelines bauen. Das erfordert Know-how, Governance und Standardisierung (z. B. Namenskonventionen, Qualitätstests).

# 5. Bereitstellung & Zugriff (Serving / Access)

***Beschreibung***

Aufbereitete Daten werden für unterschiedliche Use Cases verfügbar gemacht: BI-Reports, Data Science, APIs, Data Products in Mesh-Domänen etc.

***Typische Aufgaben***

- Aufbau von Schnittstellen (SQL-Endpunkte, REST-APIs, Data-Sharing).
- Schaffung eines Self-Service-BI-Zugangs (z. B. Databricks SQL, Power BI, Tableau).
- Konfiguration von Berechtigungen und Rollen (z. B. Unity Catalog für Tabellensicht und Spaltenberechtigungen).

***Herausforderungen***

- Single Source of Truth: Wie verhindert man, dass jede Domäne wieder eigene Kopien und Definitionen hat?
- Zugriffskontrolle: Gerade mit Data Mesh kann es schwierig werden, einheitliche und sichere Zugriffsmodelle über viele Domänen hinweg umzusetzen.
- Tools vs. Plattformen: Trotz Databricks und Lakehouse-Konzepten nutzen Unternehmen weiterhin unterschiedliche Tools für Analyse und Reporting. Die nahtlose Integration ist nicht immer trivial.

# 6. Analyse & Auswertung (Analytics / Data Science / BI)

***Beschreibung***

Hier finden explorative Analysen, Dashboarding, Reporting und maschinelles Lernen statt. Data Scientists, Data Analysts und Business-User arbeiten mit den aufbereiteten Daten.

***Typische Aufgaben***

- Datenanalyse (Descriptive, Diagnostic, Predictive, Prescriptive).
- ML-/AI-Modellierung (Feature Engineering, Training, Evaluierung).
- Reporting/Dashboarding für das Management, Fachabteilungen oder Kunden.

***Herausforderungen***

- Team-übergreifende Zusammenarbeit: Data Scientists benötigen oft andere Tools als BI-Analysten. Databricks Notebooks sind gut für Data Science, aber Fachanwender brauchen ggf. simpleres Self-Service-BI.
- Automatisierung: ML-Pipelines (ModelOps) und kontinuierliche Integration (CI/CD) für Datenanalyse sind nach wie vor für viele Unternehmen Neuland.
- Data Mesh kann den Austausch relevanter Daten zwischen Domänen erleichtern – wenn man sich an Standards und Verantwortlichkeiten hält. Ohne klare Spielregeln führt es zu Insellösungen.

# 7. Operationalisierung & Modell-Einsatz (Operationalize / Model Serving)

***Beschreibung***

Die entwickelten Modelle und Erkenntnisse sollen in den Produktionsbetrieb überführt werden: z. B. Echtzeit-Scoring, Empfehlungen in Web-Apps, automatisierte Entscheidungen.

***Typische Aufgaben***

- MLflow oder ähnliche Tools zur Modellverwaltung (Versionierung, Modellbewertung, Deployment).
- Aufbau von APIs, Integrationen in bestehende Applikationen.

***Herausforderungen***

- Stabile ML-Pipelines: Auch Databricks MLflow oder andere MLOps-Tools sind kein Selbstläufer. Es braucht gut durchdachte Prozesse für Monitoring, Retraining, Rollback etc.
- Verantwortung & Ownership: Wer kümmert sich um die laufenden Modelle (Domäne, IT, zentrales Data-Team)? Data Mesh kann das verteilen, was aber koordinativ komplex wird.

# 8. Überwachung & Qualitätskontrolle (Monitoring / Governance)

***Beschreibung***

Die Daten und Modelle müssen im laufenden Betrieb überwacht werden, um Probleme (Qualitätsabfall, Performance-Einbußen, Compliance-Verstöße) rechtzeitig zu erkennen.

***Typische Aufgaben***

- Data Observability (Monitoring von Datenströmen, Timeliness, Anomalien in Datenqualität).
- Modell-Monitoring (Drift-Erkennung, Accuracy im Zeitverlauf).
- Audits und Compliance-Checks (DSGVO, HIPAA, SOX etc.).

***Herausforderungen***

- Ganzheitliches Monitoring: Tools wie Databricks geben Einblicke in Spark-Jobs, Unity Catalog in Metadaten-Governance – trotzdem muss man meist mehrere Monitoring-Lösungen kombinieren (Cloud-Logs, BI-Performance, Modell-Monitoring).
- Data Mesh-Komplexität: Verteilt man Daten- und Modellverantwortung auf viele Domänen, steigt der Aufwand für einheitliche KPI-Definitionen und Alerts exponentiell.

# 9. Archivierung & Löschung (Retention / Disposal)

***Beschreibung***

Irgendwann werden Daten (oder Modelle) nicht mehr benötigt, bzw. müssen aus rechtlichen Gründen archiviert oder gelöscht werden.

***Typische Aufgaben***

- Definieren von Aufbewahrungsfristen (Retention Policies).
- Automatisierte Abläufe zum Löschen / Archiving in günstigeren Speichern (Glacier, Cold Storage etc.).
- Sicherstellen rechtlicher Vorgaben (z. B. DSGVO: "Recht auf Vergessenwerden").

***Herausforderungen***

- Data Mesh: In einem dezentralen Modell ist es schwerer durchzusetzen, dass Daten überall korrekt gelöscht werden, wenn mehrere Domänen Kopien/Transformationsstufen unterhalten.
- Metadaten: Nur wenn man weiß, wo welche Daten liegen, kann man korrekt archivieren oder löschen. Eine zentrale Übersicht ist bei vielen Domänen nicht trivial.
