---
kind: Note
status: draft
title: noEA
subtitle: Graph Operations
aliases:
  - noEA - Graphoperationen
  - noEA - Graph Operations
author:
  - nemron
version: "0.1"
tags:
dateCreated: 2026-02-02T22:13:32.000+01:00
dateModified: 2026-02-02T22:14:41.243+01:00
---

# General

## Graph Algorithms in Pangrm?

Man könnte unter `Pangrm.Core.Graph.Algorithm` oder `Pangrm.Mod(ify)` Graphalgorithmen zur Verfügung stellen.

Ist ggf. schlecht über CLI steuerbar --- sprich, wir ruft man das über die Kommmandozeile auf? Und... welche Algorithmen sollen das denn sein?

Sollte das wirklich Teil von Pangrm sein?

# Merge

Wie verbinde ich Graphmodelle aus unterschiedlichen Quellen?

## Ontologie-getrieben?

### via Panmod

```
-- pg ~ PanmodGraph
let
  beam = panmod —-from ldif —-to pg
  dcat = panmod —-from dcat —-to pg
  all = beam <> dcat
  -— ^ hier ggf. "Ontologie" übergeben
in neoject . panmod -f pg -t cql $ all
```

Wobei wenn `beam` und `dcat` bereits PanmodGraphen sind, wofür braucht dann der Kombinator eine Ontologie?

Unabhängig davon ist es interessant darüber nachzudenken ob PanmodGraph einen Monoiden bildet. Was passiert wenn man zwei PanmodGraphen zusammenführen will?

### via Neo4j

Oder sollte man das eher mit Hilfe der Neo4j DB machen? Graphen in Neo4j sprich über Cypher Statements verbinden?

```
> neopop beam.cql
> neopop dcat.cql
> neopop combine.cql
```

Man hat BEAM und den Data Catalog nacheinander in Neo geladen. Nun führt man die beiden entweder direkt in Neo4j via Cypher (`combine.cql`) zusammen oder man schreibt ein Programm welches die Zusammenführung via der Neo4j API durchgeführt.

In beiden Fällen ist der Einsatz von Ontologien nicht ausgeschlossen.

Im ersten Fall würde man die Ontologie via Panmod und NeoJect in Neo4j zu den beiden anderen dazu laden und könnte diesen dritten Graphen zur Zusammenführung in den Cypher Statements nutzen. Für das Programm gilt das analog.
