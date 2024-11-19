# Variabel for e-postadressen som mottar varsler. Denne settes i .tfvars fil.
variable "alert_email" {
  description = "E-postadresse for å motta alarmer."
  type        = string
}

# Variabel for aldergrensen (i sekunder) for den eldste meldingen i køen før alarmen trigges.
variable "age_threshold" {
  description = "Aldersgrensen for ApproximateAgeOfOldestMessage i sekunder."
  type        = number
  default     = 30 # Eksempelterskel, kan justeres
}