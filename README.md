# Dev Ops Exam 2024

### Leveranser:
#### Oppgave 1A:

##### HTTP Endpoint

* **URL**: `https://21mwyqqxf9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image`
* **Method**: `POST`
* **Headers**: `Content-Type: application/json`

##### Request Body
Send en JSON-payload med en `prompt` som beskriver hva slags bilde som skal genereres.

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
    
    Eksempel:

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
**Viktig!** Sett e-postadressen som skal få alerts i en "terraform.tfvars" fil under infra mappen og kall variabelen "alert_email".


Slik så det ut når jeg trigget alarmen med en threshold på 30 sekunder:
![Bilde som viser at alarmen utløses i CloudWatch](img/Screenshot_Alarm.png)