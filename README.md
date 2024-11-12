# Dev Ops Exam 2024

### Leveranser:
#### Leveranse 1A:

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
