# Dev Ops Exam 2024

### Leveranser:
#### Oppgave 1A:

##### HTTP Endpoint

**URL**:  
`https://21mwyqqxf9.execute-api.eu-west-1.amazonaws.com/Prod/generate-image`

**Method**:  
`POST`

**Headers**:
- `Content-Type: application/json`

##### Request Body
Send en JSON-payload med en `prompt` som beskriver hva slags bilde som skal genereres.

```json
{
  "prompt": "A programmer sitting at a desk with multiple screens, wearing a hoodie, with a cup of coffee by their side. Code is displayed on the screens, and there are sticky notes on the wall with programming-related reminders."
}
```

#### Oppgave 1B:
[Vellykket kjøring av GitHub Actions workflow som har deployet SAM-applikasjonen til AWS.](https://github.com/Svendzen/DevOpsExam2024/actions/runs/11801530824)


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
