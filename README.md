# Dev Ops Exam 2024

### Leveranser:
#### Oppgave 1A:

##### HTTP Endpoint

* **URL**: `https://21mwyqqxf9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image`
* **Method**: `POST`
* **Headers**: `Content-Type: application/json`
* **Request Body**: Send en JSON-payload med en `prompt` som beskriver hva slags bilde som skal genereres. For eksempel:

```json
{
  "prompt": "A programmer sitting at a desk with multiple screens, wearing a hoodie, with a cup of coffee by their side. Code is displayed on the screens, and there are sticky notes on the wall with programming-related reminders."
}
```

#### Oppgave 1B:
**Lenke til kjørt GitHub Actions workflow for SAM-applikasjon på AWS:**

- [Vellykket kjøring av GitHub Actions workflow som har deployet SAM-applikasjonen til AWS.](https://github.com/Svendzen/DevOpsExam2024/actions/runs/11801530824)


### Oppgave 2:

1. **Lenke til kjørt GitHub Actions workflow på main**: 
    
    [Vellykket workflow for terraform apply på main](https://github.com/Svendzen/DevOpsExam2024/actions/runs/11838298317)
   

2. **Lenke til en fungerende GitHub Actions workflow på en annen branch**: 
    
    [Vellykket workflow for terraform plan på annen branch](https://github.com/Svendzen/DevOpsExam2024/actions/runs/11838167156)
   

3. **SQS-Kø URL**: 
 
    `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-9`
    
    Eksempel på hvordan sende melding til køen:

    ```console 
    aws sqs send-message \ --queue-url "https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-9" \ --message-body "En katt og en hund som utforsker verdensrommet sammen, svevende blant stjernene med små astronautdrakter" 
    ```

### Oppgave 3

1. **Beskrivelse av taggestrategi:**
    
    Jeg har valgt å bruke taggen `latest` for container imagene. Dette gjør at imaget alltid viser til den nyeste, stabile versjonen etter en vellykket push til main-branchen. Grunnen til at jeg bruker `latest`, er at det forenkler versjonsstyringen for teamet. Da kan de alltid være sikre på at de bruker den mest oppdaterte versjonen ved å referere til denne taggen. Senere kan det være aktuelt å gå over til en taggestrategi basert på versjonsnumre (som `v1.0`, `v1.1`), for eksempel hvis vi trenger å støtte eldre versjoner eller ruller ut større oppdateringer.

2. **Container image + SQS URL:**
   
     Docker Hub image: svendzen/sqs-client:latest
    SQS URL: `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-9`
    
    Med denne kommandoen kan man kjøre imaget og sende en melding til SQS-køen (Legg inn egne AWS Credentials):
    ```console 
        docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-9 svendzen/sqs-client:latest "A magical salmon going to the moon in a rocket"
    ```

### Oppgave 4
 **Viktig!** Legg inn e-postadressen som skal motta varsler i en fil kalt terraform.tfvars under infra-mappen. Bruk variabelen alert_email til dette.

Slik så det ut når jeg trigget alarmen med en threshold på 30 sekunder:
![Bilde som viser at alarmen utløses i CloudWatch](img/Screenshot_Alarm.png)


### Oppgave 5

#### 1. Automatisering og kontinuerlig levering (CI/CD): Hvordan påvirker serverless-arkitektur sammenlignet med mikrotjenestearkitektur CI/CD-pipelines, automatisering, og utrullingsstrategier?

Automatisering og kontinuerlig levering (CI/CD) er sentralt i moderne utviklingsprosesser. I en serverless arkitektur kan CI/CD-pipelines bli mer komplekse fordi hver funksjon ofte har sin egen livssyklus. Dette betyr at utrullingen må håndtere flere små komponenter, noe som kan føre til økt vedlikeholdsarbeid. Verktøy som Terraform og AWS SAM hjelper med å automatisere denne prosessen ved å definere infrastruktur som kode, slik at både funksjoner og tilhørende ressurser kan rulles ut konsistent.

I mikrotjenestearkitekturer er det færre, men større komponenter, som gjør CI/CD-pipelines mer oversiktlige. Hver tjeneste har sin egen pipeline for bygging, testing og utrulling. For eksempel kan Docker brukes til å bygge containere for hver tjeneste, som deretter distribueres via Docker Hub. GitHub Actions kan integreres for å automatisere bygging og distribusjon av disse containerne, noe vi har gjort i arbeidet med å publisere Java-SQS-klienten.

En fordel med serverless er at infrastrukturen administreres av skyleverandøren, slik at teamet kan fokusere mer på koden og mindre på drift. Dette kan forenkle deler av CI/CD-pipelines ved å eliminere behovet for å konfigurere og vedlikeholde servere. Samtidig kan det være utfordrende å teste funksjoner lokalt, siden de ofte er tett integrert med skytjenester som Amazon SQS og DynamoDB. Verktøy som SAM CLI kan simulere sky-miljøet for å lette lokal testing.

I mikrotjenester er lokal testing ofte enklere, fordi alle avhengigheter kan kjøres som containere ved hjelp av Docker Compose. Dette gir fleksibilitet til å teste hele systemet uten å være avhengig av skytjenester. Likevel krever mikrotjenester mer arbeid med administrasjon av infrastrukturen, spesielt når det gjelder skalering og oppdatering.

Når det gjelder utrullingsstrategier, gir serverless muligheten til å implementere utrulling på funksjonsnivå. Oppdateringer kan rulles ut for en spesifikk funksjon uten å påvirke andre deler av systemet. Mikrotjenester krever ofte utrulling av hele tjenesten, selv ved små endringer, noe som kan øke risikoen for nedetid.

Versjonskontroll er en annen utfordring i serverless. Hver funksjon kan ha sin egen versjon, og det krever nøye oppfølging for å sikre kompatibilitet mellom komponentene. Dette kan være mer komplisert enn i mikrotjenester, hvor hele tjenesten oppdateres som en enhet.

Oppsummert krever serverless arkitekturer mer detaljerte pipelines for hver funksjon, men gir raskere skalerbarhet og distribusjon. Mikrotjenester har enklere CI/CD-strukturer, men krever mer innsats i infrastrukturadministrasjon. Valget mellom disse tilnærmingene avhenger av prosjektets kompleksitet og behovet for fleksibilitet i utvikling og utrulling.

#### 2. Observability (overvåkning): Hvordan endres overvåkning, logging og feilsøking når man går fra mikrotjenester til en serverless arkitektur? Hvilke utfordringer er spesifikke for observability i en FaaS-arkitektur?

Overvåkning, logging og feilsøking endrer seg når man går fra en mikrotjenestearkitektur til en serverless arkitektur. I mikrotjenester har man ofte tilgang til hele tjenestens loggdata og ressurser, noe som gjør det enklere å følge en forespørsel gjennom systemet. Ved å samle logger i sentraliserte systemer som Elasticsearch, får man en helhetlig oversikt over ytelse og feil. Docker-containere kan konfigureres til å sende logger til en felles plattform, noe som sikrer konsistent overvåkning.

I en serverless arkitektur, som med AWS Lambda, er applikasjonen delt opp i små, selvstendige funksjoner. Hver funksjon genererer sine egne loggdata, typisk i AWS CloudWatch. Dette kan føre til fragmentert logging, og det kan være utfordrende å spore en forespørsel gjennom flere funksjoner og tjenester som Amazon SQS eller DynamoDB (en NoSQL-databasetjeneste fra AWS). Verktøy som AWS X-Ray kan brukes for å visualisere og feilsøke slike distribuerte systemer ved å samle inn data om hvordan forespørsler flyter gjennom systemet.

Serverless gir fordeler når det gjelder automatisk overvåkning av ytelse og ressursbruk. Tjenester som CloudWatch Metrics kan overvåke spesifikke måledata, som antall forespørsler eller responstid for Lambda-funksjoner. For eksempel har vi brukt Terraform til å sette opp en CloudWatch-alarm på ApproximateAgeOfOldestMessage i en SQS-kø, for å varsle hvis meldinger blir forsinket.

En spesifikk utfordring i serverless er fenomenet "cold starts". Dette skjer når en funksjon må starte opp fra inaktiv tilstand, noe som kan føre til økt responstid. Cold starts kan være vanskelige å oppdage uten spesifikk overvåkning og logging, og kan påvirke brukeropplevelsen negativt.

I mikrotjenester har utviklere full kontroll over applikasjonen og infrastrukturen, noe som gjør det enklere å implementere tilpasset logging og overvåkning. Dette kan være fordelaktig for feilsøking og ytelsesanalyse, men krever mer arbeid for å sette opp og vedlikeholde, spesielt i store systemer med mange tjenester.

Oppsummert gir serverless arkitekturer fordeler med automatisert overvåkning og innebygd skalerbarhet, men krever avanserte verktøy for å håndtere fragmentert logging og feilsøking. Mikrotjenester gir mer kontroll og fleksibilitet i overvåkning, men krever større innsats for å oppnå samme nivå av innsikt. Valget mellom disse tilnærmingene avhenger av behovet for detaljert innsikt kontra enkel konfigurasjon og vedlikehold.

#### 3. Skalerbarhet og kostnadskontroll: Diskuter fordeler og ulemper med tanke på skalerbarhet, ressursutnyttelse, og kostnadsoptimalisering i en serverless kontra mikrotjenestebasert arkitektur.

Serverless arkitektur tilbyr betydelige fordeler når det gjelder skalerbarhet. AWS Lambda muliggjør automatisk skalering ved økt trafikk og skalerer ned til null når det ikke er aktivitet. Dette reduserer behovet for manuell ressursadministrasjon. I en mikrotjenestearkitektur kreves det ofte mer arbeid, som å konfigurere autoskalering med EC2-instanser eller Kubernetes. Selv om mikrotjenester gir mer kontroll over ressursene, kan dette være mer tidkrevende.

Når det gjelder kostnader, er serverless ofte kostnadseffektivt for applikasjoner med ujevn eller lav trafikk, siden man kun betaler for faktisk bruk. For eksempel betaler man kun for kjøring av Lambda-funksjoner, mens mikrotjenester ofte kjører på dedikerte ressurser som må betales for kontinuerlig, uavhengig av bruk. Imidlertid kan kostnadene ved serverless øke raskt hvis trafikken er høy og jevn over tid, noe som gjør det viktig å overvåke kostnadene nøye ved hjelp av verktøy som AWS Cost Explorer eller CloudWatch.

I systemer som bruker meldingskøer som Amazon SQS, kan det oppstå forsinkelser hvis meldinger hoper seg opp. CloudWatch-metrikken ApproximateAgeOfOldestMessage kan gi verdifull innsikt i systemets ytelse. Serverless arkitekturer gjør det enklere å skalere individuelle funksjoner for å håndtere slike scenarioer, men krever mer overvåkning for å sikre at alle komponenter fungerer optimalt.

Mikrotjenester gir ofte mer forutsigbare kostnader fordi ressursbruken er mer stabil. Dette kan være en fordel ved budsjettering, men gir mindre fleksibilitet til å optimalisere kostnader for arbeidsbelastninger som varierer. Serverless gir større fleksibilitet ved dynamiske behov, men krever god innsikt i systemet for å holde kostnadene under kontroll.

En hybrid tilnærming kan være fordelaktig, der man bruker serverless for deler av systemet med uforutsigbar trafikk og mikrotjenester for oppgaver med jevn belastning. Dette kombinerer styrkene fra begge arkitekturer. Valget mellom serverless og mikrotjenester bør baseres på forståelse av applikasjonens behov, trafikkmønster og tilgjengelige ressurser.

#### 4. Eierskap og ansvar: Hvordan påvirkes DevOps-teamets eierskap og ansvar for applikasjonens ytelse, pålitelighet og kostnader ved overgang til en serverless tilnærming sammenlignet med en mikrotjeneste-tilnærming?

Overgangen til en serverless arkitektur endrer DevOps-teamets ansvar for applikasjonens ytelse, pålitelighet og kostnader. I en serverless tilnærming, som med AWS Lambda, tar skyleverandøren hånd om mye av den operasjonelle driften, inkludert serveradministrasjon, skalering og oppdateringer. Dette lar teamet fokusere mer på kjernefunksjonalitet og mindre på infrastruktur.

Samtidig må teamet være oppmerksom på kostnadskontroll, siden betalingen er basert på faktisk bruk. Ineffektive funksjoner eller dårlig utformede arbeidsflyter kan føre til uforutsette kostnader. Bruk av verktøy som Terraform for å definere og overvåke ressurser kan gi bedre oversikt og kontroll over infrastrukturen, og bidra til å unngå kostnadsoverraskelser.

I en mikrotjenestearkitektur har DevOps-teamet større ansvar for infrastrukturen. De må konfigurere, vedlikeholde og skalere tjenestene manuelt eller ved hjelp av egne verktøy. Docker-containere og orkestreringssystemer som Kubernetes brukes ofte til dette. Selv om dette gir mer kontroll over applikasjonens ytelse og pålitelighet, krever det også mer tid og teknisk kompetanse.

Når det gjelder pålitelighet, gir serverless innebygd høy tilgjengelighet, siden funksjonene kjøres på administrerte tjenester som automatisk skalerer ved behov. Dette kan redusere risikoen for nedetid. Mikrotjenester kan være mer utsatt for feil hvis de ikke er riktig konfigurert eller overvåket, men gir mulighet for tilpasninger som kan forbedre ytelsen.

Eierskapet til applikasjonens livssyklus blir mer fragmentert i en serverless arkitektur. Siden hver funksjon kan deployeres og administreres separat, må teamet ha klare strategier for versjonskontroll og overvåkning. Dette kan kompliseres hvis funksjonene interagerer med ulike tjenester som Amazon SQS eller DynamoDB, hver med sine egne konfigurasjoner.

I mikrotjenester beholder teamet fullt eierskap over hele applikasjonen og infrastrukturen, noe som gir mer kontroll, men også mer ansvar. Automatisering gjennom CI/CD-pipelines, som med GitHub Actions, er viktig for effektiv utrulling og endringshåndtering i begge arkitekturer.

Oppsummert gir serverless fordeler som redusert operasjonelt ansvar og innebygd skalerbarhet, men krever nøye kostnadskontroll og koordinering. Mikrotjenester gir større fleksibilitet og kontroll, men krever mer innsats fra teamet for å sikre ytelse og pålitelighet. Valget mellom disse tilnærmingene bør baseres på prosjektets behov for skalerbarhet, kontroll og tilgjengelige ressurser.
