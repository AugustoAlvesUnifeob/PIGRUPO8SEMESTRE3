#include <WiFi.h>
#include <HTTPClient.h>
#include <LiquidCrystal.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

LiquidCrystal lcd(21, 22, 19, 18, 4, 23);

const char* ssid = "Home-Alves-2.4Ghz";
const char* password = "06bc047bea"; 

// Sensor
const byte pinoFototransistor = 34;
int referencia = 600;
int contador = 0;
int lote = 0;
bool estadoAnterior = false;

int ultimoContadorEnviado = 0;

unsigned long ultimoEnvio = 0;
const unsigned long intervaloEnvio = 60000;

int acumuladorLeitura = 0;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -10800, 60000);

String projectId = "pi-grupo8";

void getDateAndTimeStrings(time_t epochTime, String &dateOut, String &timeOut);
void enviarParaFirestore(int leitura, int lote, String data, String hora);

void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  int tentativas = 0;
  while (WiFi.status() != WL_CONNECTED && tentativas < 20) {
    delay(1000);
    Serial.print(".");
    tentativas++;
  }

  Serial.println();
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Conectado!");
    Serial.print("IP: "); Serial.println(WiFi.localIP());
  } else {
    Serial.println("Falha ao conectar WiFi.");
  }

  lcd.begin(16,2);
  lcd.setCursor(0,0); lcd.print("Contador: 0");
  lcd.setCursor(0,1); lcd.print("Lote(s): 0");

  timeClient.begin();
}

void loop() {
  timeClient.update();

  int leituraSensor = analogRead(pinoFototransistor);

  if (leituraSensor > referencia) {
    if (!estadoAnterior) {
      contador++;
      estadoAnterior = true;

      if (contador >= 50) {
        contador = 0;
        lote++;
        lcd.clear();
        lcd.setCursor(0,0); lcd.print("Contador: 0");
        lcd.setCursor(0,1); lcd.print("Lote(s): ");
        lcd.setCursor(9,1); lcd.print(lote);
      } else {
        lcd.setCursor(10,0); lcd.print("   ");
        lcd.setCursor(10,0); lcd.print(contador);
      }

      int diferenca = contador - ultimoContadorEnviado;

      if (diferenca > 0) {
        acumuladorLeitura += diferenca;
        ultimoContadorEnviado = contador;
      }

      delay(200);
    }
  } else {
    estadoAnterior = false;
  }

  if (millis() - ultimoEnvio >= intervaloEnvio) {

    if (acumuladorLeitura > 0) {

      time_t epochTime = timeClient.getEpochTime();
      String dataFormatada, horaFormatada;
      getDateAndTimeStrings(epochTime, dataFormatada, horaFormatada);

      enviarParaFirestore(acumuladorLeitura, lote, dataFormatada, horaFormatada);

      Serial.print("Enviado acumulado: ");
      Serial.println(acumuladorLeitura);

      acumuladorLeitura = 0;
    }

    ultimoEnvio = millis();
  }

  delay(50);
}

void getDateAndTimeStrings(time_t epochTime, String &dateOut, String &timeOut) {
  struct tm *ptm = gmtime((time_t *)&epochTime);

  char bufDate[11];
  char bufTime[9];

  sprintf(bufDate, "%04d-%02d-%02d",
          ptm->tm_year + 1900,
          ptm->tm_mon + 1,
          ptm->tm_mday);

  sprintf(bufTime, "%02d:%02d:%02d",
          ptm->tm_hour,
          ptm->tm_min,
          ptm->tm_sec);

  dateOut = String(bufDate);
  timeOut = String(bufTime);
}

void enviarParaFirestore(int leitura, int lote, String data, String hora) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi desconectado!");
    return;
  }

  HTTPClient http;

  String url = "https://firestore.googleapis.com/v1/projects/" + projectId + "/databases/(default)/documents/LogsPHR";

  StaticJsonDocument<1024> doc;
  JsonObject fields = doc.createNestedObject("fields");

  fields.createNestedObject("dataleitura")["stringValue"] = data;
  fields.createNestedObject("horaleitura")["stringValue"] = hora;
  fields.createNestedObject("leitura")["integerValue"] = String(leitura);
  fields.createNestedObject("lote")["integerValue"] = String(lote);
  fields.createNestedObject("idSensor")["stringValue"] = "";

  String jsonString;
  serializeJson(doc, jsonString);

  http.begin(url);
  http.addHeader("Content-Type", "application/json");

  int httpResponseCode = http.POST(jsonString);

  if (httpResponseCode > 0) {
    Serial.print("Firestore OK: ");
    Serial.println(httpResponseCode);
  } else {
    Serial.print("Erro Firestore: ");
    Serial.println(http.errorToString(httpResponseCode));
  }

  http.end();
}